-- 1. Eliminar la restricción actual en mayúsculas
ALTER TABLE reservas
DROP CONSTRAINT IF EXISTS reservas_estado_check;

-- 2. Convertir los datos existentes de nuevo a minúsculas
UPDATE reservas
SET estado = LOWER(estado);

-- 3. Volver a crear el CHECK con los valores originales en minúscula
ALTER TABLE reservas
ADD CONSTRAINT reservas_estado_check
CHECK (
    estado IN (
        'pendiente',
        'asignada',
        'en_proceso',
        'finalizada',
        'cancelada'
    )
);