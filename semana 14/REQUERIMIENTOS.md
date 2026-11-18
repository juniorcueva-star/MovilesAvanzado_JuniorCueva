# Compras · Requerimientos y valor agregado

App para una distribuidora: proveedores, productos con costo promedio y compras al contado o al crédito.
**SwiftUI + SwiftData · iOS 17+ · Grupo B**

## Requerimientos (qué hace la app)

**Todos**
- Crear cuenta (usuario único, clave de 6 o más) e iniciar sesión.
- Menú del avatar con nombre, rol y Cerrar sesión.

**Comprador**
- Ver y buscar productos y proveedores.
- Registrar compras al contado o a crédito (30 días) con IGV 18 %.
- Ver solo sus compras: Todas, Pendientes y Rechazadas (con el motivo).

**Supervisor**
- Crear, editar y borrar productos y proveedores (no se borran si tienen compras).
- Aprobar o rechazar con motivo las compras desde S/ 5,000, viendo antes el efecto en el stock y el costo.
- Pagar compras a crédito: Pendientes, Vencidas y Pagadas.
- Resumen: inventario, crédito fiscal, por pagar, por aprobar y gráfico por proveedor.

**Reglas**
- Total = subtotal + IGV 18 %. Menos de S/ 5,000 se aprueba sola; desde S/ 5,000 queda Pendiente.
- Al aprobar se recalcula el costo promedio ponderado y sube el stock.

## Valor agregado

| # | Mejora | Dónde |
| --- | --- | --- |
| 1 | **Historial de todas las compras** del supervisor, con filtro por estado y búsqueda | Resumen ▸ Todas las compras |
| 2 | **Número de compras por aprobar** en la pestaña Aprobar | Barra de pestañas |
| 3 | **RUC válido**: 11 dígitos, empieza con 10 o 20 y no se repite | Nuevo proveedor |
| 4 | **Alerta de stock bajo** (5 o menos) | Resumen |
| 5 | **Ver u ocultar la clave** con el ícono del ojo | Login y Crear cuenta |
