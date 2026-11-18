# PROMPTS.md · Grupo B · Compras

Registro de las consultas a la IA (Claude) con el formato pedido en la guía.

## Consulta 1 · Construcción de la app

| Campo | Detalle |
| --- | --- |
| Contexto | Laboratorio 11 (Core Data y SwiftData), trabajo de la semana, Grupo B: caso Compras con SwiftUI + SwiftData, 4 entidades, 9 pantallas y roles Comprador y Supervisor. Se adjuntó la guía en PDF y el [expediente](EXPEDIENTE.md). |
| Tarea | Crear el proyecto en `semana 14`, implementar login, registro, sesión, pestañas por rol, las 9 pantallas y las reglas (IGV como crédito fiscal, aprobación desde S/ 5,000, costo promedio ponderado, contado o crédito 30 días, cuentas por pagar y resumen). |
| Restricciones | Solo la parte B. Seguir los nombres de clases y propiedades de la guía. Sin paquetes externos. Usuario único sin distinguir mayúsculas, clave mínima de 6, mensaje genérico en el login. Commits en español al terminar cada etapa. |
| Formato esperado | Proyecto de Xcode listo para abrir, código comentado, pruebas XCTest con los 9 casos y un workflow que compile en GitHub. |
| Qué hicimos con la respuesta | Revisamos que los resultados de las pruebas coincidan con los números calculados a mano en el expediente (1,416.00 · 112.00 · 7,080.00 · 115.56). Pendiente: probar cada caso en el simulador de la Mac y ajustar los textos de las pantallas si el docente lo pide. |

## Consulta 2 · Valor agregado

| Campo | Detalle |
| --- | --- |
| Contexto | La app ya cumplía el caso B. El docente permitió agregar mejoras como valor agregado. |
| Tarea | Agregar: historial de todas las compras para el supervisor, número de pendientes en la pestaña Aprobar, validación de RUC, alerta de stock bajo y botón para ver u ocultar la clave. Documentarlo en [REQUERIMIENTOS.md](REQUERIMIENTOS.md). |
| Restricciones | Sin paquetes externos, sin cambiar las reglas del caso, filtros con `#Predicate` y código fácil de explicar. Documento corto. |
| Formato esperado | Cambios en los archivos existentes, dos vistas nuevas (`TodasComprasView`, `CampoClave`) y pruebas XCTest para las reglas nuevas. |
| Qué hicimos con la respuesta | Elegimos 5 de 7 mejoras propuestas (dejamos el hash de la clave para la próxima clase). Revisamos las pruebas nuevas (RUC, stock bajo, historial). Falta probar cada mejora en el simulador de la Mac. |
