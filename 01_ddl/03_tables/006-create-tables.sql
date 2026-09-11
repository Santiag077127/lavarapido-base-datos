CREATE TABLE operadores (
    id_operador   UUID      PRIMARY KEY,
    fk_id_usuario UUID      NOT NULL UNIQUE,
    estado        BOOLEAN   NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_operadores_usuario
        FOREIGN KEY (fk_id_usuario) REFERENCES users(user_id) ON DELETE RESTRICT
);
CREATE TABLE asignaciones (
id_asignacion    UUID        PRIMARY KEY,
fk_id_reserva    UUID        NOT NULL UNIQUE,
fk_id_operador   UUID        NOT NULL,
fecha_asignacion TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
estado           VARCHAR(15) NOT NULL DEFAULT 'ASIGNADA',
created_at       TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at       TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_asignaciones_reservas
FOREIGN KEY (fk_id_reserva) REFERENCES reservas(id_reserva) ON DELETE RESTRICT,
CONSTRAINT fk_asignaciones_operadores
FOREIGN KEY (fk_id_operador) REFERENCES operadores(id_operador) ON DELETE RESTRICT,
CONSTRAINT chk_asignaciones_estado
CHECK (estado IN ('ASIGNADA', 'EN_PROCESO', 'COMPLETADA', 'CANCELADA'))
);