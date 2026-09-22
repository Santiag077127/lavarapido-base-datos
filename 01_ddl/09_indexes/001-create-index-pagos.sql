CREATE INDEX idx_pago_intentos_pago
    ON pago_intentos(fk_id_pago);
CREATE INDEX idx_pago_intentos_transaccion
    ON pago_intentos(wompi_environment, wompi_transaction_id);
CREATE UNIQUE INDEX uq_pago_intentos_transaccion_environment
    ON pago_intentos(wompi_environment, wompi_transaction_id)
    WHERE wompi_transaction_id IS NOT NULL;
CREATE UNIQUE INDEX uq_pago_intentos_pendiente_por_pago
    ON pago_intentos(fk_id_pago)
    WHERE estado = 'pendiente';
COMMIT;