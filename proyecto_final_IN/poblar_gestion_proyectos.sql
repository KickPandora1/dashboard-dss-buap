USE Gestion_Proyectos;

INSERT INTO DimAnio (ID_anio, Anio) VALUES (1, 2020), (2, 2021), (3, 2022), (4, 2023), (5, 2024), (6, 2025);
INSERT INTO DimMes (ID_Mes, Mes) VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12);
INSERT INTO DimTrismestre (ID_Trismestre, Trimestre) VALUES (1,'Q1'), (2,'Q2'), (3,'Q3'), (4,'Q4');
-- Días representativos para cortes semanales
INSERT INTO DimDia (ID_Dia, Dia) VALUES (1, 5), (2, 10), (3, 15), (4, 20), (5, 25), (6, 30);

INSERT INTO DimProyecto_Estado (Estado_Proyecto) VALUES ('En Progreso'), ('Finalizado Exitoso'), ('Finalizado con Retraso'), ('Cancelado'), ('En Pausa');
INSERT INTO DimProyecto_Tipo (Tipo_Proyecto) VALUES ('Desarrollo Nuevo'), ('Mantenimiento Evolutivo'), ('Investigación (I+D)'), ('Migración');
INSERT INTO Proyecto_Metodologia (Metoddologia_Proyecto) VALUES ('Waterfall'), ('Scrum'), ('Kanban'), ('Híbrido'), ('XP'), ('DevOps');

-- Tareas Estandarizadas
INSERT INTO DimTipo_Tarea (Tipo_Tarea) VALUES ('Gestión'), ('Análisis'), ('Desarrollo'), ('Testing'), ('Bug/Defecto'), ('Despliegue');
INSERT INTO DimTarea_Estado (Estado_Tarea) VALUES ('Pendiente'), ('En Progreso'), ('Bloqueado'), ('Completado');

-- Catálogo de Tareas Comunes (Para evitar textos libres repetidos)
INSERT INTO DimTarea (Nombre_Tarea) VALUES 
('Gestión y Planificación'), -- 1
('Análisis de Requerimientos'), -- 2
('Desarrollo Backend API'), -- 3
('Desarrollo Frontend UI'), -- 4
('Pruebas Unitarias'), -- 5
('Corrección de Incidencias'), -- 6
('Configuración Infraestructura'); -- 7

INSERT INTO DimTarea_Horas_Planificadas (Horas_Planificadas) VALUES (0), (4), (8), (16), (24), (40);

INSERT INTO DimEmpleado_Area (Area) VALUES ('Ingeniería'), ('Calidad (QA)'), ('Datos & IA'), ('PMO'), ('Infraestructura');
INSERT INTO DimEmpleado_Rol (Rol) VALUES ('Developer'), ('Tester'), ('Data Scientist'), ('Project Manager'), ('DevOps Engineer'), ('Architect');
INSERT INTO DimEmpleado_Perfil (Seniority) VALUES ('Junior'), ('Mid-Level'), ('Senior'), ('Lead/Principal');
INSERT INTO DimEmpleado_Tarifa_Hora (Tarifa_Hora) VALUES (25.00), (45.00), (70.00), (100.00), (150.00); 

INSERT INTO DimEmpleado (Nombre_Empleado, anio) VALUES 
-- 2020: Equipo Fundador
('Carlos Director (PMO)', 2020), ('Roberto (Lead Dev)', 2020), ('Laura (QA Lead)', 2020), ('Juan (Backend)', 2020),
-- 2021-2022: Expansión Web/Mobile
('Ana (Scrum Master)', 2021), ('Pedro (Fullstack)', 2021), ('Sofia (Frontend)', 2021), ('Miguel (QA Auto)', 2022), ('Lucia (Backend)', 2022),
-- 2023: Equipo de Datos (Vital para modelo Rayleigh)
('Elena (Data Lead)', 2023), ('Marco (Data Eng)', 2023), ('Patricia (PM Ágil)', 2023),
-- 2024: Crisis y Reestructuración
('David (DevOps)', 2024), ('Carmen (AI Specialist)', 2024), ('Jorge (Junior Dev)', 2024), ('Marta (Junior QA)', 2024),
-- 2025: Actualidad
('Luis (Security)', 2025), ('Teresa (UX/UI)', 2025), ('Raul (Cloud Arch)', 2025), ('Isabel (PM Senior)', 2025);

