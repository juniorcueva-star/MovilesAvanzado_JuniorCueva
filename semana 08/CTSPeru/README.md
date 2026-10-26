# Laboratorio semana 8: CTS y vacaciones

## Entregables

- `CTSPeru.xcodeproj`: aplicación iPhone desarrollada en SwiftUI.
- `CTS_Peru_Calculo_y_Vacaciones.xlsx`: cálculo explicado y comparación de vacaciones gozadas y no gozadas.
- [`campos.md`](campos.md): explicación de cada campo y del resultado.
- [`requeriemientos.md`](requeriemientos.md): funciones y alcance de la aplicación.

Abre `CTSPeru.xcodeproj` en Xcode, selecciona el esquema **CTSPeru** y ejecuta en un simulador o iPhone. El proyecto fue generado con XcodeGen; `project.yml` permite regenerarlo si se agregan archivos Swift.

Ingresa los datos y pulsa **Calcular CTS**. El resultado se muestra en una sección blanca; al cambiar un dato, pulsa el botón de nuevo para obtener el cálculo actualizado.

## Qué calcula

Para el régimen laboral privado general con remuneración fija, la aplicación y el Excel usan:

`CTS = (sueldo mensual computable + gratificación percibida en el semestre / 6) × (meses completos / 12 + días adicionales / 360)`

El usuario ingresa meses y días **computables** del semestre. Las vacaciones pagadas cuentan en ese tiempo; por eso tomar vacaciones no reduce la CTS. Los días adquiridos y gozados sirven para mostrar un saldo vacacional separado. Ausencias sin goce no se deben registrar como vacaciones pagadas.

Ejemplo: sueldo S/ 3,000, gratificación S/ 3,000, seis meses, cero días adicionales. Remuneración computable S/ 3,500 y CTS S/ 1,750. Con 30 días de vacaciones ya adquiridos, tomar 15 deja 15 pendientes; no tomarlos deja 30 pendientes. La CTS es S/ 1,750 en ambos casos.

## Alcance

Es un ejercicio académico de remuneración fija. No liquida gratificación trunca, vacaciones truncas o indemnización vacacional, ni contempla remuneraciones variables, asignación familiar u otros regímenes laborales. Para una liquidación real se revisan el régimen, la jornada, la fecha de ingreso, los conceptos remunerativos y los días computables. El descanso anual del régimen general es de 30 días calendario por año completo, sujeto al récord vacacional.

## Fuentes oficiales

- [TUO de la Ley de CTS, D. S. 001-97-TR](https://www.gob.pe/institucion/mtpe/informes-publicaciones/221736-texto-unico-ordenado-de-la-ley-de-compensacion-por-tiempo-de-servicios), arts. 8, 18 y 21.
- [Decreto Legislativo 713](https://www.leyes.congreso.gob.pe/Documentos/DecretosLegislativos/00713.pdf), vacaciones anuales.
- [Guía de CTS del MTPE](https://cdn.www.gob.pe/uploads/document/file/8050277/6757898-guia_compensacion_tiempo_servicios.pdf).
- [Guía de vacaciones del MTPE](https://cdn.www.gob.pe/uploads/document/file/296438/Vacaciones_-_Final.pdf).
