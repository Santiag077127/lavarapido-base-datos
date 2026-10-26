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
