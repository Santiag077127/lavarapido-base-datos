-- Cambio incremental: conservar precio/duración de la reserva y evitar solapamientos.
-- Una instalación con reservas históricas superpuestas falla cerrada al crear la
-- restricción; se debe revisar esa historia, nunca eliminarla automáticamente.
ALTER TABLE reservas
    ADD COLUMN precio_pactado NUMERIC(12,0),
    ADD COLUMN duracion_minutos_pactada INTEGER;

-- El pago ya registrado es la mejor evidencia del precio histórico. Cuando no
-- existe, se usa el precio actual del servicio y se documenta esta limitación.
UPDATE reservas r
SET precio_pactado = COALESCE(
        (SELECT p.monto FROM pagos p WHERE p.fk_id_reserva = r.id_reserva),
        s.precio
    ),
    duracion_minutos_pactada = s.duracion_minutos
FROM servicios s
WHERE s.id_servicio = r.fk_id_servicio;

ALTER TABLE reservas
    ALTER COLUMN precio_pactado SET NOT NULL,
    ALTER COLUMN duracion_minutos_pactada SET NOT NULL,
    ALTER COLUMN estado SET DEFAULT 'PENDIENTE',
    ADD CONSTRAINT chk_reservas_precio_pactado CHECK (precio_pactado > 0),
    ADD CONSTRAINT chk_reservas_duracion_pactada CHECK (duracion_minutos_pactada > 0);

CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE reservas
    ADD CONSTRAINT reservas_no_solapadas
    EXCLUDE USING gist (
        fk_id_vehiculo WITH =,
        tsrange(
            fecha_reserva + hora_reserva,
            fecha_reserva + hora_reserva
                + duracion_minutos_pactada * INTERVAL '1 minute',
            '[)'
        ) WITH &&
    ) WHERE (estado <> 'CANCELADA');
