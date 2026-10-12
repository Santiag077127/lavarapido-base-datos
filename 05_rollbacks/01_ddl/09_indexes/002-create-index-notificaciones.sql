DROP INDEX IF EXISTS idx_notificaciones_usuario_fecha;
DROP INDEX IF EXISTS idx_notificaciones_no_leidas;
DROP INDEX IF EXISTS uq_entrega_email;
DROP INDEX IF EXISTS uq_entrega_push;
DROP INDEX IF EXISTS idx_entregas_pendientes;
COMMIT;