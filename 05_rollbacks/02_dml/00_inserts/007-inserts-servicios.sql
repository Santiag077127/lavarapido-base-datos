-- ============================================================
-- ROLLBACK INICIALES DE SERVICIOS
-- ============================================================

DELETE FROM servicios 
WHERE nombre IN (
    'Lavado Básico',
    'Lavado Completo',
    'Lavado Premium',
    'Lavado de Moto',
    'Lavado SUV'
);