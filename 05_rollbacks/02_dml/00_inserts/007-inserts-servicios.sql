-- Rollback de la semilla inicial. Una FK vigente a un servicio bloquea el
-- borrado, lo cual exige conciliar datos antes de revertir en una BD usada.
DELETE FROM servicios WHERE nombre IN (
    'Lavado Exterior Básico', 'Lavado Exterior a Mano', 'Lavado Ecológico Exterior',
    'Lavado de Rines y Llantas', 'Descontaminado de Pintura', 'Encerado y Sellado',
    'Aspirado General', 'Limpieza de Panel y Consola', 'Higienización a Vapor',
    'Lavado de Tapicería', 'Hidratación de Cuero', 'Sanitización A/C',
    'Remoción de Pelos de Mascota', 'Lavado de Chasis', 'Desengrasado de Bajos',
    'Lavado de Motor', 'Combo Express', 'Combo Completo', 'Combo Ecológico',
    'Combo Profundo Sanitizado', 'Combo All-Inclusive', 'Combo Detailing Premium'
);
