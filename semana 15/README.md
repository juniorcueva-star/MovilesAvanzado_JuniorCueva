# Semana 15 - Autenticación con Firebase (Laboratorio 14)

**Curso:** Programación de Móviles Avanzados
**Alumno:** Junior Cueva Fabian

Proyecto: `Lab14IntroFirebase` (SwiftUI)
Bundle Identifier: `pe.edu.tecsup.dma.Lab14IntroFirebase`

| Archivo | Función |
|---|---|
| `Lab14IntroFirebaseApp.swift` | Inicia la app y llama a `FirebaseApp.configure()` |
| `ContentView.swift` | Muestra `AuthView` |
| `AuthView.swift` | Acceso con Google o con email y contraseña (Sign Up / Sign In) usando FirebaseAuth |
| `HomeView.swift` | Lista de chats: perfil, chat general y chats privados con búsqueda |
| `DatabaseService.swift` | Guarda y escucha en tiempo real los mensajes del chat general en Cloud Firestore |
| `MessagesView.swift` | Chat general con los mensajes de todos los usuarios |
| `ChatService.swift` | Perfiles de usuario, conversaciones privadas y sus mensajes en Firestore |
| `PrivateChatView.swift` | Conversación privada entre dos usuarios |
| `ChatComponents.swift` | Lista de mensajes, burbujas, separadores por día y barra de envío reutilizables |
| `ChatModels.swift` | Modelos `AppUser`, `ChatSummary` y rutas de navegación |
| `Theme.swift` | Colores, fondo, avatares y campos reutilizables del diseño |

---

## Cómo ejecutarlo

