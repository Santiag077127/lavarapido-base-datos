CREATE TABLE calificaciones (
    id_calificacion UUID         PRIMARY KEY,
    fk_id_reserva   UUID         NOT NULL UNIQUE,
    fk_id_usuario   UUID         NOT NULL,
    puntuacion      INT          NOT NULL,
    comentario      VARCHAR(300),
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_calificaciones_reservas
        FOREIGN KEY (fk_id_reserva)
        REFERENCES reservas(id_reserva)
        ON DELETE RESTRICT,
    CONSTRAINT fk_calificaciones_usuario
        FOREIGN KEY (fk_id_usuario)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_calificaciones_puntuacion
        CHECK (puntuacion BETWEEN 1 AND 5)
);
CREATE TABLE auditoria (
    id_auditoria  UUID         PRIMARY KEY,
    fk_id_usuario UUID,
    accion        VARCHAR(30)  NOT NULL,
    descripcion   VARCHAR(500),
    ip_origen     VARCHAR(45),
    modulo        VARCHAR(20),
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (fk_id_usuario)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_auditoria_accion
        CHECK (accion IN (
            'login', 'logout', 'login_fallido', 'registro',
            'recuperar_clave', 'cambio_clave',
            'pago_aprobado', 'pago_rechazado',
            'servicio_creado', 'servicio_editado', 'servicio_eliminado'
        )),
    CONSTRAINT chk_auditoria_modulo
        CHECK (modulo IN (
            'autenticacion', 'usuarios', 'servicios', 'reservas',
            'pagos', 'calificaciones', 'operadores', 'sistema'
        ) OR modulo IS NULL)
);

CREATE TABLE log_errores (
    id_error      UUID         PRIMARY KEY,
    fk_id_usuario UUID,
    tipo_error    VARCHAR(30)  NOT NULL,
    descripcion   VARCHAR(500),
    ip_origen     VARCHAR(45),
    resuelto      BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_errores_usuario
        FOREIGN KEY (fk_id_usuario)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_log_tipo_error
        CHECK (tipo_error IN (
            'auth_fallido', 'token_invalido',
            'pago_fallido', 'pago_timeout',
            'db_error', 'servidor_error',
            'validacion_error', 'permiso_denegado'
        ))
);