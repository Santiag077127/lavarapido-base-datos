
ALTER TABLE reservas
ALTER COLUMN estado TYPE VARCHAR(20);

ALTER TABLE reservas
DROP CONSTRAINT IF EXISTS reservas_estado_check;

ALTER TABLE reservas
ADD CONSTRAINT reservas_estado_check
CHECK (
    estado IN (
        'PENDIENTE',
        'ASIGNADA',
        'EN_PROCESO',
        'FINALIZADA',
        'CANCELADA'
    )
);
