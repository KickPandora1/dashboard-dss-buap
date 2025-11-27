import pandas as pd
import random
import datetime
from sqlalchemy import create_engine
from decimal import Decimal
import os
from dotenv import load_dotenv

# -------------------------------------------------------------------------
# CONFIGURACIÓN DE CONEXIÓN
# -------------------------------------------------------------------------
# Cambia 'usuario', 'password' y 'localhost' por tus credenciales reales
load_dotenv()

# Si no encuentra la variable, usa 'localhost' como plan B
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_USER = os.getenv('DB_USER', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD') # La contraseña vendrá del sistema
DB_NAME = os.getenv('DB_NAME', 'Gestion_Proyectos')
DB_PORT = os.getenv('DB_PORT', '3306')

DB_CONNECTION_STR = f'mysql+pymysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}'
db_connection = create_engine(DB_CONNECTION_STR)

# Cantidad de datos de prueba a generar
NUM_REGISTROS = 1000

print("--- INICIANDO PROCESO ETL ---")

# -------------------------------------------------------------------------
# 1. EXTRACCIÓN (LOOKUPS DE DIMENSIONES)
# -------------------------------------------------------------------------
# Traemos los IDs existentes para asegurar integridad referencial
print("1. Extrayendo IDs de dimensiones...")
ids_proyectos = pd.read_sql("SELECT ID_Proyecto FROM DimProyecto", db_connection)['ID_Proyecto'].tolist()
ids_empleados = pd.read_sql("SELECT ID_Empleado FROM DimEmpleado", db_connection)['ID_Empleado'].tolist()
ids_tareas = pd.read_sql("SELECT ID_Tarea FROM DimTarea", db_connection)['ID_Tarea'].tolist()
# Traemos tarifas completas para cálculo de costos
df_tarifas = pd.read_sql("SELECT ID_Empleado_Tarifa_Hora, Tarifa_Hora FROM DimEmpleado_Tarifa_Hora", db_connection)

# -------------------------------------------------------------------------
# 2. TRANSFORMACIÓN Y GENERACIÓN (Lógica de Negocio Kimball)
# -------------------------------------------------------------------------
print(f"2. Generando {NUM_REGISTROS} registros con lógica de negocio...")

data_rows = []

start_date = datetime.date(2020, 1, 1)
end_date = datetime.date(2025, 12, 31)
dias_totales = (end_date - start_date).days

for _ in range(NUM_REGISTROS):
    # --- A. Selección Aleatoria de Dimensiones ---
    id_proj = random.choice(ids_proyectos)
    id_emp = random.choice(ids_empleados)
    id_tarea = random.choice(ids_tareas)
    
    # Seleccionar tarifa y obtener su valor monetario
    tarifa_row = df_tarifas.sample(1).iloc[0]
    id_tarifa = tarifa_row['ID_Empleado_Tarifa_Hora']
    valor_tarifa = float(tarifa_row['Tarifa_Hora'])
    
    # Generar fecha aleatoria
    random_days = random.randint(0, dias_totales)
    fecha_actual = start_date + datetime.timedelta(days=random_days)
    
    # Dimensiones de Tiempo
    id_dia = fecha_actual.day
    id_mes = fecha_actual.month
    # Ajuste: En tu tabla DimAnio, ID 1 es 2020. 
    id_anio = fecha_actual.year - 2019 
    id_trimestre = (fecha_actual.month - 1) // 3 + 1
    
    # --- B. Simulación de Esfuerzo y Costos (Grano: Registro diario) ---
    # Horas planificadas para hoy (entre 2 y 8 horas)
    horas_plan = random.randint(2, 8)
    
    # Factor de desempeño: 
    # < 1.0: Eficiente (menos tiempo del planeado)
    # > 1.0: Ineficiente (más tiempo del planeado, ej. bugs)
    factor_realidad = random.uniform(0.5, 1.5) 
    horas_reales = round(horas_plan * factor_realidad, 2)
    
    # Porcentaje de avance real logrado hoy (0.1 a 1.0)
    avance_pct = random.uniform(0.1, 1.0)

    # --- C. Cálculos de KPIs (Según Documentación Datawarehouse) ---
    # Costo Real = Horas Reales * Tarifa
    costo_real = round(horas_reales * valor_tarifa, 2)
    
    # PV (Planned Value): Valor presupuestado del trabajo programado
    pv = round(horas_plan * valor_tarifa, 2)
    
    # EV (Earned Value): Valor del trabajo realmente ejecutado
    ev = round(pv * avance_pct, 2)
    
    # SV (Schedule Variance): EV - PV
    # Si es negativo, vamos retrasados. Si es positivo, adelantados.
    sv = round(ev - pv, 2)
    
    # Variación de Esfuerzo (Horas)
    var_esfuerzo = round(horas_reales - horas_plan, 2)

    # --- D. Construcción de la Fila ---
    row = {
        'ID_Proyecto': id_proj,
        'ID_Empleado': id_emp,
        'ID_Empleado_Tarifa_Hora': id_tarifa,
        'ID_Tarea': id_tarea,
        'ID_Dia': id_dia,
        'ID_Mes': id_mes,
        'ID_Anio': id_anio,
        'ID_Trismestre': id_trimestre,
        'Horas_Reales': horas_reales,
        'Costo_Real': costo_real,
        'Horas_Planificadas': horas_plan,
        'EV': ev,
        'PV': pv,
        'SV': sv,
        'Variacion_Esfuerzo': var_esfuerzo,
        
        # Dummies para completar FKs obligatorias (Valores aleatorios simples)
        'ID_Proyecto_Estado': random.randint(1, 5),
        'ID_Proyecto_Tipo': random.randint(1, 4),
        'ID_Empleado_Rol': random.randint(1, 6),
        'ID_Empleado_Area': random.randint(1, 5),
        'ID_Empleado_Perfil': random.randint(1, 4),
        'ID_Tarea_Tipo': random.randint(1, 6),
        'ID_Tarea_Estado': random.randint(1, 4),
        'ID_Tarea_Horas_Planificadas': random.randint(1, 6),
        'ID_Proyecto_Metodologia': random.randint(1, 6),
        
        # IDs por defecto (Dummy '1') para simplificar Sprints/Historias en este ejemplo masivo
        'ID_Sprint': 1,
        'ID_Fecha_Inicio_Sprint': 1,
        'ID_Fecha_Fin_Sprint': 1,
        'ID_Historia': 1,
        'ID_Historia_Descripccion': 1,
        'ID_Historia_Persona_Asignada': 1,
        'ID_Fecha_Inicio_Historia': 1,
        'ID_Fecha_Fin_Historia': 1
    }
    data_rows.append(row)

# Crear DataFrame
df_fact = pd.DataFrame(data_rows)

# -------------------------------------------------------------------------
# 3. CARGA (LOAD)
# -------------------------------------------------------------------------
print(f"3. Cargando datos en MySQL ({len(df_fact)} filas)...")

# 'if_exists="append"' agrega los datos sin borrar la tabla
try:
    df_fact.to_sql('Fact_Gestion_Proyecto', con=db_connection, if_exists='append', index=False)
    print("--- ÉXITO: Carga completada correctamente ---")
except Exception as e:
    print(f"--- ERROR: Falló la carga: {e}")