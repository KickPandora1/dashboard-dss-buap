document.addEventListener('DOMContentLoaded', () => {
    // Instanciamos el Modelo y la Vista
    const model = new ProjectModel();
    const view = new DashboardView();
    
    // El Controlador une ambos y arranca la app
    const app = new AppController(model, view);
});