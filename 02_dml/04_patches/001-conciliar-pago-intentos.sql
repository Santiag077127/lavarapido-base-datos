-- Liquibase es la unica fuente de migraciones. Este cambio no recrea la tabla.
-- Requiere -DwompiEnvironment=test o prod cuando hay pagos sin intento.
DO $migration$
DECLARE
    environment_value text := '${wompiEnvironment}';
BEGIN
    LOCK TABLE public.pagos IN SHARE MODE;
    LOCK TABLE public.pago_intentos IN SHARE ROW EXCLUSIVE MODE;

    IF NOT EXISTS (
        SELECT 1 FROM public.pagos p
        WHERE NOT EXISTS (SELECT 1 FROM public.pago_intentos i WHERE i.fk_id_pago = p.id_pago)
    ) THEN
        RETURN;
    END IF;

    IF environment_value NOT IN ('test', 'prod') THEN
        RAISE EXCEPTION 'Indique wompiEnvironment=test o prod para conciliar pagos';
    END IF;
    IF EXISTS (
        SELECT 1 FROM public.pagos p
        WHERE NOT EXISTS (SELECT 1 FROM public.pago_intentos i WHERE i.fk_id_pago = p.id_pago)
          AND (p.referencia_pago IS NULL OR btrim(p.referencia_pago) = ''
               OR p.estado::text NOT IN ('pendiente', 'aprobado', 'rechazado')
               OR (p.estado_wompi IS NOT NULL AND upper(p.estado_wompi)
                   NOT IN ('PENDING', 'APPROVED', 'DECLINED', 'VOIDED', 'ERROR')))
    ) THEN
        RAISE EXCEPTION 'Pagos historicos sin intento contienen datos incompatibles';
    END IF;
    IF EXISTS (
        SELECT 1 FROM public.pagos p
        WHERE NOT EXISTS (SELECT 1 FROM public.pago_intentos i WHERE i.fk_id_pago = p.id_pago)
          AND (EXISTS (SELECT 1 FROM public.pago_intentos i WHERE i.referencia = p.referencia_pago
                       OR i.id_intento = p.id_pago)
               OR EXISTS (SELECT 1 FROM public.pagos other
                          WHERE other.id_pago <> p.id_pago AND other.referencia_pago = p.referencia_pago))
    ) THEN
        RAISE EXCEPTION 'Referencias o identificadores de pagos historicos colisionan';
    END IF;

    INSERT INTO public.pago_intentos (
        id_intento, fk_id_pago, referencia, wompi_status, wompi_environment,
        estado, fecha_confirmacion, created_at, updated_at
    )
    SELECT p.id_pago, p.id_pago, p.referencia_pago,
           CASE WHEN upper(p.estado_wompi) IN ('PENDING', 'APPROVED', 'DECLINED', 'VOIDED', 'ERROR')
                THEN upper(p.estado_wompi) ELSE NULL END,
           environment_value, p.estado::text,
           CASE WHEN p.estado::text = 'aprobado' THEN p.fecha_pago ELSE NULL END,
           COALESCE(p.fecha_pago, CURRENT_TIMESTAMP), COALESCE(p.fecha_pago, CURRENT_TIMESTAMP)
    FROM public.pagos p
    WHERE NOT EXISTS (SELECT 1 FROM public.pago_intentos i WHERE i.fk_id_pago = p.id_pago);
END
$migration$;
