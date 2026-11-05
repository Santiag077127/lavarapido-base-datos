# Base de datos — Lava Rápido Vehicular

Este repositorio administra el esquema PostgreSQL y sus cambios versionados mediante Liquibase. Es la única fuente de migraciones de base de datos del proyecto. El backend Spring Boot se conecta a PostgreSQL y valida el esquema existente con Hibernate; no crea ni migra tablas.

## Componentes y versiones

- PostgreSQL: imagen `postgres:16-alpine` en Docker Compose (la versión exacta del parche depende de la imagen obtenida).
- Liquibase: `5.0.2`, según `docker/liquibase/Dockerfile`.
- Controlador JDBC PostgreSQL para Liquibase: `42.7.8`.
- Docker y Docker Compose: se requiere Docker Desktop o Docker Engine con el subcomando Compose v2 (`docker compose`). El repositorio no fija versiones mínimas; compruebe las instaladas con `docker --version` y `docker compose version`.

## Changelog oficial y advertencia sobre contextos

El punto de entrada oficial es [`changelog-master.yaml`](changelog-master.yaml). El servicio `liquibase` de `docker-compose.yml` ya lo selecciona y ejecuta las capas DDL, DML, DCL y TCL en el orden definido.

El maestro contiene changesets históricos etiquetados con el contexto `dev`, incluidos seeds de desarrollo. No use la configuración local predeterminada ni aplique el maestro sin revisar el contexto y el contenido resultante cuando el destino sea QA o producción. Sin filtro de contexto Liquibase puede incluir changesets marcados `dev`; un filtro distinto también puede excluir cambios estructurales históricos que llevan ese contexto. Por ello, el maestro no se declara seguro para aplicar directamente a QA/Render. En bases existentes —en particular Render— no reinicialice ni aplique cambios sin el procedimiento aprobado para ese entorno, revisar `DATABASECHANGELOG` y checksums, generar y revisar el SQL previsto, y confirmar el contexto con el responsable de la base.

## Desarrollo local con Docker Compose

Ejecute estos comandos desde la raíz de este repositorio, en PowerShell. La configuración local crea la base `lavarapido_db` y el usuario `lavarapido_user`; PostgreSQL se publica solo en `127.0.0.1`, puerto `5433` por defecto. La contraseña es obligatoria y no tiene valor predeterminado.
1. Copie `.env.example` a `.env` (ignorado por Git) y edite `.env` localmente para definir una contraseña única y fuerte. Genérela con un gestor de contraseñas; no la escriba en comandos, scripts ni archivos versionados. No reutilice credenciales de QA o producción:

   ```powershell
   if (-not (Test-Path .env)) { Copy-Item .env.example .env } else { Write-Host ".env ya existe; se conserva sin cambios." }
   ```
   Variables disponibles: `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` y `POSTGRES_PORT`. `POSTGRES_PASSWORD` es obligatoria. Compose la entrega a PostgreSQL y Liquibase desde el entorno; Liquibase no la recibe como argumento de línea de comandos. La URL desde el equipo host es `jdbc:postgresql://localhost:<POSTGRES_PORT>/<POSTGRES_DB>`.

2. Inicie únicamente PostgreSQL:

   ```powershell
   docker compose -p lavarapido-base-datos up -d postgres
   docker compose -p lavarapido-base-datos ps
   ```

   Espere hasta que el servicio `postgres` aparezca como saludable. Compose configura un healthcheck con `pg_isready`.

3. Valide el changelog y revise el estado antes de aplicarlo:

   ```powershell
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase validate
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase status
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase update-sql
   ```

   El servicio Liquibase utiliza `changelog-master.yaml`. `update-sql` genera una vista previa; inspecciónela y tenga presente la advertencia de contextos anterior.

4. Solo para una base local nueva o una actualización local expresamente aprobada, aplique los changesets:

   ```powershell
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase update
   docker compose -p lavarapido-base-datos --profile tooling run --rm liquibase status
   ```

   No use este paso contra QA, Render ni otra base compartida como si fuera una instalación vacía.

5. Compruebe la conexión PostgreSQL desde el contenedor:

   ```powershell
   docker compose -p lavarapido-base-datos exec postgres pg_isready -U lavarapido_user -d lavarapido_db
   ```

   Si cambió usuario o base en `.env`, reemplace los valores del comando. Para consultar los logs del servicio, use `docker compose -p lavarapido-base-datos logs postgres`.