INSERT INTO DimSprint (Nombre_Sprint, Numero_Sprint) VALUES 
('Ejecución Continua (Waterfall/Kanban)', 0), -- ID 1: Para proyectos no Scrum
('Sprint 1 - Inception', 1),
('Sprint 2 - MVP Core', 2),
('Sprint 3 - Features & Fixes', 3),
('Sprint 4 - Hardening', 4);

INSERT INTO DimHistoria (Nombre_Historia, Numero_Historia) VALUES 
('Tarea Planificada (WBS)', 0), -- ID 1: Para Waterfall
('Login y Autenticación', 101),
('Carrito de Compras', 102),
('Motor de Recomendación', 103),
('Migración de Datos', 104);

INSERT INTO DimHistoria_Descripccion (Descripccion) VALUES ('Actividad estándar del cronograma'), ('Como usuario quiero acceder...');
INSERT INTO DimHistoria_Persona_Asignada (Persona) VALUES (1), (2), (3), (4); -- Asignaciones genéricas iniciales

INSERT INTO DimFecha_Inicio_Sprint (Dia, Mes, Anio) VALUES (1, 1, 1);
INSERT INTO DimFecha_Fecha_Fin_Sprint (Dia, Mes, anio, Dia_real, Mes_real, anio_real) VALUES (1, 1, 1, 1, 1, 1);
INSERT INTO DimFecha_Inicio_Historia (Dia, Mes, anio) VALUES (1, 1, 1);
INSERT INTO DimFecha_Fecha_Fin_Historia (Dia, Mes, anio, Dia_real, Mes_real, anio_real) VALUES (1, 1, 1, 1, 1, 1);

INSERT INTO DimProyecto (Nombre_Proyecto) VALUES 
('Sistema Nómina Central (2020)'),      -- ID 1: Waterfall Exitoso
('Migración Data Center (2020)'),       -- ID 2: Waterfall Cancelado
('App Piloto Innovación (2020)'),       -- ID 3: Scrum Fallido
('E-Commerce V1 (2021)'),               -- ID 4: Híbrido
('Reportes Regulatorios (2021)'),       -- ID 5: Waterfall
('App iOS Nativa (2022)'),              -- ID 6: Scrum
('Integración SAP (2022)'),             -- ID 7: Waterfall
('Motor Pagos Anti-Fraude (2023)'),     -- ID 8: XP (Rayleigh Training)
('CRM Salesforce (2023)'),              -- ID 9: Híbrido
('IA Recomendación Prod (2024)'),       -- ID 10: Scrum
('Blockchain Supply Chain (2024)'),     -- ID 11: Híbrido (Desastre)
('GenAI Chatbot Clientes (2025)'),      -- ID 12: Scrum (Benchmark)
('Migración Cloud Native (2025)'),      -- ID 13: DevOps (Riesgo)
('Modernización App (2025)');           -- ID 14: Scrum

INSERT INTO Fact_Gestion_Proyecto (
    ID_Proyecto, ID_Proyecto_Estado, ID_Proyecto_Tipo, ID_Proyecto_Metodologia,
    ID_Empleado, ID_Empleado_Rol, ID_Empleado_Area, ID_Empleado_Tarifa_Hora, ID_Empleado_Perfil,
    ID_Tarea, ID_Tarea_Tipo, ID_Tarea_Estado, ID_Tarea_Horas_Planificadas,
    ID_Dia, ID_Mes, ID_Anio, ID_Trismestre,
    ID_Sprint, ID_Fecha_Inicio_Sprint, ID_Fecha_Fin_Sprint,
    ID_Historia, ID_Historia_Descripccion, ID_Historia_Persona_Asignada, ID_Fecha_Inicio_Historia, ID_Fecha_Fin_Historia,
    Horas_Planificadas, Horas_Reales, Costo_Real, 
    PV, EV, SV, Variacion_Esfuerzo
) VALUES 
(1, 2, 1, 1, 
 1, 4, 4, 4, 3, -- Carlos, PM, PMO, Tarifa $100, Senior
 1, 1, 2, 6, -- Tarea "Gestión", Tipo Gestión, En Progreso, 40h plan
 6, 1, 1, 1, -- 30 Ene 2020 Q1
 1, 1, 1, 1, 1, 1, 1, 1, -- Sprint 1 (Ejecución Continua), Historia 1 (WBS) -> NO NULLS
 40.00, 40.00, 4000.00,  -- 40h * $100 = 4000 Costo
 4000.00, 4000.00, 0.00, 0.00), -- EV=PV (Va perfecto)

