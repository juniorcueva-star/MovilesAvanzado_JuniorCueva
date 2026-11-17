# Expediente · Trabajo de la semana · Grupo B · Caso Compras

## 1. Integrantes y caso

| Dato | Valor |
| --- | --- |
| Integrantes | Junior Cueva Fabian · (compañero) |
| Grupo | B |
| App | **Compras** (SwiftUI + SwiftData) |
| Curso | Programación en Móviles Avanzado · 5 C24 · Tecsup |

Una distribuidora registra proveedores, el costo de sus productos y sus compras al contado o al crédito. Hay dos roles: **Comprador** y **Supervisor**.

## 2. Modelo de datos

```
 ┌──────────────┐ 1      * ┌────────────────────┐ *      1 ┌──────────────┐
 │   Usuario    │──────────│       Compra       │──────────│  Proveedor   │
 │ nombre       │ compras  │ fecha  Date        │ compras  │ nombre       │
 │ usuario      │ (.deny)  │ cantidad  Int      │ (.deny)  │ ruc          │
 │ clave        │          │ costoUnitario Dbl  │          └──────────────┘
 │ rol          │          │ igv, total  Double │
 └──────────────┘          │ alCredito  Bool    │ *      1 ┌──────────────┐
                           │ vence  Date        │──────────│   Producto   │
                           │ estado  String     │ compras  │ nombre       │
                           │ pagada  Bool       │ (.deny)  │ categoria    │
                           │ motivoRechazo  S?  │          │ stock  Int   │
                           └────────────────────┘          │ costoPromedio│
                                                           └──────────────┘
```

| Clase @Model | Propiedades | Relaciones |
| --- | --- | --- |
| Usuario | nombre, usuario, clave, rol (String) | compras: [Compra] (.deny, inverse \Compra.comprador) |
| Proveedor | nombre, ruc (String) | compras: [Compra] (.deny, inverse \Compra.proveedor) |
| Producto | nombre, categoria (String), stock (Int), costoPromedio (Double) | compras: [Compra] (.deny, inverse \Compra.producto) |
| Compra | fecha (Date), cantidad (Int), costoUnitario, igv, total (Double), alCredito (Bool), vence (Date), estado (String), pagada (Bool), motivoRechazo (String?) | comprador: Usuario?, proveedor: Proveedor?, producto: Producto? |

**Regla de borrado .deny:** no se puede borrar un usuario, proveedor o producto que tenga compras. La app lo revisa antes de borrar y muestra una alerta.

`estado` solo toma tres valores: `Pendiente`, `Aprobada` o `Rechazada`. El usuario se guarda en minúsculas para que sea único sin distinguir mayúsculas.

## 3. Roles y permisos

| Qué puede hacer | Comprador | Supervisor |
| --- | --- | --- |
| Pestañas | Productos, Proveedores, Compra, Mis compras | Resumen, Aprobar, Por pagar, Productos, Proveedores |
| Productos y proveedores | Solo consultar y buscar | Crear, editar y borrar |
| Compras | Registrar y ver solo las suyas | Aprobar o rechazar, ver todo y pagar |
| Pagar una compra a crédito | No | Sí (deslizar Pagar) |
| Cuenta | Menú del avatar con Cerrar sesión | Menú del avatar con Cerrar sesión |

## 4. Reglas de negocio con ejemplos

| Regla | Fórmula | Ejemplo resuelto a mano |
| --- | --- | --- |
| Subtotal | cantidad × costo unitario | 10 × 120.00 = 1,200.00 |
| IGV (crédito fiscal) | 18 % del subtotal | 1,200.00 × 0.18 = 216.00 |
| Total | subtotal + IGV | 1,200.00 + 216.00 = 1,416.00 |
| Aprobación | total < 5,000 → Aprobada; total ≥ 5,000 → Pendiente | 1,416.00 → Aprobada · 7,080.00 → Pendiente |
| Costo promedio ponderado (al aprobar) | (stock × costoProm + cant × costoUnit) / (stock + cant) | (40 × 110 + 10 × 120) / 50 = 5,600 / 50 = **112.00** |
| Costo promedio caso grande | igual | (40 × 110 + 50 × 120) / 90 = 10,400 / 90 = **115.56** |
| Stock al aprobar | stock + cantidad | 40 + 10 = 50 · 40 + 50 = 90 |
| Contado | pagada = true | No entra a cuentas por pagar |
| Crédito 30 días | pagada = false, vence = fecha + 30 días | Compra del 17/11 vence el 17/12 |
| Vencida | crédito, aprobada, sin pagar y vence < hoy | Vencía el 07/11 y hoy es 17/11 → VENCIDA |
| Rechazo | exige motivo, no cambia stock ni costo | Stock se queda en 40 |

