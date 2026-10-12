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

CREATE INDEX idx_notificaciones_usuario_fecha ON notificaciones(fk_id_usuario, created_at DESC);
CREATE INDEX idx_notificaciones_no_leidas ON notificaciones(fk_id_usuario) WHERE leida_at IS NULL;

CREATE TABLE dispositivos_push (
    id_dispositivo UUID PRIMARY KEY,
    fk_id_usuario UUID NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    instalacion_id VARCHAR(100) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dispositivos_instalacion UNIQUE (fk_id_usuario, instalacion_id)
);

CREATE TABLE notificacion_entregas (
    id_entrega UUID PRIMARY KEY,
    fk_id_notificacion UUID NOT NULL REFERENCES notificaciones(id_notificacion) ON DELETE CASCADE,
    canal VARCHAR(10) NOT NULL CHECK (canal IN ('email', 'push')),
    fk_id_dispositivo UUID REFERENCES dispositivos_push(id_dispositivo) ON DELETE RESTRICT,
    estado VARCHAR(12) NOT NULL DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'aceptada', 'confirmada', 'fallida')),
    intentos INTEGER NOT NULL DEFAULT 0 CHECK (intentos >= 0),
    proveedor_id VARCHAR(100),
    ultimo_error VARCHAR(255),
    proxima_ejecucion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enviada_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_entrega_dispositivo CHECK ((canal = 'push') = (fk_id_dispositivo IS NOT NULL))
);

CREATE UNIQUE INDEX uq_entrega_email ON notificacion_entregas(fk_id_notificacion) WHERE canal = 'email';
CREATE UNIQUE INDEX uq_entrega_push ON notificacion_entregas(fk_id_notificacion, fk_id_dispositivo) WHERE canal = 'push';
CREATE INDEX idx_entregas_pendientes ON notificacion_entregas(proxima_ejecucion) WHERE estado = 'pendiente';
