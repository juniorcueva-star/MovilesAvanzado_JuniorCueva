Requerimientos de la aplicación
Objetivo
Aplicación iOS desarrollada con SwiftUI para calcular beneficios laborales y pagos de instructores en Perú, bajo los supuestos incluidos en el código.
Requerimientos funcionales
1. Calculadora de CTS
- Ingresar remuneración, gratificación recibida, meses y días computables.
- Verificar el cumplimiento de la jornada mínima de 4 horas diarias.
- Calcular la CTS, su base y el desglose por meses y días.
- Mostrar los días de vacaciones pendientes a partir de los adquiridos y gozados.
2. Calculadora de gratificación
- Ingresar remuneración y meses calendario completos (0 a 6).
- Elegir cobertura EsSalud o EPS.
- Calcular gratificación legal, bonificación extraordinaria y total previo a quinta categoría.
3. Calculadora de pago de instructores
- Ingresar horas semanales (máximo 23) y seleccionar el mes.
- Elegir sistema de pensiones ONP o AFP, administradora y tipo de comisión.
- Calcular sueldo bruto, aportes, descuentos, impuesto de quinta categoría y sueldo neto.
- Mostrar gratificación y bonificación en julio y diciembre, cuando correspondan.
- Mostrar el aporte de EsSalud del empleador y el detalle de la retención tributaria.
Requerimientos generales
- Navegación entre tres pestañas: CTS, Gratificación e Instructores.
- Validación de datos numéricos y límites permitidos, con mensajes de error.
- Resultados expresados en soles (S/) y redondeados a dos decimales.
- Actualización de resultados al volver a calcular tras modificar datos.
- Interfaz con formularios y botones de cálculo.
Alcance: cálculos basados en remuneraciones fijas y en los supuestos definidos en el código; no cubre todos los casos laborales posibles.
