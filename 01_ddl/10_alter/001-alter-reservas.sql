ALTER TABLE reservas
ALTER COLUMN estado TYPE VARCHAR(20);

ALTER TABLE reservas
DROP CONSTRAINT IF EXISTS chk_reservas_estado;

ALTER TABLE reservas
ADD CONSTRAINT chk_reservas_estado
CHECK (
    estado IN (
        'PENDIENTE',
        'ASIGNADA',
        'EN_PROCESO',
        'FINALIZADA',
        'CANCELADA'
    )
);