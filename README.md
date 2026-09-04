# Base de datos — Lava Rápido Vehicular

Repositorio de la base de datos del proyecto **Lava Rápido Vehicular**. Gestiona la evolución del esquema PostgreSQL y los datos iniciales mediante Liquibase.

El sistema respalda las aplicaciones móvil (clientes y operarios), el panel administrativo y el backend Spring Boot: gestión de usuarios y roles, vehículos, servicios, reservas y pagos.

## Tecnologías

- PostgreSQL 16
- Liquibase 5.0.2
- Docker Compose

## Modelo actual

Las tablas se crean en el esquema `public` y usan UUID como identificadores.

| Módulo | Tablas | Propósito |
| --- | --- | --- |
| Seguridad | `roles`, `users`, `user_roles`, `tokens_recuperacion` | Cuentas, roles y recuperación de contraseña. |
| Catálogo y vehículos | `servicios`, `marcas`, `vehiculos` | Servicios de lavado, marcas y vehículos de los clientes. |
| Operación | `reservas` | Agenda del servicio y su ciclo de estado. |
| Pagos | `pagos` | Pago único por reserva e integración con Wompi. |

Relaciones principales:

```text
users --< user_roles >-- roles
  |  \--< tokens_recuperacion
  +--< vehiculos >-- marcas
  \--< reservas >-- servicios
                   \-- pagos
```

Los estados de reserva son `PENDIENTE`, `ASIGNADA`, `EN_PROCESO`, `FINALIZADA` y `CANCELADA`. Cada reserva admite un único pago; sus estados son `pendiente`, `aprobado` y `rechazado`.

## Datos iniciales

Al ejecutar todos los changesets activos se cargan:

- Roles `ADMIN`, `USER` y `OPERATOR`.
- Dos usuarios administradores de desarrollo y su asignación de rol.
- Marcas de vehículos frecuentes en Colombia.

Estos registros son datos de desarrollo. Antes de desplegar a producción, revise las cuentas y credenciales incluidas en los scripts de inserción.

## Estructura del repositorio

```text
lavarapido-base-datos/
├── changelog-master.yaml       # Punto de entrada de Liquibase
├── 01_ddl/                     # Estructura: extensiones, tablas y alteraciones
│   ├── 00_extensions/          # pgcrypto (UUID)
│   ├── 03_tables/              # Tablas del dominio
│   └── 10_alter/               # Cambios posteriores al esquema
├── 02_dml/                     # Datos: inserts, updates, deletes, upserts y parches
├── 03_dcl/                     # Roles, permisos y políticas (reservado)
├── 04_tcl/                     # Operaciones transaccionales (reservado)
├── 05_rollbacks/               # Scripts de reversa, con estructura espejo
├── docker/                     # Imagen de Liquibase con el driver PostgreSQL
└── scripts/                    # Utilidades PowerShell para rollback y reaplicación
```

El archivo `changelog-master.yaml` incluye las capas DDL, DML, DCL y TCL en ese orden. Los directorios sin changesets aún están preparados para el crecimiento del proyecto, pero no realizan cambios.

## Requisitos

- Docker Desktop con Docker Compose
- Opcional: Liquibase instalado localmente y el controlador JDBC de PostgreSQL

## Inicio rápido con Docker

Desde la raíz de este repositorio:

1. Cree el archivo de configuración local:

   ```powershell
   Copy-Item .env.example .env
   ```

   Los valores predeterminados son base `lavarapido_db`, usuario `lavarapido_user`, contraseña `lavarapido_password` y puerto local `5433`.

2. Inicie PostgreSQL:

   ```powershell
   docker compose -p lavarapido-base-datos up -d postgres
   ```

3. Valide y aplique los changesets:

   ```powershell
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase validate
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase update
   ```

4. Consulte el estado o genere el SQL sin ejecutarlo cuando lo necesite:

   ```powershell
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase status
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase update-sql
   ```

La conexión resultante es `jdbc:postgresql://localhost:5433/lavarapido_db`.

## Conexión del backend

El backend se ejecuta en un repositorio independiente y usa Hibernate con `ddl-auto=validate`; por tanto, las tablas deben existir antes de iniciarlo. Configure allí las propiedades equivalentes a su archivo `.env`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5433/lavarapido_db
spring.datasource.username=lavarapido_user
spring.datasource.password=lavarapido_password
```

Si prefiere una instancia local de PostgreSQL con otro puerto, base de datos o usuario, ajuste `.env` y la configuración local del backend de forma consistente.

## Uso con Liquibase local

1. Copie `liquibase.properties.example` a `liquibase.properties`.
2. Ajuste la conexión si cambió los valores de Docker.
3. Ejecute:

   ```powershell
   liquibase validate
   liquibase status
   liquibase update
   ```

## Rollback

Antes de revertir cambios, genere una vista previa:

```powershell
docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase rollback-count-sql --count=1
```

Para revertir el último changeset aplicado:

```powershell
docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase rollback-count --count=1
```

El repositorio también incluye utilidades interactivas para rollback por identificador y reaplicación:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rollback-by-id.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\reapply-after-rollback.ps1
```

Para un cambio relevante, marque primero un punto estable y use el tag para regresar a él:

```powershell
docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase tag --tag=bd_estable
docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase rollback --tag=bd_estable
```

## Reinicio local de la base de datos

Este procedimiento borra el volumen de PostgreSQL del proyecto y todos sus datos locales.

```powershell
docker compose -p lavarapido-base-datos down --volumes --remove-orphans
docker compose -p lavarapido-base-datos up -d postgres
docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase update
```

## Convenciones para nuevos cambios

- No modifique un changeset que ya haya sido aplicado en ambientes compartidos.
- Cree un nuevo archivo SQL y declárelo en el `000-changelog.yaml` de su módulo.
- Incluya un rollback correspondiente en `05_rollbacks/`.
- Mantenga el orden de dependencias: extensiones, tablas, alteraciones y datos.
- Use IDs de changeset legibles y únicos; Liquibase los identifica por `id`, `author` y ruta lógica.
- Ejecute `validate` y `update-sql` antes de aplicar cambios.
- No suba secretos reales ni datos sensibles de producción.
