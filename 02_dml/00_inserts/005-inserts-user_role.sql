INSERT INTO user_roles (
    fk_user_id,
    fk_role_id,
    assigned_at,
    status,
    created_at,
    updated_at
)
SELECT
    u.user_id,
    r.role_id,
    CURRENT_TIMESTAMP,
    TRUE,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM users u
CROSS JOIN roles r
WHERE u.email IN (
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
AND r.role_name = 'USER';
