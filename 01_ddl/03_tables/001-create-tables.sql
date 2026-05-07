
CREATE TABLE roles (
    role_id      UUID         PRIMARY KEY,
    role_name    VARCHAR(20)  NOT NULL UNIQUE,
    description  VARCHAR(255),
    created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_roles_name
        CHECK (role_name IN ('ADMIN', 'USER', 'OPERATOR'))
);
CREATE TABLE users (
    user_id         UUID          PRIMARY KEY, 
    email           VARCHAR(100)  NOT NULL UNIQUE,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50),
    phone_number    VARCHAR(10)   NOT NULL,
    document_type   VARCHAR(10)   NOT NULL,
    document_number VARCHAR(12)   NOT NULL,
    password        VARCHAR(60)   NOT NULL, 
    profile_picture VARCHAR(20)   NOT NULL DEFAULT 'avatar_1',
    status          BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_document_type
        CHECK (document_type IN ('CC', 'TI', 'CE')),
    CONSTRAINT chk_colombian_phone
        CHECK (phone_number ~ '^3[0-9]{9}$'),
    CONSTRAINT chk_profile_picture
        CHECK (profile_picture IN (
            'avatar_1', 'avatar_2', 'avatar_3', 'avatar_4', 'avatar_5'
        ))
);

CREATE TABLE user_roles (
    fk_user_id  UUID      NOT NULL,
    fk_role_id  UUID      NOT NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status      BOOLEAN   NOT NULL DEFAULT TRUE,
    revoked_at  TIMESTAMP,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_user_roles
        PRIMARY KEY (fk_user_id, fk_role_id),
    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (fk_user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (fk_role_id) REFERENCES roles(role_id) ON DELETE RESTRICT,
    CONSTRAINT chk_consistent_revocation
        CHECK (
            (status = TRUE  AND revoked_at IS NULL) OR
            (status = FALSE AND revoked_at IS NOT NULL)
        )
);



CREATE TABLE tokens_recuperacion (
    id_token         UUID          PRIMARY KEY, -- Generado por el Backend
    fk_id_usuario    UUID          NOT NULL,
    token_hash       VARCHAR(64)   NOT NULL UNIQUE, -- Ajustado con ALTER
    expiracion_at    TIMESTAMP     NOT NULL,
    usado            BOOLEAN       NOT NULL DEFAULT FALSE,
    ip_solicitante   VARCHAR(45),
    created_at       TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_tokens_usuario
        FOREIGN KEY (fk_id_usuario)
        REFERENCES users(user_id)
        ON DELETE RESTRICT,
    CONSTRAINT chk_token_expiracion
        CHECK (expiracion_at > created_at)
);


