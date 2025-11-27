class DashboardView {
    constructor() {
        // Referencias al DOM (HTML)
        this.elements = {
            yearSelect: document.getElementById('yearFilter'),
            methodSelect: document.getElementById('methodFilter'),
            tableBody: document.getElementById('projects-table-body'),
            
            // KPIs
            kpiSpi: document.getElementById('kpi-spi'),
            kpiCpi: document.getElementById('kpi-cpi'),
            kpiSv: document.getElementById('kpi-sv'),
            kpiRework: document.getElementById('kpi-rework'),
            
            // Navegación y Alertas
            navButtons: document.querySelectorAll('.nav-btn'),
            views: document.querySelectorAll('.view-section'),
            alertBox: document.getElementById('smart-alert'),
            
            // Sección Rayleigh
            rayleighBtn: document.getElementById('btn-calc-rayleigh'),
            rayleighName: document.getElementById('rayleigh-name'),
            rayleighBadge: document.getElementById('rayleigh-badge'),
            rayleighAlert: document.getElementById('rayleigh-alert'),
            rayleighAlertText: document.querySelector('#rayleigh-alert p'),
            rayleighTotal: document.getElementById('rayleigh-total')
        };
        
        this.charts = { main: null, doughnut: null, rayleigh: null };
    }

    // --- MÉTODOS DE RENDERIZADO ---

    populateSelects(years, methods) {
        this.elements.yearSelect.innerHTML = '<option value="all">Todos los Años</option>' + 
            years.map(y => `<option value="${y}">${y}</option>`).join('');
        
        this.elements.methodSelect.innerHTML = '<option value="all">Todas las Metodologías</option>' + 
            methods.map(m => `<option value="${m}">${m}</option>`).join('');
    }

    updateKPIs(metrics) {
        // Actualizar Textos
        this.elements.kpiSpi.innerText = metrics.spi.toFixed(2);
        this.elements.kpiCpi.innerText = metrics.cpi.toFixed(2);
        this.elements.kpiSv.innerText = `$${(metrics.sv / 1000).toFixed(1)}k`;
        this.elements.kpiRework.innerText = metrics.totalRework.toLocaleString();

        // Actualizar Barras de Progreso
        const spiPercent = Math.min(metrics.spi * 100, 100);
        const cpiPercent = Math.min(metrics.cpi * 100, 100);

        document.getElementById('bar-spi').style.width = `${spiPercent}%`;
        document.getElementById('bar-spi').className = `h-1.5 rounded-full transition-all duration-1000 ${metrics.spi < 0.9 ? 'bg-red-500' : 'bg-indigo-600'}`;

        document.getElementById('bar-cpi').style.width = `${cpiPercent}%`;
        document.getElementById('bar-cpi').className = `h-1.5 rounded-full transition-all duration-1000 ${metrics.cpi < 0.9 ? 'bg-red-500' : 'bg-emerald-500'}`;

        // Mostrar Alerta si es necesario
        if (metrics.cpi < 0.85) {
            this.elements.alertBox.classList.remove('hidden');
            document.getElementById('smart-alert-msg').innerText = `Alerta Crítica: Eficiencia de Costos Baja (${metrics.cpi.toFixed(2)}).`;
        } else {
            this.elements.alertBox.classList.add('hidden');
        }
    }

    updateTable(projects) {
        this.elements.tableBody.innerHTML = projects.slice(0, 5).map(p => {
            const spi = p.ev / p.pv;
            const cpi = p.ev / p.ac;
            const status = cpi < 0.9 ? 
                '<span class="bg-red-100 text-red-800 text-xs px-2 py-0.5 rounded">Crítico</span>' : 
                '<span class="bg-green-100 text-green-800 text-xs px-2 py-0.5 rounded">Saludable</span>';
            
            return `
                <tr class="bg-white border-b hover:bg-gray-50">
                    <td class="px-6 py-4 font-medium">${p.name}</td>
                    <td class="px-6 py-4">${p.year}</td>
                    <td class="px-6 py-4 text-indigo-600">${p.method}</td>
                    <td class="px-6 py-4 font-bold">${spi.toFixed(2)}</td>
                    <td class="px-6 py-4 font-bold">${cpi.toFixed(2)}</td>
                    <td class="px-6 py-4">${p.kloc}</td>
                    <td class="px-6 py-4">${status}</td>
                </tr>
            `;
        }).join('');
    }

    updateCharts(data, methodsData) {
        // Gráfico Principal
        const ctxMain = document.getElementById('mainChart').getContext('2d');
        if (this.charts.main) this.charts.main.destroy();
        
        this.charts.main = new Chart(ctxMain, {
            type: 'bar',
            data: {
                labels: data.labels,
                datasets: [
                    { label: 'PV', data: data.pv, backgroundColor: '#e2e8f0' },
                    { label: 'EV', data: data.ev, backgroundColor: '#4f46e5' },
                    { label: 'AC', data: data.ac, backgroundColor: '#10b981' }
                ]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // Gráfico Dona
        const ctxDoughnut = document.getElementById('doughnutChart').getContext('2d');
        if (this.charts.doughnut) this.charts.doughnut.destroy();

        this.charts.doughnut = new Chart(ctxDoughnut, {
            type: 'doughnut',
            data: {
                labels: Object.keys(methodsData),
                datasets: [{
                    data: Object.values(methodsData),
                    backgroundColor: ['#4f46e5', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6'],
                    borderWidth: 0
                }]
            },
            options: { responsive: true, cutout: '70%', plugins: { legend: { display: false } } }
        });
    }

    updateRayleighChart(data, projectName) {
        this.elements.rayleighTotal.innerText = data.total.toLocaleString();
        this.elements.rayleighAlert.classList.remove('hidden');
        
        if(data.total > 500) {
            this.elements.rayleighBadge.innerText = "ALTO RIESGO";
            this.elements.rayleighBadge.className = "px-4 py-1.5 rounded-full text-sm font-bold bg-red-100 text-red-600 uppercase tracking-wide";
            this.elements.rayleighAlertText.innerHTML = `Alerta para <strong>${projectName}</strong>: Se estiman <strong>${data.total} defectos</strong>. Supera la capacidad de QA. Se recomienda refuerzos en el Mes ${data.peakMonth}.`;
            this.elements.rayleighAlert.className = "bg-red-50 border border-red-100 rounded-lg p-4 flex gap-3 items-start";
        } else {
            this.elements.rayleighBadge.innerText = "BAJO RIESGO";
            this.elements.rayleighBadge.className = "px-4 py-1.5 rounded-full text-sm font-bold bg-green-100 text-green-600 uppercase tracking-wide";
            this.elements.rayleighAlertText.innerHTML = `Estado Saludable para <strong>${projectName}</strong>: La proyección de <strong>${data.total} defectos</strong> es manejable. Pico en el Mes ${data.peakMonth}.`;
            this.elements.rayleighAlert.className = "bg-green-50 border border-green-100 rounded-lg p-4 flex gap-3 items-start";
        }

        const ctx = document.getElementById('rayleighChart').getContext('2d');
        if (this.charts.rayleigh) this.charts.rayleigh.destroy();

        this.charts.rayleigh = new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.labels,
                datasets: [{
                    label: 'Defectos Proyectados',
                    data: data.dataPoints,
                    borderColor: '#dc2626',
                    backgroundColor: 'rgba(220, 38, 38, 0.1)',
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#dc2626',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    pointRadius: 4
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false,
                plugins: { legend: { display: false }, tooltip: { backgroundColor: '#1e293b', padding: 12, cornerRadius: 8 }},
                scales: { y: { beginAtZero: true, grid: { color: '#f3f4f6' } }, x: { grid: { display: false } } }
            }
        });
    }

    // --- INTERACCIÓN ---

    switchTab(targetId) {
        this.elements.views.forEach(el => el.classList.add('hidden'));
        this.elements.navButtons.forEach(el => el.classList.remove('active', 'bg-indigo-50'));
        
        document.getElementById(`view-${targetId}`).classList.remove('hidden');
        document.querySelector(`button[data-target="${targetId}"]`).classList.add('active', 'bg-indigo-50');
    }

    bindFilters(handler) {
        this.elements.yearSelect.addEventListener('change', handler);
        this.elements.methodSelect.addEventListener('change', handler);
    }

    bindNavigation(handler) {
        this.elements.navButtons.forEach(btn => {
            btn.addEventListener('click', () => handler(btn.dataset.target));
        });
    }

    bindRayleigh(handler) {
        this.elements.rayleighBtn.addEventListener('click', handler);
    }
}