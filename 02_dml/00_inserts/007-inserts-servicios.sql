
-- ============================================================
-- INSERTS INICIALES DE SERVICIOS
-- ============================================================

INSERT INTO servicios (
    id_servicio,
    nombre,
    descripcion,
    precio,
    duracion_minutos
)
VALUES
(
    gen_random_uuid(),
    'Lavado Básico',
    'Lavado exterior del vehículo y limpieza básica de vidrios.',
    15000,
    30
),
(
    gen_random_uuid(),
    'Lavado Completo',
    'Lavado exterior, limpieza interior, aspirado y limpieza de vidrios.',
    25000,
    60
),
(
    gen_random_uuid(),
    'Lavado Premium',
    'Lavado completo con limpieza profunda de interiores y acabados especiales.',
    40000,
    90
),
(
    gen_random_uuid(),
    'Lavado de Moto',
    'Lavado exterior y limpieza general de motocicleta.',
    10000,
    30
),
(
    gen_random_uuid(),
    'Lavado SUV',
    'Lavado completo especializado para vehículos tipo SUV.',
    30000,
    75
);