## Conexión e inicio del backend
El backend está en `C:\backend\backend-vehicular`. Configure `DB_PASSWORD` con el mismo valor local que `POSTGRES_PASSWORD` usando el gestor de secretos o la configuración privada de ejecución de su IDE. Spring Boot no consume automáticamente el `.env` de este repositorio. No incluya la contraseña en comandos, scripts, archivos versionados ni logs compartidos.

Configure las variables no secretas del backend en el entorno de ejecución o IDE. Configure `DB_PASSWORD` mediante su almacenamiento privado de secretos; no use una asignación literal de contraseña en el historial de PowerShell.
Desde `C:\backend\backend-vehicular`, inicie el backend con su Maven Wrapper:

```powershell
.\mvnw.cmd spring-boot:run
```

El backend debe iniciarse después de PostgreSQL y de que el esquema esté disponible. `spring.jpa.hibernate.ddl-auto=validate` hace que Hibernate valide el esquema; las migraciones siguen siendo responsabilidad exclusiva de este repositorio.

Para backend y PostgreSQL dentro de Docker, el Compose del backend usa el perfil `docker`, variables obligatorias y la red externa `lavarapido-base-datos_default`. Consulte `C:\backend\backend-vehicular\docker-compose.yml` y configure los secretos localmente; esa red debe existir antes de iniciar el backend. No se documenta aquí un comando para iniciar ese servicio porque la preparación de secretos y servicios requeridos depende del entorno.

## QA y producción / Render

La conexión de esos entornos requiere los valores administrados por cada plataforma: host, puerto, base, usuario y contraseña PostgreSQL. En el backend deben configurarse como `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME` y `DB_PASSWORD`; no copie las credenciales locales de ejemplo. Para la configuración de producción, active el perfil `prod` (`SPRING_PROFILES_ACTIVE=prod`) y configure también las variables de aplicación que define `C:\backend\backend-vehicular\.env.example`. No hay un perfil QA específico documentado en los archivos inspeccionados; sus propiedades deben ser acordadas por separado.

Los archivos versionados no describen una secuencia de migración aprobada para QA o Render que resuelva los contexts `dev` del changelog maestro. Por tanto, esta guía no prescribe ejecutar `liquibase update` en esos entornos. Antes de cualquier cambio, confirme el changelog/contexto autorizado, revise el SQL generado y el historial de Liquibase, y mantenga intactos los datos existentes. No reinicialice bases de Render.

## Seguridad y operación

- `.env` contiene configuración local y no debe publicarse ni compartirse. El repositorio lo excluye de Git.
- `.env.example` no incluye una contraseña predeterminada. Defina una contraseña local única en `.env`; nunca use credenciales de QA o producción en desarrollo.
- No aplique seeds de desarrollo a bases reales. Los changesets de desarrollo incluyen perfiles y asignaciones administrativas históricos.
- No edite changesets que ya se hayan aplicado en un ambiente compartido: cree cambios incrementales y preserve los checksums históricos.
- No borre volúmenes ni reinicialice bases existentes como procedimiento de instalación.
- Ante errores de conexión, compruebe primero que `postgres` esté saludable, el puerto publicado coincida con `DB_PORT`, la base y el usuario coincidan, y `DB_PASSWORD` sea la misma en ambos servicios. Si el API alcanza PostgreSQL pero no inicia, revise el error de validación del esquema y confirme que las migraciones correspondientes estén realmente aplicadas.

## Estructura

- `01_ddl/`: extensiones, tablas, alteraciones e índices.
- `02_dml/`: datos iniciales y parches.
- `03_dcl/`: cambios de roles y permisos de base de datos.
- `04_tcl/`: cambios transaccionales y tags.
- `05_rollbacks/`: scripts de reversa asociados a cambios.
- `docker/`: imagen de Liquibase con el controlador PostgreSQL.
- `scripts/`: utilidades para operaciones de rollback y reaplicación; revise su alcance antes de usarlas.

Los rollbacks afectan el esquema o los datos y no forman parte de la instalación normal. Antes de considerar una reversa, genere y revise su SQL, confirme el destino y asegure una recuperación adecuada.
