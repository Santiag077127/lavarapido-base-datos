-- SOLO tras verificar fuera de banda las dos personas propietarias y sus UUID.
-- Ejecutar con psql -v ON_ERROR_STOP=1 -v owner1_id=... -v owner2_id=... -f ...
-- No modifica perfiles, UUID ni contraseñas. Para instalaciones nuevas usar la
-- herramienta interactiva OwnerProvisioningTool después del esquema sin semillas.
BEGIN;
LOCK TABLE users, user_roles IN SHARE ROW EXCLUSIVE MODE;
SELECT set_config('app.owner1_id', :'owner1_id', true);
SELECT set_config('app.owner2_id', :'owner2_id', true);

DO $check$
DECLARE
  first_id uuid := current_setting('app.owner1_id')::uuid;
  second_id uuid := current_setting('app.owner2_id')::uuid;
BEGIN
  IF first_id = second_id OR
     (SELECT count(*) FROM users WHERE user_id IN (first_id, second_id) AND status) <> 2 OR
     (SELECT count(*) FROM roles WHERE role_name = 'ADMIN') <> 1 THEN
    RAISE EXCEPTION 'Se requieren dos perfiles distintos, existentes y activos';
  END IF;
END
$check$;

-- Una cuenta propietaria debe tener solo ADMIN activo. Todas las demás
-- asignaciones ADMIN se revocan; sus perfiles se conservan.
UPDATE user_roles ur SET status = false, revoked_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP
FROM roles r
WHERE r.role_id = ur.fk_role_id AND ur.status
  AND (r.role_name = 'ADMIN' AND ur.fk_user_id NOT IN
       (current_setting('app.owner1_id')::uuid, current_setting('app.owner2_id')::uuid)
       OR r.role_name <> 'ADMIN' AND ur.fk_user_id IN
       (current_setting('app.owner1_id')::uuid, current_setting('app.owner2_id')::uuid));

INSERT INTO user_roles (fk_user_id, fk_role_id, status)
SELECT owner_id, r.role_id, true
FROM (VALUES (current_setting('app.owner1_id')::uuid),
             (current_setting('app.owner2_id')::uuid)) AS owners(owner_id)
CROSS JOIN roles r WHERE r.role_name = 'ADMIN'
ON CONFLICT (fk_user_id, fk_role_id)
DO UPDATE SET status = true, revoked_at = NULL, updated_at = CURRENT_TIMESTAMP;

DO $check$
BEGIN
  IF (SELECT count(*) FROM user_roles ur JOIN roles r ON r.role_id = ur.fk_role_id
      WHERE ur.status AND r.role_name = 'ADMIN') <> 2 THEN
    RAISE EXCEPTION 'La conciliación no produjo exactamente dos ADMIN';
  END IF;
END
$check$;
COMMIT;
