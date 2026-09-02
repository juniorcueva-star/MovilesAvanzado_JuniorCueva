# Prompts utilizados — Tienda 2 (con IA)

## Herramienta
Claude

## Prompt

CONTEXTO: Tengo una tienda en Swift que pide producto, precio y cantidad, calcula el monto total y permite elegir un plan de pago de 6, 12 o 24 meses con intereses de 20%, 40% y 60%. Muestra un cronograma con monto inicial, cuota y resta por pagar. Uso readLine() en un Playground.

TAREA: Agregar la opcion de pago adelantado. El usuario elige en que mes adelantar un monto extra, donde 0 es ningun adelanto. Mostrar el total de ese mes (cuota mas adelanto) y agregar una columna de fecha al cronograma.

RESTRICCIONES: Solo usar temas de la semana 2: variables, condicionales, switch, bucles e interpolacion. Sin arrays, funciones ni librerias de fechas.

FORMATO: Codigo dividido en 4 bloques para hacer un commit por cada uno.

EJEMPLO: if mes == mesAdelanto { pagoDelMes = pagoDelMes + montoAdelanto }

## En que nos ayudo

Resolvio como hacer que el cronograma termine antes cuando el adelanto liquida la deuda, usando un while con doble condicion en lugar de un for. Tambien agrego una validacion para que el ultimo pago no sea mayor al saldo restante.

## Diferencias con la tienda 1

| Tienda 1 | Tienda 2 |
|---|---|
| Sin pago adelantado | Permite adelantar en el mes que elija |
| Cronograma con for-in fijo | Cronograma con while, puede terminar antes |
| Sin columna de fecha | Muestra mes y anio de cada pago |
| Plan invalido daba 0% de interes | Plan invalido se corrige a 6 meses |