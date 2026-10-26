DROP INDEX IF EXISTS idx_pago_intentos_pago;
DROP INDEX IF EXISTS idx_pago_intentos_transaccion;
DROP INDEX IF EXISTS uq_pago_intentos_transaccion_environment;
DROP INDEX IF EXISTS uq_pago_intentos_pendiente_por_pago;
COMMIT;