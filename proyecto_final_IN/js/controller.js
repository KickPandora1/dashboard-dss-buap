class AppController {
    constructor(model, view) {
        this.model = model;
        this.view = view;
        this.allData = []; // Cache de datos
        
        this.init();
    }

    async init() {
        console.log("Iniciando aplicación MVC...");
        
        // 1. Obtener datos (Modelo)
        this.allData = await this.model.fetchProjects();

        // 2. Inicializar Filtros (Vista)
        const years = this.model.getUniqueYears(this.allData);
        const methods = this.model.getUniqueMethods(this.allData);
        this.view.populateSelects(years, methods);

        // 3. Configurar Eventos (Interacción)
        this.view.bindFilters(() => this.handleFilterChange());
        this.view.bindNavigation((target) => this.view.switchTab(target));
        this.view.bindRayleigh(() => this.handleRayleighCalc());

        // 4. Render inicial
        this.updateDashboard();
        this.handleRayleighCalc();
    }

    handleFilterChange() {
        this.updateDashboard();
    }

    handleRayleighCalc() {
        const name = document.getElementById('rayleigh-name').value || "Proyecto Sin Nombre";
        const kloc = parseFloat(document.getElementById('rayleigh-kloc').value) || 50;
        const comp = parseFloat(document.getElementById('rayleigh-comp').value) || 1.2;
        
        const results = this.model.calculateRayleigh(kloc, comp);
        this.view.updateRayleighChart(results, name);
    }

    updateDashboard() {
        const yearVal = document.getElementById('yearFilter').value;
        const methodVal = document.getElementById('methodFilter').value;

        // Filtrar datos
        const filtered = this.allData.filter(p => {
            return (yearVal === 'all' || p.year == yearVal) &&
                   (methodVal === 'all' || p.method === methodVal);
        });

        // --- CORRECCIÓN PRINCIPAL AQUÍ ---
        // Usamos parseFloat() para asegurar que sumamos números, no textos.
        const totals = filtered.reduce((acc, curr) => ({
            pv: acc.pv + (parseFloat(curr.pv) || 0),
            ev: acc.ev + (parseFloat(curr.ev) || 0),
            ac: acc.ac + (parseFloat(curr.ac) || 0),
            rework: acc.rework + (parseFloat(curr.rework) || 0)
        }), { pv: 0, ev: 0, ac: 0, rework: 0 });

        // Calcular Métricas (Evitando divisiones por cero)
        const metrics = {
            spi: totals.pv > 0 ? (totals.ev / totals.pv) : 0,
            cpi: totals.ac > 0 ? (totals.ev / totals.ac) : 0,
            sv: totals.ev - totals.pv,
            totalRework: totals.rework
        };

        // Preparar datos para gráficos
        const labels = [...new Set(filtered.map(d => d.year))].sort();
        const chartData = {
            labels,
            pv: labels.map(y => filtered.filter(d => d.year === y).reduce((a,b)=> a + (parseFloat(b.pv)||0), 0)),
            ev: labels.map(y => filtered.filter(d => d.year === y).reduce((a,b)=> a + (parseFloat(b.ev)||0), 0)),
            ac: labels.map(y => filtered.filter(d => d.year === y).reduce((a,b)=> a + (parseFloat(b.ac)||0), 0))
        };

        const methodsData = {};
        filtered.forEach(d => {
            // Sumar costos por metodología
            methodsData[d.method] = (methodsData[d.method] || 0) + (parseFloat(d.ac) || 0);
        });

        // Actualizar Vista
        this.view.updateKPIs(metrics);
        this.view.updateTable(filtered);
        this.view.updateCharts(chartData, methodsData);
    }
}