Una compra Pendiente **no** cambia stock, costo promedio ni cuentas por pagar hasta que el supervisor la aprueba.

## 5. Pantallas

| Pant. | Nombre | Lee | Escribe |
| --- | --- | --- | --- |
| B1 | Login | Usuario (usuario y clave) | Sesión |
| B2 | Crear cuenta | Usuario (¿existe?) | Usuario nuevo y sesión |
| B3 | Productos | Producto | Producto (solo supervisor) |
| B4 | Proveedores | Proveedor y sus compras | Proveedor (solo supervisor) |
| B5 | Nueva compra | Proveedor, Producto, sesión | Compra (y Producto si queda aprobada) |
| B6 | Mis compras | Compra del comprador | — |
| B7 | Aprobar | Compras pendientes | Compra (estado) y Producto (stock y costo) |
| B8 | Por pagar | Compras a crédito aprobadas | Compra (pagada) |
| B9 | Resumen | Producto y Compra | — |

## 6. Casos de prueba

| N.º | Caso | Resultado esperado |
| --- | --- | --- |
| 1 | Registrar a "mtorres" como Comprador e intentar repetir el usuario | Se crea el primero y entra a la app; el repetido se rechaza |
| 2 | Login con clave incorrecta | Mensaje "Usuario o clave incorrectos"; no entra |
| 3 | Producto con stock 40 y costo promedio 110.00. Compra de 10 a 120.00 al crédito | Subtotal 1,200.00 · IGV 216.00 · total 1,416.00 · Aprobada · stock 50 · costo promedio 112.00 · vence a 30 días |
| 4 | La misma compra, pero al contado | Queda pagada y no aparece en Pendientes de pago |
| 5 | Compra de 50 a 120.00 (total 7,080.00) | Queda Pendiente; el stock sigue en 40 y no suma a por pagar |
| 6 | El supervisor aprueba la compra del caso 5 | Stock 90 · costo promedio 115.56 · aparece en Por pagar |
| 7 | El supervisor rechaza otra compra grande sin motivo y luego con motivo | Sin motivo no se puede; con motivo queda Rechazada y el comprador ve el motivo; no cambia el stock |
| 8 | Compra a crédito con vencimiento ya pasado, y luego Pagar | Aparece en Vencidas con VENCIDA; al pagar pasa a Pagadas y el total por pagar baja |
| 9 | Un comprador abre Mis compras e intenta pagar | Solo ve sus compras y no tiene la opción de Pagar |
| 10 (propio) | Registrar con "MTORRES" en mayúsculas cuando ya existe "mtorres" | Se rechaza: el usuario se compara sin mayúsculas |
| 11 (propio) | El supervisor intenta borrar un producto que tiene compras | No se borra y aparece una alerta |

## 7. Plan de commits

1. Expediente del caso.
2. Proyecto SwiftUI con SwiftData.
3. Modelos y relaciones.
4. Reglas de negocio (IGV, aprobación, costo promedio).
5. B1 Login y sesión.
6. B2 Registro.
7. Pestañas por rol y menú del avatar.
8. B3 Productos.
9. B4 Proveedores.
10. B5 Nueva compra.
11. B6 Mis compras.
12. B7 Aprobar.
13. B8 Por pagar.
14. B9 Resumen.
15. Ícono y nombre "Compras".
16. Pruebas de los casos y compilación en GitHub.
17. README, PROMPTS.md y guía de defensa.

## 8. Plan de uso de IA

- A mano: modelo de datos, matriz de permisos, cálculos de los ejemplos y casos de prueba (este expediente).
- Con IA: estructura del proyecto, pantallas SwiftUI y pruebas automáticas.
- Verificación: los casos 3 a 7 se comparan con los números de la sección 4; además las pruebas XCTest se ejecutan en GitHub Actions con Xcode.
- Cada consulta se anota en [PROMPTS.md](PROMPTS.md).

## 9. Visto bueno

| Fecha | Docente | Confirmación |
| --- | --- | --- |
| ____/____/2026 | Juan León | ______________ |
