BEGIN;

-- Lista de correos objetivo
WITH target_users AS (
    SELECT user_id 
    FROM users 
    WHERE email IN (
        'juan.gomez@correo.com',
        'maria.rodriguez@correo.com',
        'carlos.martinez@correo.com',
        'laura.torres@correo.com',
        'andres.ramirez@correo.com',
        'diana.lopez@correo.com',
        'felipe.castro@correo.com',
        'valentina.diaz@correo.com',
        'santiago.moreno@correo.com',
        'camila.suarez@correo.com'
    )
)
-- 1. Eliminar reservas asociadas a los vehículos de estos usuarios
DELETE FROM reservas 
WHERE fk_id_vehiculo IN (
    SELECT id_vehiculo FROM vehiculos WHERE fk_id_usuario IN (SELECT user_id FROM target_users)
);

-- 2. Eliminar TODOS los vehículos pertenecientes a estos usuarios (sin importar la placa)
DELETE FROM vehiculos 
WHERE fk_id_usuario IN (SELECT user_id FROM target_users);

-- 3. Eliminar roles asignados a estos usuarios
DELETE FROM user_roles 
WHERE fk_user_id IN (SELECT user_id FROM target_users);

-- 4. Eliminar usuarios
DELETE FROM users 
WHERE user_id IN (SELECT user_id FROM target_users);

COMMIT;