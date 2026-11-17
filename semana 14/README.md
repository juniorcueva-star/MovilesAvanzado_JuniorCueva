# Semana 14 — Trabajo de la semana · Grupo B · Compras

App **Compras** en **SwiftUI + SwiftData** para una distribuidora: proveedores, costo promedio de los productos y compras al contado o al crédito, con dos roles (**Comprador** y **Supervisor**).

- Proyecto para abrir en la Mac: [`Compras/Compras.xcodeproj`](Compras/Compras.xcodeproj)
- [Expediente del caso](EXPEDIENTE.md) (modelo, permisos, reglas con ejemplos y casos de prueba)
- [Registro de consultas a la IA](PROMPTS.md)

Requiere **Xcode 16 o posterior** y un simulador con **iOS 17 o posterior**. No usa paquetes externos.

```bash
git switch main
git pull --ff-only
open "semana 14/Compras/Compras.xcodeproj"
```

Elige el esquema **Compras**, un iPhone del simulador y pulsa **Run** (⌘R). Las pruebas se ejecutan con **⌘U**.

## Estructura del código

| Carpeta | Qué contiene |
| --- | --- |
| `Modelos/` | Las cuatro clases `@Model` (`Usuario`, `Proveedor`, `Producto`, `Compra`) y `ModelContainerProvider` (archivo `ComprasData.sqlite`) |
| `Sesion/` | `Sesion` (`@Observable`, usuario conectado) y `ServicioAuth` (registro y login con `FetchDescriptor` + `#Predicate` + `fetchCount`) |
| `Reglas/` | `ReglasCompra` (IGV, aprobación, costo promedio), `ServicioCompras` (registrar, aprobar, rechazar, pagar), `DatosEjemplo` y formato de soles |
| `Vistas/` | Las 9 pantallas y el menú del avatar |
| `ComprasTests/` | Los casos de prueba del laboratorio con XCTest |

## Pantallas

| Pant. | Archivo | Rol |
| --- | --- | --- |
| B1 Login | `LoginView.swift` | Todos |
| B2 Crear cuenta | `RegistroView.swift` | Todos |
| B3 Productos | `ProductosView.swift` + `ProductoFormView.swift` | Ambos (crear, editar y borrar solo supervisor) |
| B4 Proveedores | `ProveedoresView.swift` + `ProveedorFormView.swift` | Ambos (crear, editar y borrar solo supervisor) |
| B5 Nueva compra | `NuevaCompraView.swift` | Comprador |
| B6 Mis compras | `MisComprasView.swift` | Comprador |
| B7 Aprobar | `AprobarView.swift` | Supervisor |
| B8 Por pagar | `PorPagarView.swift` | Supervisor |
| B9 Resumen | `ResumenView.swift` | Supervisor |
| Cuenta | `AvatarMenu.swift` (menú del avatar con Cerrar sesión) | Todos |

## Cómo probar los casos en el simulador

1. Crea una cuenta **Supervisor** (por ejemplo `lparedes`, clave `abcdef`).
2. En **Resumen**, botón ⋯ ▸ **Cargar datos de ejemplo**: crea 2 proveedores, 3 productos (Laptop con stock 40 y costo 110.00) y una compra al crédito ya vencida (caso 8).
3. Cierra sesión desde el avatar y crea una cuenta **Comprador** (`mtorres`, clave `123456`).
4. En **Compra** registra los casos 3 a 7 y revisa **Mis compras**.
5. Vuelve como supervisor para **Aprobar**, **Rechazar** y **Pagar**.

| N.º | Caso | Resultado esperado | Prueba automática |
| --- | --- | --- | --- |
| 1 | Registrar "mtorres" y repetirlo | El repetido se rechaza (también "MTORRES") | `testCaso1UsuarioRepetido` |
| 2 | Login con clave incorrecta | "Usuario o clave incorrectos" | `testCaso2LoginIncorrecto` |
| 3 | 10 a 120.00 al crédito (stock 40, costo 110.00) | 1,200.00 · IGV 216.00 · total 1,416.00 · Aprobada · stock 50 · costo 112.00 · vence a 30 días | `testCaso3CompraAlCredito` |
| 4 | Igual al contado | Pagada, no aparece por pagar | `testCaso4CompraAlContado` |
| 5 | 50 a 120.00 | Total 7,080.00 · Pendiente · stock 40 | `testCaso5CompraGrandePendiente` |
| 6 | Aprobar el caso 5 | Stock 90 · costo 115.56 · aparece en Por pagar | `testCaso6SupervisorAprueba` |
| 7 | Rechazar sin motivo y con motivo | Sin motivo no se puede; con motivo queda Rechazada | `testCaso7RechazoConMotivo` |
| 8 | Compra vencida y pagar | VENCIDA; al pagar pasa a Pagadas y baja el total | `testCaso8VencidaYPagar` |
| 9 | Comprador intenta pagar | Solo ve sus compras y no puede pagar | `testCaso9CompradorNoPuedePagar` |

Las pruebas también corren en GitHub Actions con Xcode ([workflow](../.github/workflows/lab14-compras-ios.yml)).

## Para la defensa

- **Relaciones:** `@Relationship(deleteRule: .deny, inverse: \Compra.comprador)` en `Usuario` (igual en `Proveedor` y `Producto`). Basta asignar `compra.producto = producto`; SwiftData llena el lado inverso.
- **Usuario único:** se guarda en minúsculas y se busca con `#Predicate { $0.usuario == buscado }` y `fetchCount`.
- **Sesión:** `Sesion` es `@Observable` y se pone con `.environment(sesion)`; `ContentView` muestra `PrincipalView` si hay usuario o `LoginView` si no. Cerrar sesión = `usuario = nil`.
- **Costo promedio:** `ReglasCompra.nuevoCostoPromedio` → (40 × 110 + 10 × 120) / 50 = 112.00.
- **Aprobación:** `ServicioCompras.registrar` deja la compra Aprobada si el total es menor a 5,000; si no, Pendiente y no toca el producto hasta `aprobar`.
- **Filtros con #Predicate:** `MisComprasView` (Todas / Pendientes / Rechazadas) y `PorPagarView` (Pendientes / Vencidas / Pagadas, con la fecha de hoy).
- **Cierre de IGV con el Grupo A:** la tarjeta *Crédito fiscal (IGV)* del Resumen muestra el total y el del mes.
