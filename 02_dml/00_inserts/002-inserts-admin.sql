INSERT INTO users (user_id, email, first_name, last_name, phone_number, document_type, document_number, password, profile_picture, status)
VALUES (
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    'mrtinez.stiven@gmail.com',
    'Stiven',
    'perdomo',
    '3122677170',
    'CC',
    '1075793962',
    '$2a$10$KZco0B.z5h/c5LEUCAjR7uIUa8e.H5IfWEfQ41ZwM55OWiyzw7psS',
    'avatar_1',
    true
);

INSERT INTO users (user_id, email, first_name, last_name, phone_number, document_type, document_number, password, profile_picture, status)
VALUES (
    'b2c3d4e5-f6a7-8901-bcde-f12345678901',
    'admin@gmail.com',
    'santiago',
    'gordo',
    '3009876543',
    'CC',
    '100000002',
    '$2a$10$vTX1kVGAclZZ2T0BjXt0W.nqsy31sbfNBCOCM9ohy3STHT2Lv/9Ay',
    'avatar_1',
    true
);

INSERT INTO user_roles (fk_user_id, fk_role_id, status)
VALUES (
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    '908bcaf5-f138-44a9-84a5-7e127b422631',
    true
);

INSERT INTO user_roles (fk_user_id, fk_role_id, status)
VALUES (
    'b2c3d4e5-f6a7-8901-bcde-f12345678901',
    '908bcaf5-f138-44a9-84a5-7e127b422631',
    true
);