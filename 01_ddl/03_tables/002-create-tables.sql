CREATE TABLE servicios (
    id_servicio      UUID          PRIMARY KEY,
    nombre           VARCHAR(100)  NOT NULL UNIQUE,
    descripcion      VARCHAR(300),
    precio           NUMERIC(10,0) NOT NULL,
    duracion_minutos INT           NOT NULL,
    estado           BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_servicios_precio
        CHECK (precio > 0),

    CONSTRAINT chk_servicios_duracion
        CHECK (duracion_minutos BETWEEN 15 AND 180)
);
CREATE TABLE marcas (
    id_marca                  UUID         PRIMARY KEY,
    nombre                    VARCHAR(30)  NOT NULL UNIQUE,
    estado                    BOOLEAN      NOT NULL DEFAULT TRUE,
    fk_id_usuario_solicitante UUID,
    created_at                TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_marcas_usuario_solicitante
        FOREIGN KEY (fk_id_usuario_solicitante)
        REFERENCES users(user_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_marcas_nombre_mayusculas
        CHECK (nombre = UPPER(nombre))
);
CREATE TABLE vehiculos (
    id_vehiculo   UUID         PRIMARY KEY,
    fk_id_usuario UUID         NOT NULL,
    fk_id_marca   UUID         NOT NULL,
    placa         VARCHAR(7)   NOT NULL UNIQUE,
    color         VARCHAR(30),
    tipo_vehiculo VARCHAR(10)  NOT NULL,
    estado        BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vehiculos_usuario
        FOREIGN KEY (fk_id_usuario)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_vehiculos_marca
        FOREIGN KEY (fk_id_marca)
        REFERENCES marcas(id_marca)
        ON DELETE RESTRICT,
    CONSTRAINT chk_placa_formato
        CHECK (
            placa ~ '^[A-Z]{3}[0-9]{3}$' OR
            placa ~ '^[A-Z]{3}[0-9]{2}[A-Z]{1}$'
        ),
    CONSTRAINT chk_vehiculos_tipo
        CHECK (tipo_vehiculo IN ('CARRO', 'CAMIONETA', 'MOTO', 'MOTOCARRO', 'FURGONETA', 'PESADO'))
);

