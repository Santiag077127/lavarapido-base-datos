/* =================================================================
   PROYECTO  : Lava Rapido Vehicular
   VERSION   : Rollback v8.0 -> v7.1
   DESCRIPCION: Elimina las tablas creadas y revierte cambios de esquema.
   ================================================================= */

-- 1. Eliminar tabla de soporte para RF1.3 (nueva en v8.0)
DROP TABLE IF EXISTS tokens_recuperacion;

-- 2. Eliminar tabla intermedia de relacion
DROP TABLE IF EXISTS user_roles;

-- 3. Eliminar tablas maestras
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

