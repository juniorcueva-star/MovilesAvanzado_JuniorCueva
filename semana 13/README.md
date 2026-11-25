# Semana 13 - Consumir API desde una aplicación

**Curso:** Programación de Móviles Avanzados
**Alumno:** Junior Cueva Fabian

API utilizada: `https://jsonplaceholder.typicode.com/users`

Los tres proyectos usan la arquitectura **MVVM** con las carpetas `Models`, `View` y `ViewModels`.

| Proyecto | Actividad | Contenido |
|---|---|---|
| `Semana13_API` | Actividad 01 | GET de usuarios y filtro de búsqueda por nombre |
| `Semana13_MetodosAPI` | Actividad 02 | GET, POST, PUT y DELETE con `URLSession.shared.dataTask` |
| `Semana13_AsyncAwait` | Actividad 03 | Los mismos métodos con `async/await`, `URLSession.shared.data` y `Task` |

Para abrir cada proyecto: doble clic en el archivo `.xcodeproj` de su carpeta, elegir un simulador de iPhone y ejecutar con `Cmd + R`.

---

## Actividad 01

**¿Cuál es la función del `@Published`?**

`@Published` marca una propiedad de un `ObservableObject` para que avise cada vez que su valor cambia. La vista que observa al ViewModel (con `@StateObject` u `@ObservedObject`) se vuelve a dibujar automáticamente. Por eso, cuando llegan los usuarios de la API o cuando se escribe en el buscador (`searchText`), la lista se actualiza sola.

**Explique brevemente qué se realiza dentro de `filteredUsers`.**

Es una propiedad calculada que devuelve la lista que se muestra en pantalla. Si `searchText` está vacío devuelve todos los usuarios. Si tiene texto, usa `filter` para quedarse solo con los usuarios cuyo nombre contiene ese texto. Antes de comparar pasa ambos textos a minúsculas con `lowercased()`, así la búsqueda no distingue mayúsculas de minúsculas.

---

## Actividad 02

**¿Cuál es la finalidad de la función `resume()`?**

`dataTask` solo crea la tarea de red y la deja suspendida. `resume()` la inicia para que la petición se envíe al servidor. Si no se llama, la petición nunca se ejecuta.

**¿Qué función cumple `DispatchQueue`?**

Administra en qué hilo se ejecuta el código. La respuesta de `URLSession` llega en un hilo secundario, y la interfaz solo se puede modificar desde el hilo principal. `DispatchQueue.main.async { ... }` envía la actualización de `users` al hilo principal para que la vista se refresque sin errores.

**¿Qué función cumple la clase `JSONDecoder()`?**

Convierte los datos JSON que devuelve la API en objetos de Swift. Por ejemplo, `decode([User].self, from: data)` crea un arreglo de `User`. Funciona porque `User` cumple con `Codable`. Su contraparte es `JSONEncoder`, que convierte un `User` en JSON para enviarlo en el cuerpo de un POST o un PUT.

**`@State private var editingUser: User? = nil`**

Es un estado local de la vista que guarda el usuario que se está editando. Si vale `nil`, el formulario se abre para crear un usuario nuevo. Si tiene un usuario, el formulario se abre con sus datos para editarlo.

**`@StateObject private var viewModel = UserViewModel()`**

Crea el ViewModel una sola vez y lo mantiene vivo mientras exista la vista, aunque esta se vuelva a dibujar. La vista observa sus propiedades `@Published` para actualizarse.

**`.swipeActions`**

Agrega botones que aparecen al deslizar una fila de la lista hacia la izquierda. Aquí se usan "Eliminar" (rojo, con `role: .destructive`) y "Editar" (azul).

**`.sheet(isPresented: $showingForm)`**

Muestra una hoja modal que sube desde abajo cuando `showingForm` es `true`. Dentro se presenta `UserFormView` en modo edición o en modo nuevo. Al guardar, el formulario se cierra y `showingForm` vuelve a `false`.

---

## Actividad 03

**Diferencia entre `URLSession.shared.data` y `URLSession.shared.dataTask`**

`dataTask` usa un *closure* (callback): se crea la tarea, se llama a `resume()` y la respuesta llega después dentro del closure. Luego hay que volver al hilo principal con `DispatchQueue.main.async`.

`data(from:)` y `data(for:)` usan `async/await`: devuelven directamente `(Data, URLResponse)`, no necesitan `resume()` y los errores se manejan con `try`/`catch`. El código queda lineal, más corto y más fácil de leer.

**¿Para qué sirve la palabra reservada `await`?**

Indica que se espera el resultado de una función asíncrona. La función se suspende en ese punto sin bloquear el hilo y continúa cuando llega el resultado, por ejemplo la respuesta del servidor.

**¿Para qué sirve la estructura `Task`?**

Crea un contexto asíncrono desde código que no es asíncrono. Las acciones de un botón o de `.onAppear` son síncronas, así que para llamar a una función `async` se envuelve en `Task { await ... }`.

---

## Conclusiones

- Se consumió una API REST desde SwiftUI con `URLSession` y se convirtió el JSON en modelos de Swift con `Codable`, `JSONDecoder` y `JSONEncoder`.
- La arquitectura MVVM separa el modelo, la lógica de red (ViewModel) y la interfaz (View). Gracias a `ObservableObject` y `@Published`, la vista se actualiza sola cuando cambian los datos.
- Se implementaron los métodos GET, POST, PUT y DELETE. JSONPlaceholder es una API de prueba que no guarda los cambios, por eso la lista se actualiza localmente después de cada petición.
- `async/await` con `URLSession.shared.data` produce un código más claro que `dataTask` con closures: no hace falta `resume()` ni `DispatchQueue`, y los errores se controlan con `do`/`catch`.
