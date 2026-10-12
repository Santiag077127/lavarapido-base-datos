CREATE INDEX idx_notificaciones_usuario_fecha ON notificaciones(fk_id_usuario, created_at DESC);
CREATE INDEX idx_notificaciones_no_leidas ON notificaciones(fk_id_usuario) WHERE leida_at IS NULL;



CREATE UNIQUE INDEX uq_entrega_email ON notificacion_entregas(fk_id_notificacion) WHERE canal = 'email';
CREATE UNIQUE INDEX uq_entrega_push ON notificacion_entregas(fk_id_notificacion, fk_id_dispositivo) WHERE canal = 'push';
CREATE INDEX idx_entregas_pendientes ON notificacion_entregas(proxima_ejecucion) WHERE estado = 'pendiente';
