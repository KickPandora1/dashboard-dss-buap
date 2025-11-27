CREATE DATABASE Gestion_Proyectos;
USE Gestion_Proyectos;
CREATE TABLE DimProyecto (
    ID_Proyecto INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Proyecto VARCHAR(150)
);
CREATE TABLE DimProyecto_Estado (
    ID_Proyecto_Estado INT PRIMARY KEY AUTO_INCREMENT,
    Estado_Proyecto VARCHAR(50)
);
CREATE TABLE DimProyecto_Tipo (
    ID_Proyecto_Tipo INT PRIMARY KEY AUTO_INCREMENT,
    Tipo_Proyecto VARCHAR(50)

);
CREATE TABLE Proyecto_Metodologia (
    ID_Proyecto_Metodologia INT PRIMARY KEY AUTO_INCREMENT,
    Metoddologia_Proyecto VARCHAR(100)
);
CREATE TABLE DimEmpleado (
    ID_Empleado INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Empleado VARCHAR(150),
    anio INT
);
CREATE TABLE DimEmpleado_Rol (
    ID_Empleado_Rol INT PRIMARY KEY AUTO_INCREMENT,
    Rol VARCHAR(50)
);
CREATE TABLE DimEmpleado_Area (
    ID_Empleado_Area INT PRIMARY KEY AUTO_INCREMENT,
    Area VARCHAR(50)
);
CREATE TABLE DimEmpleado_Tarifa_Hora (
    ID_Empleado_Tarifa_Hora INT PRIMARY KEY AUTO_INCREMENT,
    Tarifa_Hora DECIMAL(10,2)
);
CREATE TABLE DimEmpleado_Perfil (
    ID_Empleado_Perfil INT PRIMARY KEY AUTO_INCREMENT,
    Seniority VARCHAR(20)
);

CREATE TABLE DimTarea (
    ID_Tarea INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Tarea VARCHAR(200)
);
CREATE TABLE DimTipo_Tarea (
    ID_Tarea INT PRIMARY KEY AUTO_INCREMENT,
    Tipo_Tarea VARCHAR(50)
);
CREATE TABLE DimTarea_Estado (
    ID_Tarea_Estado INT PRIMARY KEY AUTO_INCREMENT,
    Estado_Tarea VARCHAR(50)
);
CREATE TABLE DimTarea_Horas_Planificadas(
    ID_Tarea_Horas_Planificadas INT PRIMARY KEY AUTO_INCREMENT,
    Horas_Planificadas DECIMAL(10,2)
);

CREATE TABLE DimDia (
    ID_Dia INT PRIMARY KEY,
    Dia INT
);
CREATE TABLE DimMes (
    ID_Mes INT PRIMARY KEY,
    Mes INT
);
CREATE TABLE DimAnio (
    ID_anio INT PRIMARY KEY,
    Anio INT
);
CREATE TABLE DimTrismestre (
    ID_Trismestre INT PRIMARY KEY,
    Trimestre VARCHAR(5)
);

CREATE TABLE DimSprint (
    ID_Sprint INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Sprint VARCHAR(100),
    Numero_Sprint INT
);
CREATE TABLE DimFecha_Inicio_Sprint (
    ID_Fecha INT PRIMARY KEY AUTO_INCREMENT,
    Dia INT,
    Mes INT,
    Anio INT,
    FOREIGN KEY (Dia) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (Mes) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (Anio) REFERENCES DimAnio(ID_Anio)
);
 CREATE TABLE DimFecha_Fecha_Fin_Sprint (
    ID_Fecha INT PRIMARY KEY AUTO_INCREMENT,
    Dia INT,
    Mes INT,
    anio INT,
    Dia_real INT,
    Mes_real INT,
    anio_real INT,

    FOREIGN KEY (Dia) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (Mes) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (anio) REFERENCES DimAnio(ID_anio),
    FOREIGN KEY (Dia_real) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (Mes_real) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (anio_real) REFERENCES DimAnio(ID_anio)
);


CREATE TABLE DimHistoria (
    ID_Historia INT PRIMARY KEY AUTO_INCREMENT,
    Nombre_Historia VARCHAR(100),
    Numero_Historia INT
);
CREATE TABLE DimHistoria_Descripccion (
    ID_Historia_descripccion INT PRIMARY KEY AUTO_INCREMENT,
    Descripccion VARCHAR(100)
);
CREATE TABLE DimHistoria_Persona_Asignada(
    ID_Historia_PA INT PRIMARY KEY AUTO_INCREMENT,
    Persona INT,
    FOREIGN KEY (Persona) REFERENCES DimEmpleado(ID_Empleado)
);
CREATE TABLE DimFecha_Inicio_Historia (
    ID_Fecha INT PRIMARY KEY AUTO_INCREMENT,
    Dia INT,
    Mes INT,
    anio INT,

    FOREIGN KEY (Dia) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (Mes) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (anio) REFERENCES DimAnio(ID_anio)
);
 CREATE TABLE DimFecha_Fecha_Fin_Historia (
    ID_Fecha INT PRIMARY KEY AUTO_INCREMENT,
    Dia INT,
    Mes INT,
    anio INT,
    Dia_real INT,
    Mes_real INT,
    anio_real INT,

    FOREIGN KEY (Dia) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (Mes) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (anio) REFERENCES DimAnio(ID_anio),
    FOREIGN KEY (Dia_real) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (Mes_real) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (anio_real) REFERENCES DimAnio(ID_anio)
);

