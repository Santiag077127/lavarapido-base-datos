INSERT INTO servicios (id_servicio, nombre, descripcion, precio, duracion_minutos, estado) VALUES
-- Categoría: Exteriores
(gen_random_uuid(), 'Lavado Exterior Básico', 'Limpieza exterior con agua a presión, champú neutro, secado con microfibra y limpieza de vidrios.', 20000, 20, true),
(gen_random_uuid(), 'Lavado Exterior a Mano', 'Lavado delicado con técnica de dos baldes y guante de microfibra para prevenir rayones en la pintura.', 30000, 35, true),
(gen_random_uuid(), 'Lavado Ecológico Exterior', 'Limpieza sin agua mediante polímeros biodegradables que encapsulan la mugre sin rayar.', 25000, 30, true),
(gen_random_uuid(), 'Lavado de Rines y Llantas', 'Remoción profunda de polvo de frenos, desengrasado de rines y aplicación de abrillantador en llantas.', 15000, 20, true),
(gen_random_uuid(), 'Descontaminado de Pintura', 'Uso de clay bar y limpiador químico para retirar asfalto, resina y partículas metálicas incrustadas.', 60000, 60, true),
(gen_random_uuid(), 'Encerado y Sellado', 'Aplicación de cera sintética para aportar brillo intenso y una capa repelente al agua y polvo.', 50000, 45, true),

-- Categoría: Interiores
(gen_random_uuid(), 'Aspirado General', 'Aspirado completo de alfombras, tapetes, asientos y baúl para eliminar polvo y residuos solares.', 15000, 20, true),
(gen_random_uuid(), 'Limpieza de Panel y Consola', 'Limpieza detallada de tablero, volante, molduras y salidas de aire con brochas y microfibra.', 20000, 25, true),
(gen_random_uuid(), 'Higienización a Vapor', 'Desinfección profunda a alta temperatura en superficies interiores para eliminar gérmenes y bacterias.', 45000, 40, true),
(gen_random_uuid(), 'Lavado de Tapicería', 'Limpieza por inyección-extracción en asientos de tela y alfombras para remover manchas y olores.', 80000, 90, true),
(gen_random_uuid(), 'Hidratación de Cuero', 'Limpieza con pH neutro y aplicación de acondicionador especial para evitar grietas en asientos de piel.', 50000, 40, true),
(gen_random_uuid(), 'Sanitización A/C', 'Eliminación de bacterias, hongos y malos olores acumulados en los conductos del aire acondicionado.', 35000, 30, true),
(gen_random_uuid(), 'Remoción de Pelos de Mascota', 'Especializado en remover pelaje incrustado en alfombras y asientos usando herramientas de fricción.', 30000, 45, true),

-- Categoría: Chasis y Motor
(gen_random_uuid(), 'Lavado de Chasis', 'Limpieza a alta presión de la parte inferior del vehículo para retirar barro, tierra y sal acumulada.', 25000, 25, true),
(gen_random_uuid(), 'Desengrasado de Bajos', 'Aplicación de desengrasante industrial en el chasis para remover capas gruesas de aceite y grasa.', 40000, 40, true),
(gen_random_uuid(), 'Lavado de Motor', 'Desengrasado de la bahía del motor utilizando vapor o limpia componentes dieléctrico seguro.', 45000, 35, true),

-- Categoría: Combos / Paquetes
(gen_random_uuid(), 'Combo Express', 'Lavado exterior básico junto con un aspirado rápido de cabina y limpieza de vidrios.', 30000, 30, true),
(gen_random_uuid(), 'Combo Completo', 'Lavado exterior a mano, aspirado profundo, limpieza de panel e hidratación de llantas.', 55000, 60, true),
(gen_random_uuid(), 'Combo Ecológico', 'Lavado exterior en seco combinado con aspirado de cabina y limpieza interna de cristales.', 40000, 40, true),
(gen_random_uuid(), 'Combo Profundo Sanitizado', 'Lavado exterior, lavado de tapicería por extracción y desinfección a vapor del aire acondicionado.', 130000, 120, true),
(gen_random_uuid(), 'Combo All-Inclusive', 'Servicio integral que incluye exterior a mano, interior completo, lavado de chasis y lavado de motor.', 160000, 150, true),
(gen_random_uuid(), 'Combo Detailing Premium', 'Tratamiento completo con descontaminado de pintura, encerado cerámico, interior a vapor y motor.', 220000, 180, true);