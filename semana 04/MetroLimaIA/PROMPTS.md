# Prompts — Semana 04: Sistema de consulta del Metro de Lima

## Docente: Juan Leon — Tecsup
## Desarrollado por: Junior Cueva
## Herramienta: Claude

## Prompt 

CONTEXTO: Estudiante de Programacion en Moviles Avanzado, semana 4. El tema es POO en Swift: clases, objetos, init, self, herencia con override, encapsulacion y extensiones. Ya tengo una version manual del sistema con tres clases (Estacion, Linea, Conexion) y una clase gestora SistemaMetro, con datos de 101 estaciones de las lineas 1 a 4 del Metro de Lima y sus 6 conexiones.

TAREA: Mejorar esa version agregando busqueda parcial de estaciones, calculo de ruta entre dos estaciones que detecte si hace falta transbordo, un reporte de estadisticas de la red, y una subclase que use herencia con override para diferenciar las estaciones operativas de las que aun no funcionan.

RESTRICCIONES: Solo temas de las semanas 1 a 4. Sin struct, sin closures como map o filter, sin librerias externas. El codigo debe llevar un comentario en cada linea explicando su funcion.

FORMATO: Un archivo main.swift completo, listo para compilar con swiftc en Windows.

EJEMPLO: La herencia esperada era del tipo:
class EstacionOperativa: Estacion { override func estaOperativa() -> Bool { return true } }

