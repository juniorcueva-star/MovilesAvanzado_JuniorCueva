# Calculadora de venta a plazos: requisitos y uso

Este es el **Ejercicio 4 de la semana 6** del curso Programación en Móviles Avanzado. Es una aplicación iOS hecha con Swift, UIKit y Storyboard. El proyecto está en la rama `ai-lab06`.

## ¿Qué puede hacer?

1. Recibir cinco datos de una venta: nombre del electrodoméstico, precio unitario en soles, cantidad, número de meses y tasa de interés mensual en porcentaje.
2. Calcular subtotal, IGV (18 %), monto base, intereses simples, total a pagar y cuota mensual.
3. Abrir una segunda pantalla con el nombre del producto, un resumen de la venta y los seis resultados formateados en soles.
4. Volver a la primera pantalla mediante la navegación de iOS.
5. Aceptar un punto o una coma como separador decimal en los campos numéricos y ocultar el teclado al tocar fuera de ellos.

## Cálculos

| Resultado | Fórmula |
| --- | --- |
| Subtotal | Precio unitario × cantidad |
| IGV | Subtotal × 0,18 |
| Base | Subtotal + IGV |
| Intereses | Base × (tasa mensual / 100) × meses |
| Total | Base + intereses |
| Cuota mensual | Total / meses, si meses es mayor que cero |

El interés usado es **simple**: se multiplica por el número de meses. No se calcula interés compuesto ni se genera un cronograma de pagos.

**Ejemplo:** con precio S/ 600, cantidad 2, 12 meses y tasa mensual de 5 %, el subtotal es S/ 1 200, el IGV es S/ 216, la base es S/ 1 416, los intereses son S/ 849,60, el total es S/ 2 265,60 y la cuota mensual es S/ 188,80.

## Comportamiento actual de las entradas

- Si un campo numérico está vacío o no se puede convertir en número, el código usa `0` para ese campo.
- Si los meses son `0`, la cuota queda en `0` para evitar una división entre cero.
- La aplicación no comprueba que precio, cantidad, meses o tasa sean positivos. Tampoco exige que cantidad y meses sean enteros. Por eso, un resultado visible no garantiza que los datos de entrada sean válidos para una venta real.
- Los resultados se muestran en pantalla; no se guardan ni se envían a ningún servicio.

## ¿Dónde está cada parte?

| Archivo | Función |
| --- | --- |
| `CalculadoraVenta/CalculadoraVenta.xcodeproj` | Archivo que se abre en Xcode para cargar el proyecto. |
| `CalculadoraVenta/CalculadoraVenta/Base.lproj/Main.storyboard` | Diseño visual de las pantallas **Nueva Venta** y **Resultado**, sus campos, etiquetas y el segue `showResultado`. |
| `CalculadoraVenta/CalculadoraVenta/NuevaVentaViewController.swift` | Lee las entradas, hace el cálculo y envía los resultados a la segunda pantalla con `prepare(for:sender:)`. |
| `CalculadoraVenta/CalculadoraVenta/VentaModel.swift` | Modelo con los seis valores calculados. |
| `CalculadoraVenta/CalculadoraVenta/ResultadoViewController.swift` | Muestra los resultados en soles. |

Las rutas de la tabla parten de la carpeta `semana 06` del repositorio.

## Cómo abrirlo en una Mac

1. Instala y abre **Xcode** en la Mac. iOS es el sistema del iPhone; el programa Xcode se usa en **macOS**.
2. En GitHub, cambia el selector de rama de `main` a **`ai-lab06`**. Después pulsa **Code → Download ZIP** y descomprime el archivo descargado.
3. En Finder, entra en `semana 06/CalculadoraVenta/` y abre **`CalculadoraVenta.xcodeproj`** con Xcode. No abras `project.pbxproj` por separado.
4. Para ver el diseño de las pantallas, abre `CalculadoraVenta/Base.lproj/Main.storyboard` desde el navegador de archivos de Xcode. Para leer la lógica, abre los tres archivos Swift de la tabla anterior.
5. Para usar la app, selecciona el esquema **CalculadoraVenta** y un simulador de iPhone en la barra superior de Xcode. Pulsa **▶ Run**. El proyecto declara iOS **26.2** como versión mínima, por lo que necesitas una instalación de Xcode y un simulador compatibles con esa versión o posterior.

La calculadora existe en la rama `ai-lab06`. Los proyectos manuales `Semana06` y `Semana06_02` están en `main`; `Semana06_02` es un formulario de cliente, no otra calculadora.
