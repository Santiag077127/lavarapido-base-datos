CREATE TABLE pago_intentos (
    id_intento UUID PRIMARY KEY,
    fk_id_pago UUID NOT NULL,
    referencia VARCHAR(100) NOT NULL,
    wompi_transaction_id VARCHAR(100),
    wompi_payment_method_type VARCHAR(50),
    wompi_status VARCHAR(20),
    wompi_environment VARCHAR(10) NOT NULL,
    estado VARCHAR(24) NOT NULL,
    fecha_confirmacion TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    CONSTRAINT fk_pago_intentos_pago
        FOREIGN KEY (fk_id_pago)
        REFERENCES pagos(id_pago)
        ON DELETE RESTRICT,
    CONSTRAINT uq_pago_intentos_referencia
        UNIQUE (referencia),
    CONSTRAINT ck_pago_intentos_environment
        CHECK (wompi_environment IN ('test', 'prod')),
    CONSTRAINT ck_pago_intentos_estado
        CHECK (
            estado IN (
                'pendiente',
                'aprobado',
                'rechazado',
                'aprobado_duplicado'
            )
        ),
    CONSTRAINT ck_pago_intentos_wompi_status
        CHECK (
            wompi_status IS NULL
            OR wompi_status IN (
                'PENDING', 'APPROVED', 'DECLINED', 'VOIDED', 'ERROR'
            )
        )
);