1. Crear el proyecto `App01-Lab14` en la [consola de Firebase](https://console.firebase.google.com).
2. En **Authentication > Sign-in method** activar **Email/Password** y **Google**.
3. En **Firestore Database > Create database** elegir la ubicación `nam5` y **Start in test mode**.
4. Agregar una app iOS con el bundle `pe.edu.tecsup.dma.Lab14IntroFirebase` y descargar `GoogleService-Info.plist`.
5. Copiar `GoogleService-Info.plist` dentro de la carpeta `Lab14IntroFirebase/` (junto a `ContentView.swift`).
6. Abrir `Lab14IntroFirebase.xcodeproj`, esperar a que Xcode descargue los paquetes de Firebase y ejecutar con `Cmd + R`.

> El repositorio ya incluye `GoogleService-Info.plist` del proyecto `App01-Lab14`, así que basta con clonar, abrir el proyecto y ejecutar (los pasos 1 al 5 ya están hechos).

Paquetes usados (Swift Package Manager):
- `https://github.com/firebase/firebase-ios-sdk`: `FirebaseAuth`, `FirebaseCore`, `FirebaseDatabase` y `FirebaseFirestore`.
- `https://github.com/google/GoogleSignIn-iOS`: `GoogleSignIn` (botón "Continue with Google").

Estructura en Cloud Firestore:

| Colección | Contenido |
|---|---|
| `messages` | Mensajes del chat general |
| `users` | Perfil de cada usuario (uid, email, nombre y foto) |
| `chats` | Una conversación privada por pareja de usuarios (participantes y último mensaje) |
| `chats/{id}/messages` | Mensajes de esa conversación privada |

---

## Actividad 01: Autenticación con Firebase

**Indicar para qué sirve cada uno de los paquetes**

- **FirebaseCore:** es la base de todos los SDK de Firebase. Lee `GoogleService-Info.plist`, inicializa la conexión con el proyecto (`FirebaseApp.configure()`) y comparte la configuración con los demás módulos.
- **FirebaseAuth:** gestiona la autenticación de usuarios: registro, inicio y cierre de sesión con email y contraseña (y otros proveedores como Google o Apple), el usuario actual y los cambios de sesión.
- **FirebaseDatabase:** cliente de **Realtime Database**, una base de datos NoSQL en forma de un gran árbol JSON que sincroniza los datos en tiempo real entre los dispositivos.
- **FirebaseFirestore:** cliente de **Cloud Firestore**, una base de datos NoSQL organizada en colecciones y documentos, con consultas más potentes, escucha en tiempo real y soporte sin conexión. Es la que usa este proyecto para guardar los mensajes.

**¿Cuál es la finalidad de `FirebaseApp.configure()`?**

Inicializa Firebase en la app. Lee la configuración de `GoogleService-Info.plist` (id del proyecto, claves de API, bundle id) y crea la instancia por defecto de `FirebaseApp` que usan `Auth.auth()` y `Firestore.firestore()`. Se llama una sola vez al iniciar la app, en el `init()` de `Lab14IntroFirebaseApp`, antes de usar cualquier servicio de Firebase. Si no se llama, la app se cierra con un error al usar Auth o Firestore.

**Detallar los métodos principales de `Auth.auth()` usados en `AuthView.swift`**

- `Auth.auth()`: devuelve la instancia de autenticación asociada a la app de Firebase configurada.
- `createUser(withEmail:password:completion:)`: registra un usuario nuevo con email y contraseña (mínimo 6 caracteres). Si todo sale bien, el usuario queda con la sesión iniciada; si falla (email inválido o ya registrado), devuelve un error.
- `signIn(withEmail:password:completion:)`: inicia sesión con un usuario ya registrado. Devuelve un `AuthDataResult` con el usuario o un error si los datos son incorrectos.
- `signOut()`: cierra la sesión del usuario actual. Es una función que puede lanzar errores, por eso se usa con `try` dentro de `do/catch`.
- `addStateDidChangeListener(_:)`: registra un oyente que se ejecuta cada vez que cambia el estado de la sesión (al iniciar la app, al entrar o al salir). Devuelve un `AuthStateDidChangeListenerHandle`. Se usa para actualizar `isSignedIn` automáticamente.
- `signIn(with:completion:)`: inicia sesión con una credencial de otro proveedor; aquí con `GoogleAuthProvider.credential(withIDToken:accessToken:)` después de elegir la cuenta de Google.
- `sendPasswordReset(withEmail:completion:)`: envía al correo del usuario un enlace para crear una nueva contraseña (botón "Forgot password?").
- `currentUser`: el usuario que tiene la sesión iniciada (o `nil`). Se usa en `DatabaseService` y `MessagesView` para obtener su email.

---

## Actividad 02: Base de datos en tiempo real

**¿Cuál es la ventaja de usar Firebase Database?**

- **Tiempo real:** con `addSnapshotListener` los cambios llegan solos a todos los dispositivos conectados, sin recargar ni programar un servidor. Un mensaje enviado aparece al instante en los demás usuarios.
- **Sin servidor propio:** Firebase aloja la base de datos y escala automáticamente; no hay que crear ni mantener un backend.
- **Integración con Authentication:** se sabe qué usuario guarda cada dato y se pueden escribir reglas de seguridad según el usuario.
- **Soporte sin conexión:** los datos se guardan en caché y se sincronizan cuando vuelve la conexión.
- **Fácil de usar desde Swift:** con `Codable` se guarda y se lee un objeto (`setData(from:)` y `data(as:)`) sin convertirlo a mano.

**Mencionar 3 servicios adicionales de Firebase que se podrían usar en el proyecto**

1. **Cloud Messaging (FCM):** enviar notificaciones push cuando llega un mensaje nuevo.
2. **Cloud Storage:** subir y compartir imágenes o archivos dentro del chat, o la foto de perfil del usuario.
3. **Crashlytics:** registrar los errores y cierres inesperados de la app para corregirlos.

Otros que también servirían: Analytics (uso de la app), Cloud Functions (lógica en el servidor, por ejemplo moderar mensajes) y Remote Config (cambiar textos o colores sin publicar una nueva versión).

---

## Requerimientos (qué hace la app)

**Requerimientos del laboratorio**
- Registrarse con email y contraseña (mínimo 6 caracteres) e iniciar sesión.
- Cerrar sesión.
- Enviar mensajes que se guardan en Cloud Firestore.
- Ver al instante los mensajes de todos los usuarios, ordenados por hora.

**Valor agregado**
- **Dos formas de entrar:**
  - con la **cuenta de Google** en un solo botón, sin escribir contraseña;
  - con una **cuenta manual** de email y contraseña (por ejemplo `raul@gmail.com`), sin verificar el correo.
- **Chats privados:** lista de todos los usuarios registrados; al tocar uno se abre una conversación en tiempo real que solo ven esas dos personas.
- **Lista de chats** con el último mensaje, la hora y un buscador de personas.
- **Perfil:** foto de Google o inicial del correo, nombre, tipo de cuenta y estado en línea.
- **Sesión recordada:** al volver a abrir la app entra directo, sin iniciar sesión otra vez.
- Recuperar la contraseña por correo ("Forgot password?") y mostrar u ocultar la contraseña.
- Validar los campos y mostrar mensajes de éxito o error.
- Separadores por día ("Today", "Yesterday"), contador de participantes, desplazamiento automático al último mensaje y vibración suave al llegar uno nuevo.
- Diseño premium en modo oscuro.

---

## Diseño

- Modo oscuro con fondo negro y luces de color difuminadas.
- Pantalla de acceso con logo animado en degradado naranja/rosa, tarjeta de vidrio, campos con icono e indicador de "6+ characters".
- Botón blanco "Continue with Google" con la "G" de colores y separador "or use your email".
- Lista de chats con tarjetas, foto o inicial de cada persona, último mensaje y hora.
- Animación al pasar del inicio de sesión a los chats.
- Burbujas con degradado para los mensajes propios y con borde fino para los de otros, con "cola" del lado de quien escribe.
- Campo de mensaje que crece hasta 4 líneas y botón de envío animado.

---

## Conclusiones

- Firebase permite agregar autenticación de usuarios a una app iOS sin programar un servidor: con FirebaseAuth se registran, inician y cierran sesiones con pocas líneas de código.
- Cloud Firestore sincroniza los datos en tiempo real entre todos los usuarios conectados mediante oyentes (`addSnapshotListener`), lo que es ideal para aplicaciones como un chat.
- La integración con Swift Package Manager y `GoogleService-Info.plist` simplifica la configuración, pero se deben proteger las claves y cambiar las reglas de seguridad de Firestore antes de pasar a producción, porque el modo de prueba deja la base abierta por 30 días.
