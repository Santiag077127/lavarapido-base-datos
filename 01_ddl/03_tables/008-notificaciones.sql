CREATE TABLE notificaciones (
    id_notificacion UUID PRIMARY KEY,
    fk_id_usuario UUID NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    clave_evento VARCHAR(180) NOT NULL,
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('booking', 'payment', 'status', 'system')),
    titulo VARCHAR(160) NOT NULL,
    mensaje VARCHAR(500) NOT NULL,
    fk_id_reserva UUID REFERENCES reservas(id_reserva) ON DELETE RESTRICT,
    fk_id_pago UUID REFERENCES pagos(id_pago) ON DELETE RESTRICT,
    leida_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_notificacion_evento_usuario UNIQUE (fk_id_usuario, clave_evento)
);
