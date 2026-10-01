# Semana 6

Laboratorio 06 - ViewControllers, Navegación Modal y Segues (UIKit)

Alumno: Junior Cueva

## Contenido

| Carpeta | Ejercicio | Rama |
|---|---|---|
| Semana06 | Ejercicio 1 - Icono de la app, Navigation Controller y segue Show | main |
| Semana06_02 | Ejercicio 2 - Ventana modal con paso de datos (ClienteModel) | main |
| CalculadoraVenta | Ejercicio 4 - Calculadora de venta a plazos (IA) | ai-lab06 |

## Preguntas del procedimiento

### 16. ¿Qué cambio se nota en el diseño de la vista 1?

Al embeber la vista en un Navigation Controller aparece una barra de navegación (Navigation Bar) en la parte superior de la vista 1, con su Navigation Item para colocar título y botones. Además se crea una escena nueva llamada Navigation Controller, que pasa a ser el punto de entrada del storyboard y queda unida a la vista 1 con un segue de relación (root view controller).

### 17. ¿Para qué sirve un Navigation Controller?

Es un controlador contenedor que administra una pila (stack) de pantallas. Cuando se avanza a otra pantalla la apila (push) y cuando se regresa la quita (pop). Entrega de forma automática la barra superior con el título y el botón Back, por lo que sirve para la navegación jerárquica, donde se va de lo general al detalle y se puede volver atrás.

### 29. ¿Para qué sirven Show, Show Detail, Present Modally y Present As Popover?

| Opción | Para qué sirve |
|---|---|
| Show | Avanza a la siguiente pantalla. Si hay Navigation Controller la apila (push) y aparece el botón Back; si no lo hay, la presenta de forma modal. |
| Show Detail | Reemplaza el panel de detalle de un Split View Controller (lista a la izquierda, detalle a la derecha). En iPhone se comporta como un Show. |
| Present Modally | Presenta la pantalla encima de la actual, interrumpiendo el flujo. No hay botón Back: se cierra con dismiss. |
| Present As Popover | Muestra la pantalla como una burbuja flotante anclada a un botón. Tiene sentido en iPad; en iPhone se adapta y se ve como una hoja modal. |

## Conclusiones

1. **¿Cuándo conviene Show y cuándo Present Modally?** Show conviene cuando la pantalla nueva es el siguiente nivel de la misma información y el usuario necesita volver atrás, por ejemplo en una app de tienda al pasar de la lista de productos al detalle de un producto. Present Modally conviene para una tarea puntual que interrumpe el flujo y que se termina o se cancela, por ejemplo redactar un correo nuevo en Mail, iniciar sesión o confirmar los datos ingresados como en el Ejercicio 2.

2. **Show Detail y Present As Popover.** Show Detail sirve para mostrar contenido en el panel de detalle de un Split View Controller y Present As Popover para mostrar opciones en una burbuja anclada a un control. Los dos tienen sentido en iPad (o pantallas anchas), donde hay espacio para dos columnas o para una ventana flotante. En iPhone el sistema los adapta y terminan viéndose como un Show o una hoja modal.

3. **¿Qué pasaría si ClienteModel o VentaModel fueran struct?** El paso de datos hacia adelante no se rompería: la segunda pantalla recibiría una copia con los mismos valores y los mostraría igual. Lo que cambia es que un struct es un tipo por valor: no puede heredar de NSObject, no necesita escribir los inicializadores a mano y cada asignación crea una copia. Por eso, si la pantalla 2 modificara el objeto, la pantalla 1 no vería el cambio. Con class ambas pantallas comparten la misma referencia.

4. **Diferencia entre el Ejercicio 2 (manual) y el Ejercicio 4 (con IA).** El Ejercicio 2 toma más tiempo porque cada paso se hace a mano en Interface Builder (crear clases, enlazar outlets, poner el Storyboard ID), pero deja claro qué hace cada conexión y dónde falla cuando algo se olvida. Con IA el Ejercicio 4 sale mucho más rápido y con detalles extra, pero hay que leer el código generado para entenderlo y comprobar que respeta las restricciones del prompt.