-- Roberto (Lead Dev) desarrolla el Core
(1, 2, 1, 1, 
 2, 1, 1, 3, 3, -- Roberto, Dev, Ing, Tarifa $70, Senior
 3, 3, 4, 6, -- Tarea "Desarrollo Backend", Tipo Desarrollo, Completado
 6, 1, 1, 1, 
 1, 1, 1, 1, 1, 1, 1, 1,
 160.00, 160.00, 11200.00, -- 160h * $70 = 11,200 Costo
 11200.00, 11200.00, 0.00, 0.00); -- Completó todo, EV=PV

INSERT INTO Fact_Gestion_Proyecto (
    ID_Proyecto, ID_Proyecto_Estado, ID_Proyecto_Tipo, ID_Proyecto_Metodologia,
    ID_Empleado, ID_Empleado_Rol, ID_Empleado_Area, ID_Empleado_Tarifa_Hora, ID_Empleado_Perfil,
    ID_Tarea, ID_Tarea_Tipo, ID_Tarea_Estado, ID_Tarea_Horas_Planificadas,
    ID_Dia, ID_Mes, ID_Anio, ID_Trismestre,
    ID_Sprint, ID_Fecha_Inicio_Sprint, ID_Fecha_Fin_Sprint,
    ID_Historia, ID_Historia_Descripccion, ID_Historia_Persona_Asignada, ID_Fecha_Inicio_Historia, ID_Fecha_Fin_Historia,
    Horas_Planificadas, Horas_Reales, Costo_Real, 
    PV, EV, SV, Variacion_Esfuerzo
) VALUES 
-- Elena (Data Lead) Desarrolla (Genera Valor)
(8, 1, 1, 5, 10, 3, 3, 4, 4, 3, 3, 4, 5, 2, 1, 4, 1, 2, 1, 1, 2, 2, 1, 1, 1, 
 160.00, 160.00, 16000.00, -- 160h * $100
 16000.00, 16000.00, 0.00, 0.00), -- EV=16k

-- Miguel (QA) Encuentra Bugs (Genera Costo, EV=0)
-- Sprint 1: Pocos Bugs
(8, 1, 1, 5, 8, 2, 2, 2, 2, 6, 5, 4, 2, 2, 1, 4, 1, 2, 1, 1, 2, 1, 1, 1, 1,
 0.00, 15.00, 675.00, -- 15h * $45 = 675 Costo
 0.00, 0.00, 0.00, 15.00), -- PV=0, EV=0 (Es un bug no planeado)

-- Sprint 2: PICO DE BUGS (Marzo 2023)
(8, 1, 1, 5, 8, 2, 2, 2, 2, 6, 5, 4, 2, 2, 3, 4, 1, 3, 1, 1, 2, 1, 1, 1, 1,
 0.00, 90.00, 4050.00, -- 90h * $45 = 4050 Costo (¡Caro!)
 0.00, 0.00, 0.00, 90.00); -- EV=0

