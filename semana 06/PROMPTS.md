# PROMPTS.md - Semana 06 (rama ai-lab06)

Ejercicio 4: Calculadora de Venta a Plazos de Electrodoméstico

Herramienta de IA usada: Claude

## Prompt (estructura CTRFE)

### Contexto

Estoy en el curso Programación en Móviles Avanzado (Tecsup, 5to ciclo). Trabajo en Xcode con UIKit y Storyboard. Hasta la semana 6 hemos visto: clases en Swift, UINavigationController, segues, prepare(for:sender:), IBOutlet e IBAction. En el Ejercicio 2 pasé datos entre dos pantallas usando una clase propia llamada ClienteModel que hereda de NSObject.

### Tarea

Crea una app "Calculadora de Venta a Plazos de Electrodoméstico" con dos pantallas:

1. Define `class VentaModel: NSObject` con propiedades para las 6 salidas del cálculo (subtotal, igv, base, intereses, total, cuota), todas Double.
2. En la pantalla "Nueva Venta" (5 UITextField: electrodoméstico, precio unitario, cantidad, meses, interés mensual, y un botón "Calcular") implementa el cálculo completo y arma un VentaModel con los resultados.
3. Pasa el VentaModel a la pantalla "Resultado" con prepare(for:sender:), usando un segue Show con identifier `showResultado`.
4. En "Resultado" muestra cada valor formateado en soles con `String(format: "S/. %.2f", valor)`.

Fórmulas exactas:

```
subtotal  = precioUnitario x cantidad
igv       = subtotal x 0.18
base      = subtotal + igv
intereses = base x (tasaInteresMensual / 100) x meses
total     = base + intereses
cuota     = total / meses
```

### Restricciones

- Usa solo lo visto hasta la semana 6: clases, UINavigationController, prepare(for:sender:), IBOutlet/IBAction.
- Nada de Combine, Codable ni persistencia.
- Explica por qué usas class y no struct para VentaModel.

### Formato

Entrega el código separado por archivo (VentaModel.swift, NuevaVentaViewController.swift, ResultadoViewController.swift), con comentarios cortos en español, y la lista de outlets que debo conectar en el Storyboard.

### Ejemplo

Con precio unitario 1750, cantidad 2, 12 meses e interés mensual 1 % el resultado debe ser:

| Campo | Valor |
|---|---|
| Subtotal | S/. 3500.00 |
| IGV (18%) | S/. 630.00 |
| Base | S/. 4130.00 |
| Intereses | S/. 495.60 |
| Total | S/. 4625.60 |
| Cuota mensual | S/. 385.47 |

## Respuesta de la IA: ¿por qué class y no struct?

VentaModel se crea en "Nueva Venta" y se entrega a "Resultado" dentro de prepare(for:sender:). Al ser class es un tipo por referencia: las dos pantallas apuntan al mismo objeto y no se crea una copia. Además puede heredar de NSObject, igual que ClienteModel en el Ejercicio 2. Un struct no puede heredar de NSObject y se copia en cada asignación.

## Reflexión: qué hizo distinto la IA

- Validó los campos vacíos sin que se lo pidiera: si un campo está vacío o no es un número usa 0 (`Double(texto) ?? 0`) en lugar de dejar que la app se caiga.
- Evitó la división entre cero: si meses es 0 la cuota queda en 0.
- Aceptó la coma decimal (cambia "," por ".") porque el teclado en español escribe coma.
- Separó el cálculo en una función `calcularVenta()` y la conversión en `leerNumero(_:)`, en vez de poner todo dentro de prepare(for:sender:).
- No usó `guard let`; se quedó con `if` y el operador `??`, que es más parecido al patrón visto en clase.
- Respetó las restricciones: no usó Combine, Codable ni persistencia.
