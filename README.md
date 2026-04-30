# Lava Rápido Vehicular — Base de Datos

Repositorio para versionar la base de datos del proyecto **Lava Rápido Vehicular** con Liquibase y PostgreSQL.

## Alcance Actual

Este repositorio administra la estructura de base de datos del sistema de gestión de lavado vehicular:

- Extensión `pgcrypto` para generación de UUIDs
- Schemas: `auth`, `catalog`, `operations`, `billing`, `audit`, `security`
- Tablas de control de acceso, negocio, pagos, auditoría y seguridad

No incluye vistas, funciones, procedimientos, triggers, índices ni datos semilla (aún).

## Estructura

```text
lavarapido-base-datos/
├── changelog-master.yaml
├── 01_ddl/
│   ├── changelog.yaml
│   ├── 00_extensions/
│   │   └── changelog.yaml
│   ├── 01_schemas/
│   │   └── changelog.yaml
│   ├── 02_types/
│   │   └── changelog.yaml
│   ├── 03_tables/
│   │   └── changelog.yaml
│   ├── 04_views/
│   │   └── changelog.yaml
│   ├── 05_materialized_views/
│   │   └── changelog.yaml
│   ├── 06_functions/
│   │   └── changelog.yaml
│   ├── 07_procedures/
│   │   └── changelog.yaml
│   ├── 08_triggers/
│   │   └── changelog.yaml
│   └── 09_indexes/
│       └── changelog.yaml
├── 02_dml/
│   ├── changelog.yaml
│   ├── 00_inserts/
│   │   └── changelog.yaml
│   ├── 01_updates/
│   │   └── changelog.yaml
│   ├── 02_deletes/
│   │   └── changelog.yaml
│   ├── 03_upserts/
│   │   └── changelog.yaml
│   └── 04_patches/
│       └── changelog.yaml
├── 03_dcl/
│   ├── changelog.yaml
│   ├── 00_roles/
│   │   └── changelog.yaml
│   ├── 01_grants/
│   │   └── changelog.yaml
│   └── 02_policies/
│       └── changelog.yaml
├── 04_tcl/
│   ├── changelog.yaml
│   ├── 00_transaction_blocks/
│   │   └── changelog.yaml
│   └── 01_manual_recoveries/
│       └── changelog.yaml
├── 05_rollbacks/
│   ├── 01_ddl/
│   │   ├── 00_extensions/
│   │   ├── 01_schemas/
│   │   ├── 02_types/
│   │   ├── 03_tables/
│   │   └── ...
│   ├── 02_dml/
│   ├── 03_dcl/
│   └── 04_tcl/
├── docker-compose.yml
├── .env.example
├── liquibase.properties.example
├── README.md
├── docs/
└── docker/
    └── liquibase/
        └── Dockerfile
```

## Arquitectura de Capas

La arquitectura está organizada por responsabilidad SQL:

- `01_ddl`: cambios estructurales (tablas, schemas, extensiones)
- `02_dml`: cambios de datos por verbo operativo
- `03_dcl`: seguridad, permisos y control de acceso
- `04_tcl`: operaciones transaccionales o de recuperación excepcionales

## Orquestación por YAML

La orquestación está distribuida por niveles:

- `changelog-master.yaml`: coordina las capas principales
- `01_ddl/changelog.yaml`, `02_dml/changelog.yaml`, etc.: coordinan cada paquete
- cada subcarpeta tiene su propio `changelog.yaml` para declarar su contenido activo

## Árbol de Rollbacks

Los scripts de rollback están separados en `05_rollbacks/` con árbol espejo por capas.

En cada `changeSet`, el `rollback.sqlFile` apunta a esa ruta centralizada, facilitando auditoría y seguimiento sin mezclar archivos de avance y reversa.

## Regla de Activación

Una carpeta o script solo se vuelve activo cuando entra en la cadena de includes desde `changelog-master.yaml`. Mientras eso no ocurra, la carpeta puede existir y tener su propósito definido, pero no participa en el despliegue.

## Capa Activa Hoy

El despliegue funcional actual usa:

- `01_ddl/00_extensions` — extensión `pgcrypto`
- `01_ddl/01_schemas` — schemas del proyecto
- `01_ddl/03_tables` — tablas de negocio y seguridad

## Capas Reservadas

Listas y gobernadas, pero sin uso activo aún:

- `01_ddl/02_types`
- `01_ddl/04_views` al `09_indexes`
- `02_dml` completo
- `03_dcl` completo
- `04_tcl` completo

## Requisitos

- Docker Desktop
- Docker Compose
- Liquibase local (opcional, solo si quieres ejecutarlo fuera de Docker)

## Reset Limpio del Proyecto

Ejecuta este flujo desde la raíz del repositorio cuando necesites limpiar el estado y volver a aplicar todo desde cero:

```bash
docker-compose -p lavarapido-base-datos down --volumes --remove-orphans
docker-compose -p lavarapido-base-datos up -d postgres
docker-compose -p lavarapido-base-datos --profile tooling run --rm liquibase validate
docker-compose -p lavarapido-base-datos --profile tooling run --rm liquibase update
```

> En DBeaver puede aparecer `SQL Error [08003]: This connection has been closed` después del reset. Solo reconecta el datasource y refresca `Schemas`.

