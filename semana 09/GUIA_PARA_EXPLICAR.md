# Cómo abrir y explicar Laboral Perú

## 1. Abrirlo en la Mac

Si todavía no tienes el repositorio, abre Terminal y ejecuta:

```bash
git clone https://github.com/juniorcueva-star/MovilesAvanzado_JuniorCueva.git
cd MovilesAvanzado_JuniorCueva
open "semana 09/LaboralPeru/LaboralPeru.xcodeproj"
```

Si ya lo tienes, entra a su carpeta y ejecuta `git switch main` y `git pull --ff-only`. Si tienes cambios sin guardar, revísalos antes de cambiar de rama o actualizar; no los borres.

En Xcode:

1. Selecciona **LaboralPeru** en la barra superior.
2. Elige un **iPhone Simulator** con iOS 17 o posterior. Si falta, instala el simulador que ofrece Xcode.
3. Pulsa el triángulo **Run**, o **⌘R**.
4. El iPhone mostrará tres pestañas: CTS, Gratificación e Instructores.
5. Para enseñar el código, abre `LaboralPeru → ContentView.swift` en la columna izquierda. No hay `Main.storyboard`: el diseño se escribe en SwiftUI.

## 2. Qué mostrar primero

### CTS

Ingresa sueldo **3000**, gratificación recibida **3000**, **6 meses** y **0 días**. Mantén activado el requisito de jornada. Pulsa **Calcular CTS**.

```
Sexto de gratificación = 3000 / 6 = 500
Base = 3000 + 500 = 3500
CTS = 3500 × 6 / 12 = S/ 1750.00
```

Cambia los días de vacaciones gozadas de 0 a 15. El saldo cambia de 30 a 15 días; la CTS no se reduce porque son vacaciones pagadas. Esos 30 días ya adquiridos son un supuesto del ejemplo, no días que nacen por escribir seis meses de CTS.

La gratificación ingresada corresponde al semestre de CTS: diciembre para noviembre–abril, o julio para mayo–octubre. Si no se recibió gratificación en ese semestre, se ingresa cero.

### Gratificación

Ingresa remuneración **3000**, **6 meses completos** y EPS desactivado:

```
Gratificación = 3000 × 6 / 6 = 3000
Bonificación = 3000 × 9% = 270
Importe antes de quinta categoría = S/ 3270.00
```

Con **3 meses** y **EPS activado**, sale gratificación **1500**, bonificación **101.25** y total **1601.25**. No llames a ese total «neto final»: todavía podría corresponder impuesto a la renta según los ingresos anuales.

### Instructores

Ingresa **23 horas**, selecciona **Octubre** y **ONP**:

| Concepto | Resultado |
|---|---:|
| Sueldo bruto: 23 × 50 × 4 | S/ 4600.00 |
| ONP: 13% | S/ 598.00 |
| Quinta categoría de octubre | S/ 172.66 |
| Neto a recibir | S/ 3829.34 |
| EsSalud del empleador | S/ 414.00 |

Con AFP Integra y comisión sobre sueldo, el aporte al fondo es **460**, seguro **63.02**, comisión **71.30** y neto **3833.02**. Si activas comisión sobre saldo, no se resta la comisión sobre sueldo: la comisión anual se cobra del fondo.

En julio, el ejemplo con ONP añade gratificación **4600** y bonificación **414**. La quinta categoría sube a **205.79** por el impuesto adicional de la bonificación. El total a recibir es **8810.21**. EsSalud permanece separado.

## 3. Dónde está cada cosa en ContentView.swift

| Si el profesor pregunta… | Busca con ⌘F… | Qué explicas |
|---|---|---|
| ¿Dónde hiciste la interfaz? | `pantallaCTS`, `pantallaGratificacion`, `pantallaInstructor` | Son las tres pantallas; usan Form, Section, TextField, Picker y Button. |
| ¿Dónde guardas lo que escribe el usuario? | `@State` | SwiftUI guarda esos valores y actualiza lo que se muestra. |
| ¿Dónde están las pestañas? | `TabView` | Permite cambiar entre los tres cálculos. |
| ¿Qué hace el botón? | `private func calcularCTS` | Lee los campos, llama al cálculo y guarda el resultado o el error. |
| ¿Dónde calculas CTS? | `static func calcularCTS` | Divide la gratificación entre seis, suma al sueldo y aplica meses/12 y días/360. |
| ¿Dónde calculas la gratificación? | `static func calcularGratificacion` | Multiplica remuneración por meses/6 y calcula la bonificación. |
| ¿Dónde calculas el bruto y las pensiones? | `static func calcularInstructor` | Horas × 50 × 4; luego ONP o AFP con seguro y comisión. |
| ¿Dónde calculas quinta categoría? | `calcularImpuestoAnual`, `calcularRetenciones` | Aplica siete UIT, tasas por tramos y el procedimiento mensual del artículo 40. |
| ¿Dónde evitas valores inválidos? | `guard`, `leerNumero` | Se rechazan campos vacíos, números no válidos y horas mayores a 23. |
| ¿Dónde das formato a soles? | `static func soles` | Usa la moneda PEN y la configuración regional de Perú. |

`Calculos` agrupa funciones que no dependen de los controles de pantalla. Está al final del mismo archivo. Los tipos `ResultadoCTS`, `ResultadoGratificacion` y `ResultadoInstructor` solamente guardan los resultados.

## 4. Preguntas que pueden hacerte

**¿Por qué no usaste simplemente AFP 10%?** Porque el 10% va al fondo; también hay seguro y, según el tipo de comisión, un cobro sobre el sueldo. Las tasas usadas están identificadas como octubre de 2026.

**¿EsSalud se descuenta al trabajador?** En este escenario lo aporta el empleador. Por eso lo muestro aparte y no lo resto del neto.

**¿AFP/ONP son quinta categoría?** No. Son aportes previsionales. Quinta categoría es impuesto a la renta.

**¿La gratificación es un sexto del sueldo?** Por seis meses completos equivale a una remuneración computable. Un sexto corresponde a cada mes completo; además, para CTS se incorpora un sexto de la gratificación recibida.

**¿Por qué la quinta categoría puede variar por mes?** Hay divisores legales distintos, retenciones anteriores y pagos adicionales. El programa simula desde enero con el mismo sueldo y ajusta diciembre. Las doce retenciones del ejemplo de S/ 4600 suman **S/ 2138.24**.

**¿Sirve para cualquier planilla?** Este proyecto cubre los supuestos indicados: régimen privado general y remuneración fija. No cubre variaciones salariales, varios empleadores, cese, regímenes especiales ni todas las situaciones de ausencias. En esos casos hay que ampliar los datos y reglas.

**¿Son obligatorias por ley las 23 horas y los S/50?** Son las condiciones del ejercicio. Tampoco cuatro semanas representan todos los meses reales.

**¿Con 23 horas siempre hay CTS?** Depende de la jornada: en una semana de cinco días se cumple el promedio mínimo; en una de seis días, 23/6 es menor que cuatro. El módulo de CTS pide confirmar ese requisito.

## 5. Cómo mostrar los commits

En GitHub abre `semana 09` y pulsa **History**. En Terminal puedes usar:

```bash
git log --oneline -- "semana 09"
```

Cada commit registra un avance real: investigación, CTS y gratificación, instructores y descuentos, pruebas y documentación. Para comparar un avance concreto: `git show CODIGO_DEL_COMMIT`.
