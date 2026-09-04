CREATE TABLE pagos (
    id_pago         UUID            PRIMARY KEY DEFAULT gen_random_uuid(),
    fk_id_reserva   UUID            NOT NULL UNIQUE,
    metodo_pago     VARCHAR(10)     NOT NULL DEFAULT 'online',
    referencia_pago VARCHAR(100),
    estado_wompi    VARCHAR(15),
    monto           NUMERIC(12,0)   NOT NULL,
    estado          VARCHAR(15)     NOT NULL DEFAULT 'pendiente',
    fecha_pago      TIMESTAMP,
    
    -- Clave Foránea
    CONSTRAINT fk_pagos_reserva 
        FOREIGN KEY (fk_id_reserva) 
        REFERENCES reservas (id_reserva) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,

    -- Restricciones CHECK
    CONSTRAINT chk_pagos_metodo 
        CHECK (metodo_pago IN ('online')),
    CONSTRAINT chk_pagos_estado 
        CHECK (estado IN ('pendiente', 'aprobado', 'rechazado')),
    CONSTRAINT chk_pagos_estado_wompi 
        CHECK (estado_wompi IN ('PENDING', 'APPROVED', 'DECLINED', 'VOIDED', 'ERROR') OR estado_wompi IS NULL),
    CONSTRAINT chk_pagos_monto 
        CHECK (monto > 0)
);