CREATE TABLE Fact_Gestion_Proyecto (
    ID_Fact INT PRIMARY KEY AUTO_INCREMENT,
    ID_Proyecto INT,
    ID_Proyecto_Estado INT,
    ID_Proyecto_Tipo INT,
    ID_Empleado INT,
    ID_Empleado_Rol INT,
    ID_Empleado_Area INT,
    ID_Empleado_Tarifa_Hora INT,
    ID_Empleado_Perfil INT,
    ID_Tarea INT,
    ID_Tarea_Tipo INT,
    ID_Tarea_Estado INT,
    ID_Tarea_Horas_Planificadas INT,
    ID_Dia INT,
    ID_Mes INT,
    ID_Anio INT,
    ID_Trismestre INT,
    ID_Sprint INT,
    ID_Fecha_Inicio_Sprint INT,
    ID_Fecha_Fin_Sprint INT,
    ID_Proyecto_Metodologia INT,


    ID_Historia INT,
    ID_Historia_Descripccion INT,
    ID_Historia_Persona_Asignada INT,
    ID_Fecha_Inicio_Historia INT,
    ID_Fecha_Fin_Historia INT,
    Horas_Reales DECIMAL(10,2),
    Costo_Real DECIMAL(10,2),
    Horas_Planificadas DECIMAL(10,2),
    EV DECIMAL(10,2),
    PV DECIMAL(10,2),
    SV DECIMAL(10,2),
    Variacion_Esfuerzo DECIMAL(10,2),


    FOREIGN KEY (ID_Proyecto) REFERENCES DimProyecto(ID_Proyecto),
    FOREIGN KEY (ID_Proyecto_Estado) REFERENCES DimProyecto_Estado(ID_Proyecto_Estado),
    FOREIGN KEY (ID_Proyecto_Tipo) REFERENCES DimProyecto_Tipo(ID_Proyecto_Tipo),
    FOREIGN KEY (ID_Proyecto_Metodologia) REFERENCES Proyecto_Metodologia(ID_Proyecto_Metodologia),

    FOREIGN KEY (ID_Empleado) REFERENCES DimEmpleado(ID_Empleado),
    FOREIGN KEY (ID_Empleado_Rol) REFERENCES DimEmpleado_Rol(ID_Empleado_Rol),
    FOREIGN KEY (ID_Empleado_Area) REFERENCES DimEmpleado_Area(ID_Empleado_Area),
    FOREIGN KEY (ID_Empleado_Tarifa_Hora) REFERENCES DimEmpleado_Tarifa_Hora(ID_Empleado_Tarifa_Hora),
    FOREIGN KEY (ID_Empleado_Perfil) REFERENCES DimEmpleado_Perfil(ID_Empleado_Perfil),

    FOREIGN KEY (ID_Tarea) REFERENCES DimTarea(ID_Tarea),
    FOREIGN KEY (ID_Tarea_Tipo) REFERENCES DimTipo_Tarea(ID_Tarea),
    FOREIGN KEY (ID_Tarea_Estado) REFERENCES DimTarea_Estado(ID_Tarea_Estado),
    FOREIGN KEY (ID_Tarea_Horas_Planificadas) REFERENCES DimTarea_Horas_Planificadas(ID_Tarea_Horas_Planificadas),

    FOREIGN KEY (ID_Dia) REFERENCES DimDia(ID_Dia),
    FOREIGN KEY (ID_Mes) REFERENCES DimMes(ID_Mes),
    FOREIGN KEY (ID_Anio) REFERENCES DimAnio(ID_Anio),
    FOREIGN KEY (ID_Trismestre) REFERENCES DimTrismestre(ID_Trismestre),

    FOREIGN KEY (ID_Sprint) REFERENCES DimSprint(ID_Sprint),
    FOREIGN KEY (ID_Fecha_Inicio_Sprint) REFERENCES DimFecha_Inicio_Sprint(ID_Fecha),
    FOREIGN KEY (ID_Fecha_Fin_Sprint) REFERENCES DimFecha_Fecha_Fin_Sprint(ID_Fecha),

    FOREIGN KEY (ID_Historia) REFERENCES DimHistoria(ID_Historia),
    FOREIGN KEY (ID_Historia_Descripccion) REFERENCES DimHistoria_Descripccion(ID_Historia_Descripccion),
    FOREIGN KEY (ID_Historia_Persona_Asignada) REFERENCES DimHistoria_Persona_Asignada(ID_Historia_PA),
    FOREIGN KEY (ID_Fecha_Inicio_Historia) REFERENCES DimFecha_Inicio_Historia(ID_Fecha),
    FOREIGN KEY (ID_Fecha_Fin_Historia) REFERENCES DimFecha_Fecha_Fin_Historia(ID_Fecha)
);
