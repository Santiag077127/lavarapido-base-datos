INSERT INTO vehiculos (
    id_vehiculo,
    fk_id_usuario,
    fk_id_marca,
    placa,
    color,
    tipo_vehiculo,
    estado,
    created_at,
    updated_at
)
VALUES
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'juan.gomez@correo.com'),      (SELECT id_marca FROM marcas WHERE nombre = 'CHEVROLET'), 'ABC123', 'Blanco',   'CARRO',      TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'maria.rodriguez@correo.com'), (SELECT id_marca FROM marcas WHERE nombre = 'TOYOTA'),    'DEF456', 'Gris',     'CARRO',      TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'carlos.martinez@correo.com'), (SELECT id_marca FROM marcas WHERE nombre = 'FORD'),      'GHI789', 'Negro',    'CAMIONETA',  TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'laura.torres@correo.com'),    (SELECT id_marca FROM marcas WHERE nombre = 'JEEP'),      'JKL012', 'Rojo',     'CAMIONETA',  TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'andres.ramirez@correo.com'),  (SELECT id_marca FROM marcas WHERE nombre = 'YAMAHA'),    'MNO345', 'Azul',     'MOTO',       TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'diana.lopez@correo.com'),     (SELECT id_marca FROM marcas WHERE nombre = 'HONDA'),     'PQR678', 'Negro',    'MOTO',       TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'felipe.castro@correo.com'),   (SELECT id_marca FROM marcas WHERE nombre = 'BAJAJ'),     'STU901', 'Verde',    'MOTO',       TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'valentina.diaz@correo.com'),  (SELECT id_marca FROM marcas WHERE nombre = 'AKT'),       'VWX234', 'Amarillo', 'MOTOCARRO',  TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'santiago.moreno@correo.com'), (SELECT id_marca FROM marcas WHERE nombre = 'HYUNDAI'),   'YZA567', 'Blanco',   'FURGONETA',  TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (gen_random_uuid(), (SELECT user_id FROM users WHERE email = 'camila.suarez@correo.com'),   (SELECT id_marca FROM marcas WHERE nombre = 'KENWORTH'),  'BCD890', 'Gris',     'PESADO',     TRUE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
