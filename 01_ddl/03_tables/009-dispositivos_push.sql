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