INSERT INTO users (
    user_id,
    email,
    first_name,
    last_name,
    phone_number,
    document_type,
    document_number,
    password,
    profile_picture,
    status,
    created_at,
    updated_at
)
VALUES
    (gen_random_uuid(), 'juan.gomez@correo.com',     'Juan',      'Gómez',      '3001234561', 'CC', '1001234561', crypt('Test1234', gen_salt('bf', 10)), 'avatar_1', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'maria.rodriguez@correo.com','María',     'Rodríguez',  '3001234562', 'CC', '1001234562', crypt('Test1234', gen_salt('bf', 10)), 'avatar_2', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'carlos.martinez@correo.com','Carlos',    'Martínez',   '3001234563', 'CC', '1001234563', crypt('Test1234', gen_salt('bf', 10)), 'avatar_3', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'laura.torres@correo.com',   'Laura',     'Torres',      '3001234564', 'CC', '1001234564', crypt('Test1234', gen_salt('bf', 10)), 'avatar_4', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'andres.ramirez@correo.com', 'Andrés',    'Ramírez',     '3001234565', 'CC', '1001234565', crypt('Test1234', gen_salt('bf', 10)), 'avatar_5', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'diana.lopez@correo.com',    'Diana',     'López',       '3001234566', 'CC', '1001234566', crypt('Test1234', gen_salt('bf', 10)), 'avatar_1', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'felipe.castro@correo.com',  'Felipe',    'Castro',      '3001234567', 'CC', '1001234567', crypt('Test1234', gen_salt('bf', 10)), 'avatar_2', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'valentina.diaz@correo.com', 'Valentina', 'Díaz',        '3001234568', 'CC', '1001234568', crypt('Test1234', gen_salt('bf', 10)), 'avatar_3', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'santiago.moreno@correo.com','Santiago',  'Moreno',       '3001234569', 'CC', '1001234569', crypt('Test1234', gen_salt('bf', 10)), 'avatar_4', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), 'camila.suarez@correo.com',  'Camila',    'Suárez',       '3001234570', 'CC', '1001234570', crypt('Test1234', gen_salt('bf', 10)), 'avatar_5', TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

