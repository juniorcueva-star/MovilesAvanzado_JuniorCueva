# Semana 9 — Laboral Perú

Aplicación sencilla en **SwiftUI** con tres pestañas: **CTS**, **Gratificación** e **Instructores**.

- Proyecto para abrir en la Mac: [`LaboralPeru/LaboralPeru.xcodeproj`](LaboralPeru/LaboralPeru.xcodeproj).
- Pantallas, variables y fórmulas: [`ContentView.swift`](LaboralPeru/LaboralPeru/ContentView.swift).
- [Requerimientos breves](REQUERIMIENTOS.md).
- [Investigación y fuentes oficiales de Perú](BASE_LEGAL_PERU.md).
- [Guía para abrir la app y explicarla al profesor](GUIA_PARA_EXPLICAR.md).
- [Excel con las mismas fórmulas de la app](Laboral_Peru_Lab09.xlsx).

Requiere **Xcode 15 o posterior** y un simulador con **iOS 17 o posterior**. No necesita paquetes externos, servidor ni API.

En Terminal, desde la carpeta del repositorio:

```bash
git switch main
git pull --ff-only
open "semana 09/LaboralPeru/LaboralPeru.xcodeproj"
```

Selecciona el esquema **LaboralPeru**, un simulador de iPhone y pulsa **Run** (⌘R). El proyecto anterior sigue en `semana 08`.

## Alcance de los cálculos

Régimen privado general y remuneración fija. CTS utiliza la gratificación efectivamente recibida en su semestre, sin bonificación. El cálculo de gratificación supone meses calendario completos y ausencia de faltas no computables.

Instructores aplica las condiciones del docente: S/ 50 por hora, hasta 23 horas semanales y cuatro semanas. Para quinta categoría simula el mismo sueldo durante todo 2026, dos gratificaciones completas, un empleador y cobertura EsSalud. Las tasas AFP de referencia son las publicadas para octubre de 2026. EsSalud es un aporte del empleador y no disminuye el neto. Consulta los supuestos visibles en la aplicación y la base legal antes de cambiar el escenario.

## Verificación

El Excel contiene **CTS**, **Gratificacion**, **Instructores** y **Quinta 2026**. Cambia las celdas amarillas y coloca exactamente los mismos datos en la app. Los parámetros, supuestos y redondeos son los mismos; la hoja de quinta categoría muestra las retenciones de enero a diciembre.

Para exponer, muestra primero los datos y el cálculo paso a paso del Excel y después repite el ejemplo en la app:

| Ejemplo | Resultado en Excel y app |
| --- | --- |
| CTS: sueldo S/ 3,000, gratificación recibida S/ 3,000, 6 meses y 0 días; cumple jornada mínima | S/ 1,750.00 |
| Gratificación: sueldo S/ 3,000, 6 meses completos, sin EPS | S/ 3,270.00 antes de quinta categoría |
| Instructor: 23 horas, octubre, ONP; supuestos anuales del ejercicio | S/ 3,829.34 netos |

El archivo pasó 28 comprobaciones durante su generación y 22 comprobaciones al abrirlo y recalcularlo en Microsoft Excel. Se verificaron ONP, AFP con comisión por flujo y saldo, EPS, meses con gratificación, EsSalud mínimo, datos inválidos y conciliación del impuesto anual. Las fuentes están junto a los cálculos.

`LaboralPeruTests.swift` contiene 10 pruebas con ejemplos, límites y conciliación anual. En Xcode se ejecutan con **⌘U**. El flujo [Laboratorio 9 — Compilar y probar iOS](../../.github/workflows/lab09-ios.yml) usa un simulador en GitHub Actions para compilar la interfaz y ejecutar estas pruebas.

También hay comprobaciones de las funciones reales de `ContentView.swift` en `PruebasCLI/main.swift`, ejecutables con Swift para Windows y las herramientas de C++ configuradas. La revisión visual de la app se hace en Xcode y el simulador.
