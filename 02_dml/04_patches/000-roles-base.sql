INSERT INTO roles (role_id, role_name, description)
VALUES (gen_random_uuid(), 'USER', 'Usuario'),
       (gen_random_uuid(), 'OPERATOR', 'Operador'),
       (gen_random_uuid(), 'ADMIN', 'Administrador')
ON CONFLICT (role_name) DO NOTHING;
