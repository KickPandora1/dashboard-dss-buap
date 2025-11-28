class ProjectModel {
    constructor() {
        this.database = []; // Iniciamos vacío, esperando datos reales
    }

    /**
     * Obtiene los proyectos desde tu API Local
     */
    async fetchProjects() {
        try {
            // Hacemos la petición a tu servidor local (el que crearemos en el paso 2)
            const response = await fetch('https://dashboard-dss-buap-production.up.railway.app/api/datos');

            if (!response.ok) throw new Error('Error en la respuesta del servidor');

            const data = await response.json();

            // Asignamos los datos reales a nuestra variable
            this.database = data;
            return this.database;

        } catch (error) {
            console.error("Error conectando a la Base de Datos:", error);
            console.warn("Cargando datos de respaldo (DEMO)...");

            // Si falla la conexión, cargamos datos falsos para que no se rompa la app
            return [
                { id: 1, name: "Error de Conexión", year: 2024, method: "Desconocido", area: "Soporte", pv: 0, ev: 0, ac: 0, rework: 0, kloc: 0 }
            ];
        }
    }

    getUniqueYears(data) {
        // Validación extra por si data viene vacío
        if (!data || data.length === 0) return [];
        return [...new Set(data.map(d => d.year))].sort((a, b) => b - a);
    }

    getUniqueMethods(data) {
        if (!data || data.length === 0) return [];
        return [...new Set(data.map(d => d.method))].sort();
    }

    calculateRayleigh(kloc, complexity) {
        const K = kloc * 25 * complexity;
        const tm = 4 * complexity;
        const labels = Array.from({ length: 12 }, (_, i) => `Mes ${i + 1}`);
        const dataPoints = labels.map((_, t) => {
            const time = t + 1;
            return (K / (tm * tm)) * time * Math.exp(-(time * time) / (2 * tm * tm));
        });
        return {
            labels,
            dataPoints,
            total: Math.round(dataPoints.reduce((a, b) => a + b, 0)),
            peakMonth: Math.round(tm)
        };
    }
}