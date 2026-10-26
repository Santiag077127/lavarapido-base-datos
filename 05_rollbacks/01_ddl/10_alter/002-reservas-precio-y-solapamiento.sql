-- Solo después de una copia de seguridad y de comprobar que no hubo reservas
-- nuevas que dependan de estos campos. El precio pactado se perdería al revertir.
ALTER TABLE reservas DROP CONSTRAINT IF EXISTS reservas_no_solapadas;
ALTER TABLE reservas DROP CONSTRAINT IF EXISTS chk_reservas_precio_pactado;
ALTER TABLE reservas DROP CONSTRAINT IF EXISTS chk_reservas_duracion_pactada;
ALTER TABLE reservas ALTER COLUMN estado DROP DEFAULT;
ALTER TABLE reservas DROP COLUMN precio_pactado;
ALTER TABLE reservas DROP COLUMN duracion_minutos_pactada;
