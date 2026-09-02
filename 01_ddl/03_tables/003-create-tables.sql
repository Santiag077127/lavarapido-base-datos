CREATE TABLE reservas (
    id_reserva        UUID          PRIMARY KEY,
    fk_id_usuario     UUID          NOT NULL,
    fk_id_vehiculo    UUID          NOT NULL,
    fk_id_servicio    UUID          NOT NULL,
    fecha_reserva     DATE          NOT NULL,
    hora_reserva      TIME          NOT NULL,
    fecha_hora_inicio TIMESTAMP,
    fecha_hora_fin    TIMESTAMP,
    estado            VARCHAR(15)   NOT NULL DEFAULT 'pendiente',
    created_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reservas_usuario
        FOREIGN KEY (fk_id_usuario)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_reservas_vehiculos
        FOREIGN KEY (fk_id_vehiculo)
        REFERENCES vehiculos(id_vehiculo)
        ON DELETE RESTRICT,
    CONSTRAINT fk_reservas_servicios
        FOREIGN KEY (fk_id_servicio)
        REFERENCES servicios(id_servicio)
        ON DELETE RESTRICT,
    CONSTRAINT chk_reservas_estado
        CHECK (estado IN (
            'pendiente', 'asignada', 'en_proceso', 'finalizada', 'cancelada'
        )),
    CONSTRAINT chk_hora_reserva
        CHECK (hora_reserva >= '06:00' AND hora_reserva <= '20:00'),
    CONSTRAINT chk_reservas_fechas_logicas
        CHECK (
            fecha_hora_fin IS NULL OR
            fecha_hora_fin > fecha_hora_inicio
        )
);  