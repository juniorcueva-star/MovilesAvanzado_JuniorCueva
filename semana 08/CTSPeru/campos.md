# Campos de la calculadora CTS Perú

La aplicación es un ejercicio académico para el régimen laboral privado general con remuneración fija. Los importes se ingresan en soles. El resultado aparece al pulsar **Calcular CTS** y se borra al modificar cualquier dato para evitar mostrar un cálculo anterior como si estuviera actualizado.

## Datos de remuneración

| Campo | Qué debes ingresar |
| --- | --- |
| **Sueldo mensual (S/)** | La remuneración mensual computable para el semestre. Ingresa un importe igual o mayor que cero; por ejemplo, `3000`. |
| **Gratificación del semestre (S/)** | La gratificación percibida en el semestre correspondiente. La calculadora incorpora un sexto de este importe a la remuneración computable de CTS. Si no hubo gratificación computable, ingresa `0`. |

Puedes usar punto o coma como separador decimal. La app no acepta importes negativos ni texto no numérico.

## Tiempo computable

| Campo | Qué debes ingresar |
| --- | --- |
| **Meses completos** | Meses computables trabajados en el semestre: de 1 a 6. Si marcas 6 meses, los días adicionales quedan en 0. |
| **Días adicionales** | Días computables que exceden los meses completos: de 0 a 29. La app los suma proporcionalmente al cálculo de CTS. |

Ingresa el tiempo **ya depurado**: las vacaciones pagadas cuentan como tiempo computable, mientras que las ausencias sin goce deben excluirse antes de llenar estos campos. La app no calcula automáticamente las ausencias a partir de fechas.

## Vacaciones

| Campo | Qué debes ingresar |
| --- | --- |
| **Días adquiridos** | Días de descanso vacacional a considerar para el saldo, entre 0 y 30. Debes determinar este dato según el periodo y el récord vacacional; la app no lo genera automáticamente. |
| **Salió de vacaciones pagadas** | Activa el interruptor cuando se gozaron vacaciones pagadas. Al activarlo aparece el campo de días gozados. |
| **Días gozados** | Número de días de vacaciones pagadas ya utilizados, entre 0 y los días adquiridos. Si el interruptor está apagado, el cálculo usa 0 días gozados. |

Los días gozados reducen el **saldo de vacaciones pendientes**. No reducen la CTS calculada.

## Botón y resultado

**Calcular CTS** valida los datos y muestra una sección blanca con la remuneración computable, la CTS proporcional a meses, la CTS proporcional a días, la CTS total estimada y los días de vacaciones pendientes. Si un importe no es válido, aparece un mensaje para corregirlo. La fórmula y las fuentes legales están en [README.md](README.md); no se muestran al pie de la app.
