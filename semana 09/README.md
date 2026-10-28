# Semana 9 — Laboral Perú

Aplicación sencilla en **SwiftUI** con tres pestañas: **CTS**, **Gratificación** e **Instructores**.

- Proyecto para abrir en la Mac: [`LaboralPeru/LaboralPeru.xcodeproj`](LaboralPeru/LaboralPeru.xcodeproj).
- Pantallas, variables y fórmulas: [`ContentView.swift`](LaboralPeru/LaboralPeru/ContentView.swift).
- [Requerimientos breves](REQUERIMIENTOS.md).
- [Investigación y fuentes oficiales de Perú](BASE_LEGAL_PERU.md).
- [Guía para abrir la app y explicarla al profesor](GUIA_PARA_EXPLICAR.md).

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

`LaboralPeruTests.swift` contiene 10 pruebas con ejemplos, límites y conciliación anual. En Xcode se ejecutan con **⌘U**. El flujo [Laboratorio 9 — Compilar y probar iOS](../../.github/workflows/lab09-ios.yml) usa un simulador en GitHub Actions para compilar la interfaz y ejecutar estas pruebas.

También hay comprobaciones de las funciones reales de `ContentView.swift` en `PruebasCLI/main.swift`, ejecutables con Swift para Windows y las herramientas de C++ configuradas. La revisión visual de la app se hace en Xcode y el simulador.
