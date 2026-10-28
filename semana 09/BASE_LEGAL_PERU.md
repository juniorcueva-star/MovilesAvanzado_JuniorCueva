# Laboratorio 9: reglas peruanas y alcance

Investigación: 27 de octubre de 2026. Proyecto académico para el **régimen laboral general de la actividad privada**, trabajador en planilla y remuneración fija. No corresponde aplicar estas mismas reglas automáticamente a CAS, REMYPE o recibos por honorarios.

## 1. CTS

La remuneración computable incorpora un sexto de la gratificación ordinaria **efectivamente percibida en el semestre correspondiente**. Se ingresa el monto completo de esa gratificación; el programa lo divide entre seis una sola vez.

```
base CTS = remuneración mensual computable + gratificación recibida / 6
CTS = base CTS × (meses computables / 12 + días computables / 360)
```

Los periodos de CTS son noviembre–abril y mayo–octubre. No coinciden con enero–junio y julio–diciembre, usados para gratificaciones. La bonificación extraordinaria del 9% o 6.75% no integra la base de CTS. Las vacaciones remuneradas cuentan como tiempo computable; las ausencias sin goce requieren tratamiento distinto.

Fuentes: [guía de CTS del MTPE](https://cdn.www.gob.pe/uploads/document/file/8050277/6757898-guia_compensacion_tiempo_servicios.pdf?v=1747167296), D. S. 001-97-TR, artículos 8, 18 y 21; [Ley 30334](https://www.leyes.congreso.gob.pe/Documentos/Leyes/30334.pdf).

El derecho a CTS exige, en el régimen considerado, al menos cuatro horas diarias en promedio y un mes de servicios. Para una semana de cinco días se necesitan al menos 20 horas; para seis días, 24. Por eso **23 horas semanales no garantizan por sí solas derecho a CTS**. El módulo de CTS solicita confirmar el requisito de jornada y usa entre uno y seis meses computables.

Fuente: [MTPE, jornada mínima y CTS, abril de 2026](https://www.gob.pe/institucion/mtpe/noticias/1383535-mtpe-trabajadores-del-regimen-privado-que-laboren-4-horas-diarias-en-promedio-tienen-derecho-a-cts).

## 2. Gratificación

En el caso de remuneración fija sin ausencias no computables:

```
gratificación = remuneración computable × meses calendario completos / 6
bonificación extraordinaria = gratificación × 9% (EsSalud)
bonificación extraordinaria = gratificación × 6.75% (EPS)
importe antes de quinta categoría = gratificación + bonificación
```

Se consideran hasta seis meses completos. No se prorratea un mes incompleto de ingreso como si fuera un mes completo. Las vacaciones pagadas son tiempo computable. La gratificación legal y su bonificación no están sujetas a AFP/ONP; sí pueden generar renta de quinta categoría. El resultado de este módulo se identifica como importe **antes de quinta categoría**, pues conocer únicamente sueldo y meses no basta para determinar esa retención.

Fuentes: [Sunafil, gratificaciones y bonificación, julio de 2026](https://www.gob.pe/institucion/sunafil/noticias/1413450-mas-de-9-000-denuncias-recibio-la-sunafil-por-falta-de-pago-de-la-gratificacion), [Ley 27735](https://www.leyes.congreso.gob.pe/Documentos/Leyes/27735.pdf), [Ley 30334](https://www.leyes.congreso.gob.pe/Documentos/Leyes/30334.pdf).

## 3. Pago de instructores: condiciones de la práctica

El pago de S/ 50 por hora, el máximo de 23 horas semanales y el factor de cuatro semanas son condiciones indicadas por el docente, **no una tarifa ni una jornada máxima general fijadas por la legislación peruana**.

```
sueldo bruto mensual = horas semanales × 50 × 4
```

Caso máximo: 23 × 50 × 4 = S/ 4,600.00. El escenario del laboratorio mantiene ese sueldo todo 2026, con un empleador, dos gratificaciones completas, cobertura EsSalud y sin asignación familiar, comisiones, otros ingresos o ausencias sin goce. Las vacaciones pagadas no representan un sueldo adicional ni eliminan el sueldo del mes.

## 4. ONP, AFP y EsSalud

- **ONP:** 13% de la remuneración, retenido al trabajador. [SUNAT](https://orientacion.sunat.gob.pe/08-tasa-y-calculo-del-aporte-al-snp-onp).
- **AFP:** 10% para el fondo, más prima de seguro y comisión cuando corresponde. En comisión por saldo, la comisión anual se cobra del fondo; no se suma como un porcentaje mensual del sueldo. [SBS, aportes](https://www.sbs.gob.pe/sistema-privado-de-pensiones/deberes-y-derechos-del-afiliado) y [comisiones](https://www.sbs.gob.pe/usuarios/aprende-con-la-sbs/comisiones-y-primas).
- **EsSalud:** aporte del empleador de 9%, con base mínima asegurable de una RMV para el mes completo del ejemplo. No reduce el sueldo neto. [SUNAT](https://orientacion.sunat.gob.pe/07-tasa-y-calculo-del-aporte-al-essalud), [EsSalud](https://www.gob.pe/218-aportes).

Tasas AFP consultadas para **octubre de 2026**:

| AFP | Aporte | Seguro | Comisión sobre sueldo | Comisión anual sobre saldo |
|---|---:|---:|---:|---:|
| Habitat | 10% | 1.37% | 1.47% | 1.25% |
| Integra | 10% | 1.37% | 1.55% | 0.78% |
| Prima | 10% | 1.37% | 1.60% | 1.25% |
| Profuturo | 10% | 1.37% | 1.69% | 0.68% |

El seguro tiene un tope de remuneración asegurable de S/ 12,732.70 para octubre–diciembre de 2026. El sueldo máximo de esta práctica, S/ 4,600, está por debajo. La aplicación utiliza estas tasas de referencia para el descuento AFP; el selector de mes se utiliza para la simulación de quinta categoría y los pagos de gratificación.

Fuentes: [tabla SBS, octubre de 2026](https://www.sbs.gob.pe/app/spp/empleadores/comisiones_spp/Paginas/comision_prima.aspx), [AFP Integra](https://www.afpintegra.pe/cliente/comisiones).

La RMV del escenario es S/ 1,130 de enero a septiembre y S/ 1,230 desde octubre de 2026, según el [D. S. 015-2026-TR](https://busquedas.elperuano.pe/dispositivo/EX/2559163-1?trk=article-ssr-frontend-pulse_little-text-block). Se usa para el piso de EsSalud, no para reemplazar la fórmula salarial del enunciado.

## 5. Renta de quinta categoría

La UIT 2026 es S/ 5,500; siete UIT equivalen a S/ 38,500. Se proyectan ingresos gravados, incluyendo gratificaciones, y se aplican tasas acumulativas **al exceso de siete UIT**, no al sueldo completo. No se deduce AFP/ONP para obtener esta base tributaria.

| Tramo de renta neta anual | Tasa |
|---|---:|
| Primeras 5 UIT | 8% |
| Siguientes 15 UIT | 14% |
| Siguientes 15 UIT | 17% |
| Siguientes 10 UIT | 20% |
| Exceso de 45 UIT | 30% |

Fuentes: [UIT, SUNAT](https://www.sunat.gob.pe/indicestasas/uit.html), [cálculo de quinta categoría, SUNAT](https://personas.sunat.gob.pe/trabajador-dependiente/declaracion-pago).

La retención mensual no consiste siempre en dividir el impuesto anual entre doce. El artículo 40 del Reglamento de la Ley del Impuesto a la Renta establece divisores y retenciones anteriores:

| Mes del cálculo | Retenciones que se restan | Divisor |
|---|---|---:|
| Enero–marzo | Ninguna | 12 |
| Abril | Enero–marzo | 9 |
| Mayo–julio | Enero–abril | 8 |
| Agosto | Enero–julio | 5 |
| Septiembre–noviembre | Enero–agosto | 4 |
| Diciembre | Enero–noviembre | 1 |

Para el caso de sueldo constante, el programa reconstruirá esas retenciones desde enero. En julio y diciembre agregará el impuesto adicional sobre la bonificación extraordinaria, conforme al inciso e). Una bonificación ya pagada pasa a los ingresos acumulados de los meses siguientes. Se redondea cada retención a céntimos; diciembre ajusta el total anual.

Fuente: [Reglamento de la Ley del IR, artículo 40, SUNAT](https://www.sunat.gob.pe/legislacion/renta/regla/cap10.pdf). La bonificación extraordinaria es ingreso gravado: [material tributario SUNAT](https://iat.sunat.gob.pe/sites/default/files/documentos/2023/09/archivos/contatrib.pdf).

## 6. Vacaciones y límites del proyecto

El saldo vacacional se muestra por separado: días adquiridos menos días gozados. En el caso general, los 30 días anuales requieren cumplir el año y el récord correspondiente. No se genera automáticamente un pago extra por conservar días pendientes.

Fuente: [Sunafil, descanso vacacional](https://www.gob.pe/institucion/sunafil/noticias/1092181).

La app no es una liquidación universal: no cubre ingresos variables, varios empleadores, cese, indemnización vacacional, regímenes especiales, deducciones personales anuales de hasta 3 UIT ni ausencias no computables en la gratificación. En CTS se deben ingresar los meses y días ya computables. Los datos de remuneración computable deben incluir los conceptos aplicables a cada caso. Estos supuestos se mostrarán también en la interfaz.

## 7. Organización prevista y commits

1. Documentar investigación y reglas (este documento).
2. Crear proyecto SwiftUI con CTS y gratificación.
3. Agregar pago de instructores, pensiones y quinta categoría.
4. Verificar cálculos y preparar explicación y ejemplos.

`ContentView.swift` contendrá las pantallas y las funciones de cálculo, con nombres en español y comentarios junto a las fórmulas. La app tendrá tres pestañas y controles nativos. La compilación de SwiftUI y la prueba visual final requieren Xcode en una Mac.