## Uso Rápido con Docker

**1.** Si quieres personalizar credenciales o puerto, crea `.env` a partir de `.env.example`.

**2.** Levanta PostgreSQL:

```bash
docker-compose up -d postgres
```

**3.** Construye la imagen de Liquibase (solo la primera vez):

```bash
docker-compose --profile tooling build liquibase
```

**4.** Valida el changelog:

```bash
docker-compose --profile tooling run --rm liquibase validate
```

**5.** Revisa el estado:

```bash
docker-compose --profile tooling run --rm liquibase status
```

**6.** Aplica la estructura base:

```bash
docker-compose --profile tooling up -d
```

**7.** Prueba el rollback del último changeset:

```bash
docker-compose --profile tooling run --rm liquibase rollback-count --count=1
```

**8.** Crea un tag antes de un cambio importante:

```bash
docker-compose --profile tooling run --rm liquibase tag --tag=pre_cambio_x
```

**9.** Genera el SQL sin ejecutar cambios:

```bash
docker-compose --profile tooling run --rm liquibase update-sql
```

## Uso con Liquibase Local

Usa esta opción solo si tu instalación local de Liquibase ya tiene el driver JDBC de PostgreSQL disponible.

1. Copia `liquibase.properties.example` como `liquibase.properties`.
2. Ajusta host, usuario, password y base de datos si cambiaste los valores por defecto.
3. Ejecuta desde la raíz del repo:

```bash
liquibase validate
liquibase status
liquibase update
liquibase rollback-count --count=1
```

## Orden de Ejecución

El `changelog-master.yaml` aplica los cambios en este orden:

1. Habilita la extensión `pgcrypto`
2. Crea los schemas (`auth`, `catalog`, `operations`, `billing`, `audit`, `security`)
3. Crea tablas de `auth` (roles, users, user_roles)
4. Crea tablas de `operations` (operadores, vehiculos, disponibilidad, asignaciones)
5. Crea tablas de `catalog` (servicios, servicios_favoritos, reservas)
6. Crea tablas de `billing` (pagos, calificaciones)
7. Crea tablas de `security` y `audit` (tokens, políticas, auditoría, logs)

Este orden evita errores por dependencias entre tablas y llaves foráneas.

## Rollback Operativo

Rollback del último changeset aplicado:

```bash
docker-compose --profile tooling run --rm liquibase rollback-count --count=1
```

Rollback de los últimos N changesets:

```bash
docker-compose --profile tooling run --rm liquibase rollback-count --count=3
```

Vista previa del rollback sin ejecutar (recomendado antes de revertir):

```bash
docker-compose --profile tooling run --rm liquibase rollback-count-sql --count=1
```

Flujo profesional con `tag` + `rollback --tag`:

```bash
# 1. Marcar un punto estable
docker-compose --profile tooling run --rm liquibase tag --tag=v1_stable

# 2. Aplicar nuevos cambios
docker-compose --profile tooling up -d

# 3. Si necesitas volver al punto estable
docker-compose --profile tooling run --rm liquibase rollback --tag=v1_stable
```

Rollback por fecha/hora:

```bash
docker-compose --profile tooling run --rm liquibase rollback-to-date "2026-04-30 13:00:00"
```

Auditoría después de aplicar o revertir:

```bash
docker-compose --profile tooling run --rm liquibase history
```

Verificación directa en la base de datos:

```sql
SELECT orderexecuted, id, author, filename, tag
FROM public.databasechangelog
ORDER BY orderexecuted;
```

## Buenas Prácticas Adoptadas

- un solo `changelog-master.yaml` como punto de entrada
- separación por capa SQL y por responsabilidad de paquete
- archivos pequeños y ordenados por responsabilidad
- un `changelog.yaml` por paquete y subpaquete
- changesets declarativos en YAML con `sqlFile` de avance y reversa
- rollbacks separados en `sqlFile` dedicados bajo `05_rollbacks/`
- configuración local separada en archivos `.example`
- runner Docker de Liquibase con driver PostgreSQL preinstalado
- puerto por defecto `5433` para evitar choques con PostgreSQL local en `5432`
- IDs de changeset semánticos basados en HU para mejor trazabilidad

## Reglas para Cambios Nuevos

- no modificar changesets ya aplicados
- crear nuevos archivos para cada cambio posterior
- mantener el orden de dependencias en el master changelog
- no subir secretos reales al repositorio
- validar con `validate` y `update-sql` antes de aplicar en ambientes superiores
- antes de un cambio delicado, crear un `tag`
- cada changeset DDL debe tener su archivo de rollback correspondiente en `05_rollbacks/`

## Estado Esperado

Cuando el flujo funciona correctamente, la base queda con:

- extensión `pgcrypto`
- schemas `auth`, `catalog`, `operations`, `billing`, `audit`, `security`
- tablas: `roles`, `users`, `user_roles`, `vehiculos`, `operadores`, `disponibilidad`, `servicios`, `servicios_favoritos`, `reservas`, `asignaciones`, `pagos`, `calificaciones`, `tokens_recuperacion`, `auditoria`, `log_errores`, `politicas_contrasenas`, `configuracion_seguridad`