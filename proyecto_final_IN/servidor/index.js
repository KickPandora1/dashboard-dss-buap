const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD, // Sin contraseña por defecto por seguridad
    database: process.env.DB_NAME || 'Gestion_Proyectos',
    port: process.env.DB_PORT || 3306
};

// Esto es vital para que Railway sepa dónde escuchar
const PORT = process.env.PORT || 3000;

// --- RUTA API ---
app.get('/api/datos', async (req, res) => {
    let connection;
    try {
        connection = await mysql.createConnection(dbConfig);

        // --- CONSULTA SQL ADAPTADA A TU ESQUEMA ---
        // Unimos la tabla de hechos (Fact) con las dimensiones para obtener los nombres reales
        const query = `
            SELECT 
                p.ID_Proyecto as id,
                p.Nombre_Proyecto as name,
                da.Anio as year,
                pm.Metoddologia_Proyecto as method,
                ea.Area as area,
                
                -- Sumamos los valores por si hay múltiples registros por proyecto
                SUM(f.PV) as pv,
                SUM(f.EV) as ev,
                SUM(f.Costo_Real) as ac,
                
                -- Usamos 'Variacion_Esfuerzo' como proxy de Rework (o 0 si es null)
                COALESCE(SUM(f.Variacion_Esfuerzo), 0) as rework,
                
                -- KLOC no existe en tu BD, ponemos un valor aleatorio o fijo para que la gráfica Rayleigh funcione
                50 as kloc

            FROM Fact_Gestion_Proyecto f
            JOIN DimProyecto p ON f.ID_Proyecto = p.ID_Proyecto
            JOIN DimAnio da ON f.ID_Anio = da.ID_anio
            JOIN Proyecto_Metodologia pm ON f.ID_Proyecto_Metodologia = pm.ID_Proyecto_Metodologia
            JOIN DimEmpleado_Area ea ON f.ID_Empleado_Area = ea.ID_Empleado_Area
            
            GROUP BY 
                p.ID_Proyecto, 
                p.Nombre_Proyecto, 
                da.Anio, 
                pm.Metoddologia_Proyecto, 
                ea.Area
        `;

        const [rows, fields] = await connection.execute(query);

        // Verificar si trajimos datos
        if (rows.length === 0) {
            console.warn("⚠️ La consulta no devolvió datos. Revisa si 'Fact_Gestion_Proyecto' tiene información.");
        }

        res.json(rows);

    } catch (err) {
        console.error("❌ Error de Conexión MySQL:", err.message);
        res.status(500).send("Error al conectar con la BD: " + err.message);
    } finally {
        if (connection) await connection.end();
    }
});

app.listen(PORT, () => {
    console.log(`Servidor conectado a 'Gestion_Proyectos' en http://localhost:${PORT}`);
});