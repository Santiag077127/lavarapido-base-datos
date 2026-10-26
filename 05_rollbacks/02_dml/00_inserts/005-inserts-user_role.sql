DELETE FROM user_roles 
WHERE fk_user_id IN (
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
AND fk_role_id = (SELECT role_id FROM roles WHERE role_name = 'USER');