INSERT INTO Fact_Gestion_Proyecto (
    ID_Proyecto, ID_Proyecto_Estado, ID_Proyecto_Tipo, ID_Proyecto_Metodologia,
    ID_Empleado, ID_Empleado_Rol, ID_Empleado_Area, ID_Empleado_Tarifa_Hora, ID_Empleado_Perfil,
    ID_Tarea, ID_Tarea_Tipo, ID_Tarea_Estado, ID_Tarea_Horas_Planificadas,
    ID_Dia, ID_Mes, ID_Anio, ID_Trismestre,
    ID_Sprint, ID_Fecha_Inicio_Sprint, ID_Fecha_Fin_Sprint,
    ID_Historia, ID_Historia_Descripccion, ID_Historia_Persona_Asignada, ID_Fecha_Inicio_Historia, ID_Fecha_Fin_Historia,
    Horas_Planificadas, Horas_Reales, Costo_Real, 
    PV, EV, SV, Variacion_Esfuerzo
) VALUES 
-- Jorge (Junior Dev) - Se atascó.
(11, 1, 1, 4, 15, 1, 1, 1, 1, 3, 3, 2, 6, 4, 5, 5, 2, 3, 1, 1, 4, 2, 1, 1, 1,
 80.00, 200.00, 5000.00, -- Planeó 80h, tardó 200h. Costo: 200 * $25 = 5000
 5000.00, 2000.00, -3000.00, 120.00); -- PV=5000 (lo que debió hacer), EV=2000 (lo que logró). SV negativo.

-- -----------------------------------------------------------------------------
-- D) ESCENARIO 2025: ACTUALIDAD (Para Dashboard)
-- -----------------------------------------------------------------------------
-- GenAI (Éxito): Isabel (PM Senior) + Carmen (AI).
INSERT INTO Fact_Gestion_Proyecto (
    ID_Proyecto, ID_Proyecto_Estado, ID_Proyecto_Tipo, ID_Proyecto_Metodologia,
    ID_Empleado, ID_Empleado_Rol, ID_Empleado_Area, ID_Empleado_Tarifa_Hora, ID_Empleado_Perfil,
    ID_Tarea, ID_Tarea_Tipo, ID_Tarea_Estado, ID_Tarea_Horas_Planificadas,
    ID_Dia, ID_Mes, ID_Anio, ID_Trismestre,
    ID_Sprint, ID_Fecha_Inicio_Sprint, ID_Fecha_Fin_Sprint,
    ID_Historia, ID_Historia_Descripccion, ID_Historia_Persona_Asignada, ID_Fecha_Inicio_Historia, ID_Fecha_Fin_Historia,
    Horas_Planificadas, Horas_Reales, Costo_Real, 
    PV, EV, SV, Variacion_Esfuerzo
) VALUES 
-- Carmen AI: Trabajo de alto valor
(12, 1, 3, 2, 14, 3, 3, 4, 4, 6, 3, 4, 5, 4, 1, 6, 1, 4, 1, 1, 4, 2, 1, 1, 1,
 160.00, 160.00, 19200.00, -- 160h * $120 (Lead AI es cara)
 19200.00, 19200.00, 0.00, 0.00); -- Pero entrega todo el valor. EV=PV.

-- Migración Cloud (Riesgo Rayleigh): Raul (Cloud Arch).
-- Muchos bugs recientes (Enero-Marzo 2025).
INSERT INTO Fact_Gestion_Proyecto (
    ID_Proyecto, ID_Proyecto_Estado, ID_Proyecto_Tipo, ID_Proyecto_Metodologia,
    ID_Empleado, ID_Empleado_Rol, ID_Empleado_Area, ID_Empleado_Tarifa_Hora, ID_Empleado_Perfil,
    ID_Tarea, ID_Tarea_Tipo, ID_Tarea_Estado, ID_Tarea_Horas_Planificadas,
    ID_Dia, ID_Mes, ID_Anio, ID_Trismestre,
    ID_Sprint, ID_Fecha_Inicio_Sprint, ID_Fecha_Fin_Sprint,
    ID_Historia, ID_Historia_Descripccion, ID_Historia_Persona_Asignada, ID_Fecha_Inicio_Historia, ID_Fecha_Fin_Historia,
    Horas_Planificadas, Horas_Reales, Costo_Real, 
    PV, EV, SV, Variacion_Esfuerzo
) VALUES 
-- Enero: 15h Bugs
(13, 1, 4, 6, 19, 6, 5, 4, 3, 6, 5, 4, 2, 4, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.00, 15.00, 1800.00, 0.00, 0.00, 0.00, 15.00),
-- Marzo: 95h Bugs (ALERTA)
(13, 1, 4, 6, 19, 6, 5, 4, 3, 6, 5, 4, 2, 4, 3, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.00, 95.00, 11400.00, 0.00, 0.00, 0.00, 95.00);