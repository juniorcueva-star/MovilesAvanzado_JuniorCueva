// Desarrollado por: Junior Cueva
// Docente: Juan Leon - Tecsup
// Semana 04 - POO en Swift (version asistida por IA)
// Sistema de consulta del Metro de Lima y Callao

import Foundation                                          // Trae la biblioteca base, da acceso a readLine()

// ===== CLASE ESTACION (clase padre) =====
class Estacion {                                           // Define el molde de cualquier estacion
    var nombre: String                                     // Nombre de la estacion
    var codigo: String                                     // Codigo tipo E-01, solo la Linea 2 lo usa
    var linea: String                                      // Linea a la que pertenece
    var orden: Int                                         // Posicion dentro del recorrido
    var ascensor: String                                   // Si, No o Sin confirmar
    var repetida: Bool                                     // Marca si el nombre existe en otra linea

    init(nombre: String, codigo: String, linea: String, orden: Int, ascensor: String) {
        self.nombre = nombre                               // self distingue la propiedad del parametro
        self.codigo = codigo                               // Asigna el codigo recibido
        self.linea = linea                                 // Asigna la linea recibida
        self.orden = orden                                 // Asigna la posicion recibida
        self.ascensor = ascensor                           // Asigna el dato de accesibilidad
        self.repetida = false                              // Arranca en false, se calcula despues
    }

    func estaOperativa() -> Bool {                         // Metodo que sera sobrescrito por la clase hija
        return false                                       // Por defecto una estacion no esta operativa
    }

    func numeroLinea() -> String {                         // Devuelve solo el numero de la linea
        if linea == "Linea 1" { return "1" }               // Compara el texto y devuelve el digito
        if linea == "Linea 2" { return "2" }               // Igual para la Linea 2
        if linea == "Linea 3" { return "3" }               // Igual para la Linea 3
        return "4"                                         // Cualquier otro caso es Linea 4
    }

    func nombreCompleto() -> String {                      // Agrega el numero de linea si el nombre se repite
        if repetida {                                      // Solo cuando la bandera esta activa
            return "\(nombre) \(numeroLinea())"            // Ejemplo: Cabitos 1
        }
        return nombre                                      // Si no se repite devuelve el nombre limpio
    }

    func marca() -> String {                               // Devuelve la marca de estado
        if estaOperativa() { return "(F)" }                // Llama al metodo que la clase hija sobrescribe
        return "(NF)"                                      // No operativa
    }

    func etiqueta() -> String {                            // Linea de texto para el listado por linea
        if codigo == "" {                                  // Lineas 1, 3 y 4 no tienen codigo
            return "\(orden). \(nombreCompleto()) \(marca())"
        }
        return "\(codigo)  \(nombreCompleto()) \(marca())" // La Linea 2 muestra su codigo
    }

    func etiquetaConLinea() -> String {                    // Linea de texto para los filtros
        return "\(linea) - \(nombre) \(marca())"           // Incluye la linea porque el filtro las mezcla
    }
}

// ===== CLASE ESTACION OPERATIVA (hereda de Estacion) =====
class EstacionOperativa: Estacion {                        // Los dos puntos indican herencia de Estacion

    override func estaOperativa() -> Bool {                // override reemplaza el metodo del padre
        return true                                        // Esta subclase siempre esta en funcionamiento
    }
}

// ===== CLASE LINEA =====
class Linea {                                              // Agrupa un conjunto de estaciones
    var nombre: String                                     // Nombre de la linea
    var color: String                                      // Color oficial de la linea
    var estaciones: [Estacion]                             // Array de objetos Estacion

    init(nombre: String, color: String) {
        self.nombre = nombre                               // Asigna el nombre recibido
        self.color = color                                 // Asigna el color recibido
        self.estaciones = []                               // Arranca sin estaciones, se llenan despues
    }

    func agregar(_ e: Estacion) {                          // El guion bajo quita la etiqueta al llamarlo
        estaciones.append(e)                               // Agrega el objeto al final del array
    }

    func operativas() -> Int {                             // Cuenta cuantas estan en funcionamiento
        var total = 0                                      // Contador que arranca en cero
        for e in estaciones {                              // Recorre cada objeto del array
            if e.estaOperativa() { total += 1 }            // Suma uno si esta operativa
        }
        return total                                       // Devuelve el conteo final
    }

    func mostrar() {                                       // Imprime el listado completo de la linea
        print("")
        print("--- \(nombre)  (color \(color)) ---")       // Encabezado con nombre y color
        for e in estaciones {                              // Recorre las estaciones en orden
            print("  " + e.etiqueta())                     // Cada objeto decide como mostrarse
        }
        print("  Total: \(estaciones.count) estaciones, \(operativas()) en funcionamiento")
    }
}

// ===== CLASE CONEXION =====
class Conexion {                                           // Representa un punto de transbordo
    var lineaA: String                                     // Primera linea del cruce
    var estacionA: String                                  // Estacion de la primera linea
    var lineaB: String                                     // Segunda linea del cruce
    var estacionB: String                                  // Estacion de la segunda linea
    var tipo: String                                       // Integrado, tunel o sin conexion fisica
    var ubicacion: String                                  // Direccion donde ocurre el cruce

    init(lineaA: String, estacionA: String, lineaB: String, estacionB: String, tipo: String, ubicacion: String) {
        self.lineaA = lineaA                               // Asigna la primera linea
        self.estacionA = estacionA                         // Asigna la primera estacion
        self.lineaB = lineaB                               // Asigna la segunda linea
        self.estacionB = estacionB                         // Asigna la segunda estacion
        self.tipo = tipo                                   // Asigna el tipo de transbordo
        self.ubicacion = ubicacion                         // Asigna la direccion
    }

    func conecta(nombre: String, linea: String) -> Bool {  // Verifica si una estacion participa del cruce
        if estacionA == nombre && lineaA == linea { return true }   // Coincide con el lado A
        if estacionB == nombre && lineaB == linea { return true }   // Coincide con el lado B
        return false                                       // No participa en esta conexion
    }

    func destino(nombre: String, linea: String) -> String { // Devuelve el otro extremo del cruce
        if estacionA == nombre && lineaA == linea {         // Si la estacion buscada es el lado A
            return "\(lineaB), en la estacion \(estacionB)" // Devuelve el lado B
        }
        return "\(lineaA), en la estacion \(estacionA)"     // Caso contrario devuelve el lado A
    }

    func lineaDestino(nombre: String, linea: String) -> String {  // Devuelve solo el nombre de la otra linea
        if estacionA == nombre && lineaA == linea { return lineaB }
        return lineaA
    }

    func mostrar() {                                       // Imprime la conexion en el listado general
        print("  \(lineaA) (\(estacionA))  <-->  \(lineaB) (\(estacionB))")
        print("     Tipo: \(tipo)")                        // Muestra el tipo de transbordo
        print("     Ubicacion: \(ubicacion)")              // Muestra donde queda
    }
}

// ===== CLASE SISTEMA METRO =====
class SistemaMetro {                                       // Clase que gestiona toda la red
    var lineas: [Linea]                                    // Array con las cuatro lineas
    var conexiones: [Conexion]                             // Array con los puntos de transbordo

    init() {
        self.lineas = []                                   // Arranca sin lineas cargadas
        self.conexiones = []                               // Arranca sin conexiones cargadas
    }

    func agregarLinea(_ l: Linea) { lineas.append(l) }     // Suma una linea a la red
    func agregarConexion(_ c: Conexion) { conexiones.append(c) }   // Suma una conexion

    func todasLasEstaciones() -> [Estacion] {              // Junta las estaciones de las cuatro lineas
        var todas: [Estacion] = []                         // Array acumulador vacio
        for linea in lineas {                              // Recorre cada linea
            for e in linea.estaciones {                    // Recorre cada estacion de esa linea
                todas.append(e)                            // La agrega al acumulador
            }
        }
        return todas                                       // Devuelve la lista completa
    }

    func marcarRepetidas() {                               // Detecta nombres que aparecen en dos lineas
        let todas = todasLasEstaciones()                   // Obtiene la lista completa una sola vez
        for a in todas {                                   // Recorre cada estacion
            for b in todas {                               // La compara contra todas las demas
                if a.nombre == b.nombre && a.linea != b.linea {   // Mismo nombre pero distinta linea
                    a.repetida = true                      // Funciona porque las clases son por referencia
                }
            }
        }
    }

    func tieneConexion(_ e: Estacion) -> Bool {            // Indica si la estacion cruza con otra linea
        for c in conexiones {                              // Revisa cada conexion registrada
            if c.conecta(nombre: e.nombre, linea: e.linea) { return true }
        }
        return false                                       // Ninguna conexion la incluye
    }

    func mostrarLista(_ lista: [Estacion], titulo: String) {   // Imprime cualquier lista filtrada
        print("")
        print("--- \(titulo) ---")                         // Encabezado con el nombre del filtro
        if lista.count == 0 {                              // Caso en que el filtro no encuentra nada
            print("  No hay estaciones que cumplan el filtro.")
        }
        for e in lista {                                   // Recorre los resultados
            print("  " + e.etiquetaConLinea())             // Muestra cada uno con su linea
        }
        print("  Total: \(lista.count) estaciones")        // Cantidad de coincidencias
    }
}

// ===== BUSQUEDAS, FILTROS Y REPORTES =====
extension SistemaMetro {                                   // Una extension agrega metodos sin tocar la clase

    func buscarEstacion(_ texto: String) -> [Estacion] {   // Busqueda parcial, no exige el nombre exacto
        var encontradas: [Estacion] = []                   // Acumulador de coincidencias
        let busqueda = texto.lowercased()                  // Pasa la busqueda a minusculas
        for e in todasLasEstaciones() {                    // Recorre las 101 estaciones
            if e.nombre.lowercased().contains(busqueda) {  // contains encuentra el texto en cualquier parte
                encontradas.append(e)                      // Guarda la coincidencia
            }
        }
        return encontradas                                 // Devuelve todas las que calzaron
    }

    func mostrarDetalle(_ e: Estacion) {                   // Ficha completa de una estacion
        print("")
        print("=========================================")
        print("  ESTACION \(e.nombre.uppercased())")       // uppercased convierte a mayusculas
        print("=========================================")
        print("Linea: \(e.linea)")                         // Linea a la que pertenece
        if e.codigo != "" { print("Codigo: \(e.codigo)") } // Solo si tiene codigo asignado

        for linea in lineas {                              // Busca la linea de esta estacion
            if linea.nombre == e.linea {                   // Cuando la encuentra
                print("Posicion: \(e.orden) de \(linea.estaciones.count)")
                if e.orden > 1 {                           // Si no es la primera del recorrido
                    print("Estacion anterior: \(linea.estaciones[e.orden - 2].nombre)")
                }
                if e.orden < linea.estaciones.count {      // Si no es la ultima del recorrido
                    print("Estacion siguiente: \(linea.estaciones[e.orden].nombre)")
                }
            }
        }

        if e.estaOperativa() {                             // Usa el metodo sobrescrito por la subclase
            print("Estado: En funcionamiento")
        } else {
            print("Estado: Aun no funciona")
        }
        print("Ascensor: \(e.ascensor)")                   // Dato de accesibilidad

        var tiene = false                                  // Bandera para saber si imprimio el titulo
        for c in conexiones {                              // Revisa cada conexion de la red
            if c.conecta(nombre: e.nombre, linea: e.linea) {
                if !tiene {                                // Solo la primera vez imprime el encabezado
                    print("")
                    print("CONEXIONES:")
                    tiene = true                           // Marca que ya lo imprimio
                }
                print("  La \(e.linea) conecta aqui con la \(c.destino(nombre: e.nombre, linea: e.linea))")
                print("  Tipo: \(c.tipo)")                 // Tipo de transbordo
                print("  Ubicacion: \(c.ubicacion)")       // Direccion del cruce
            }
        }
        if !tiene {                                        // Si el bucle no encontro ninguna
            print("Conexiones: esta estacion no conecta con otras lineas")
        }
        print("=========================================")
    }

    func mostrarConexiones() {                             // Listado de los seis puntos de transbordo
        print("")
        print("=========================================")
        print("   CONEXIONES ENTRE LINEAS")
        print("=========================================")
        for c in conexiones {                              // Recorre el array de conexiones
            c.mostrar()                                    // Cada objeto sabe como mostrarse
            print("")
        }
        print("Total: \(conexiones.count) conexiones")     // Cantidad registrada
        print("=========================================")
    }

    func calcularRuta(desde: String, hasta: String) {      // Estima el trayecto entre dos estaciones
        let origen = buscarEstacion(desde)                 // Busca la estacion de partida
        let destino = buscarEstacion(hasta)                // Busca la estacion de llegada

        if origen.count == 0 || destino.count == 0 {       // Si alguna no existe corta el proceso
            print("No se encontro alguna de las dos estaciones.")
            return                                         // return sale del metodo de inmediato
        }

        let a = origen[0]                                  // Toma la primera coincidencia del origen
        let b = destino[0]                                 // Toma la primera coincidencia del destino

        print("")
        print("=========================================")
        print("  RUTA: \(a.nombre) hacia \(b.nombre)")
        print("=========================================")

        if a.linea == b.linea {                            // Caso simple: ambas en la misma linea
            var paradas = a.orden - b.orden                // Resta las posiciones
            if paradas < 0 { paradas = -paradas }          // Convierte el resultado a positivo
            print("Ambas estan en la \(a.linea)")
            print("Viaje directo, sin transbordo")
            print("Estaciones intermedias: \(paradas)")    // Cuantas paradas separan ambos puntos
        } else {                                           // Caso con transbordo entre lineas distintas
            print("Origen en \(a.linea), destino en \(b.linea)")
            var hayRuta = false                            // Bandera de transbordo encontrado
            for c in conexiones {                          // Busca una conexion entre ambas lineas
                let cruceA = (c.lineaA == a.linea && c.lineaB == b.linea)   // Cruce en un sentido
                let cruceB = (c.lineaB == a.linea && c.lineaA == b.linea)   // Cruce en el otro sentido
                if cruceA || cruceB {                      // Si alguno de los dos calza
                    print("Debe hacer transbordo en:")
                    print("  \(c.lineaA) estacion \(c.estacionA)")
                    print("  \(c.lineaB) estacion \(c.estacionB)")
                    print("  Tipo: \(c.tipo)")
                    hayRuta = true                         // Marca que si encontro ruta
                }
            }
            if !hayRuta {                                  // Ninguna conexion une esas dos lineas
                print("No existe conexion directa entre esas dos lineas.")
                print("Se requiere mas de un transbordo.")
            }
        }
        print("=========================================")
    }

    func mostrarEstadisticas() {                           // Reporte general de la red
        let todas = todasLasEstaciones()                   // Obtiene las 101 estaciones
        var operativas = 0                                 // Contador de estaciones en servicio
        var conAscensor = 0                                // Contador de ascensores confirmados
        var sinAscensor = 0                                // Contador de estaciones sin ascensor
        var porConfirmar = 0                               // Contador de datos no verificados

        for e in todas {                                   // Un solo recorrido para los cuatro contadores
            if e.estaOperativa() { operativas += 1 }       // Suma si esta en funcionamiento
            if e.ascensor == "Si" { conAscensor += 1 }     // Suma si tiene ascensor confirmado
            if e.ascensor == "No" { sinAscensor += 1 }     // Suma si no tiene ascensor
            if e.ascensor == "Sin confirmar" { porConfirmar += 1 }   // Suma si el dato no esta verificado
        }

        print("")
        print("=========================================")
        print("   ESTADISTICAS DE LA RED")
        print("=========================================")
        print("Total de estaciones registradas: \(todas.count)")
        print("En funcionamiento: \(operativas)")
        print("Aun no operativas: \(todas.count - operativas)")   // Resta para obtener las pendientes
        print("Conexiones entre lineas: \(conexiones.count)")
        print("-----------------------------------------")
        print("Con ascensor confirmado: \(conAscensor)")
        print("Sin ascensor: \(sinAscensor)")
        print("Dato por confirmar: \(porConfirmar)")
        print("-----------------------------------------")
        for linea in lineas {                              // Detalle por cada linea de la red
            print("\(linea.nombre): \(linea.estaciones.count) estaciones, \(linea.operativas()) operativas")
        }
        print("=========================================")
    }

    func filtrarOperativas() -> [Estacion] {               // Devuelve solo las que estan en servicio
        var lista: [Estacion] = []                         // Acumulador vacio
        for e in todasLasEstaciones() {                    // Recorre todas
            if e.estaOperativa() { lista.append(e) }       // Filtra por el metodo de la subclase
        }
        return lista                                       // Devuelve el resultado
    }

    func filtrarPorAscensor(_ valor: String) -> [Estacion] {   // Filtra por el estado del ascensor
        var lista: [Estacion] = []                         // Acumulador vacio
        for e in todasLasEstaciones() {                    // Recorre todas
            if e.ascensor == valor { lista.append(e) }     // Compara con el valor recibido
        }
        return lista                                       // Devuelve las coincidencias
    }

    func filtrarConConexion() -> [Estacion] {              // Devuelve las que cruzan con otra linea
        var lista: [Estacion] = []                         // Acumulador vacio
        for e in todasLasEstaciones() {                    // Recorre todas
            if tieneConexion(e) { lista.append(e) }        // Usa el metodo de verificacion
        }
        return lista                                       // Devuelve las coincidencias
    }
}

// ===== CARGA DE DATOS =====
let metro = SistemaMetro()                                 // Crea el objeto que gestiona toda la red

let linea1 = Linea(nombre: "Linea 1", color: "Verde")      // Crea la Linea 1
let nombresL1 = ["Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa Maria",
                 "Maria Auxiliadora", "San Juan", "Atocongo", "Jorge Chavez", "Ayacucho",
                 "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra",
                 "Miguel Grau", "El Angel", "Presbitero Maestro", "Caja de Agua",
                 "Piramide del Sol", "Los Jardines", "Los Postes", "San Carlos",
                 "San Martin", "Santa Rosa", "Bayovar"]    // Array con los 26 nombres en orden
let ascensorL1 = ["Si", "Si", "No", "No", "No", "Si", "Si", "Si", "Si", "Si", "Si", "No",
                  "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si",
                  "Si", "Si"]                              // Array paralelo con el dato de ascensor
for i in 0..<nombresL1.count {                             // Recorre ambos arrays con el mismo indice
    linea1.agregar(EstacionOperativa(nombre: nombresL1[i], codigo: "", linea: "Linea 1",
                                     orden: i + 1, ascensor: ascensorL1[i]))   // Toda L1 esta operativa
}
metro.agregarLinea(linea1)                                 // Suma la linea al sistema

let linea2 = Linea(nombre: "Linea 2", color: "Amarillo")   // Crea la Linea 2
let nombresL2 = ["Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
                 "Carmen de la Legua", "Oscar R. Benavides", "San Marcos", "Elio",
                 "La Alborada", "Tingo Maria", "Parque Murillo", "Plaza Bolognesi",
                 "Estacion Central", "Manco Capac", "Cangallo", "28 de Julio",
                 "Nicolas Ayllon", "Circunvalacion", "San Juan de Dios", "Evitamiento",
                 "Ovalo Santa Anita", "Colectora Industrial", "Hermilio Valdizan",
                 "Mercado Santa Anita", "Vista Alegre", "Prolongacion Javier Prado",
                 "Municipalidad de Ate"]                   // Los 27 nombres de Callao a Ate
for i in 0..<nombresL2.count {                             // Recorre las 27 posiciones
    var codigo = "E-\(i + 1)"                              // Arma el codigo con el numero
    if i + 1 < 10 { codigo = "E-0\(i + 1)" }               // Agrega el cero para E-01 hasta E-09
    if i + 1 >= 20 && i + 1 <= 24 {                        // Las estaciones E-20 a E-24 ya operan
        linea2.agregar(EstacionOperativa(nombre: nombresL2[i], codigo: codigo,
                                         linea: "Linea 2", orden: i + 1, ascensor: "Si"))
    } else {                                               // El resto sigue en construccion
        linea2.agregar(Estacion(nombre: nombresL2[i], codigo: codigo,
                                linea: "Linea 2", orden: i + 1, ascensor: "Sin confirmar"))
    }
}
metro.agregarLinea(linea2)                                 // Suma la linea al sistema

let linea3 = Linea(nombre: "Linea 3", color: "Celeste")    // Crea la Linea 3
let nombresL3 = ["Pedro Miotta", "Los Heroes", "Las Gardenias", "Alejandro Velasco",
                 "Cabitos", "Juana Alarco", "Republica de Panama", "Parque Reducto",
                 "Parque Central de Miraflores", "Huaca Pucllana", "Andres Aramburu",
                 "Conde de San Isidro", "Cesar Canevaro", "Museo de Historia Natural",
                 "Parque de la Reserva", "Estacion Central", "Garcilaso de la Vega",
                 "Tacna", "Caqueta", "Jose Granda", "Bartolome de las Casas",
                 "Tomas Valle", "Carlos Izaguirre", "Naranjal", "Villa Sol",
                 "2 de Octubre", "Huandoy", "El Alamo"]    // Los 28 nombres de sur a norte
for i in 0..<nombresL3.count {                             // Recorre las 28 posiciones
    linea3.agregar(Estacion(nombre: nombresL3[i], codigo: "", linea: "Linea 3",
                            orden: i + 1, ascensor: "Sin confirmar"))   // Ninguna opera todavia
}
metro.agregarLinea(linea3)                                 // Suma la linea al sistema

let linea4 = Linea(nombre: "Linea 4", color: "Rojo")       // Crea la Linea 4
let nombresL4 = ["Venezuela", "Rafael Escardo", "Pando", "Jose de Sucre", "Brasil",
                 "Felipe Salaverry", "Guillermo Prescott", "Las Palmeras",
                 "Conde de San Isidro", "Rivera Navarrete", "Pablo Carriquiry",
                 "La Cultura", "San Luis", "Monterrico", "Manuel Olguin", "Los Frutales",
                 "La Molina", "Santa Patricia", "Mayorazgo", "Mercado Santa Anita"]
for i in 0..<nombresL4.count {                             // Recorre las 20 posiciones del troncal
    linea4.agregar(Estacion(nombre: nombresL4[i], codigo: "", linea: "Linea 4",
                            orden: i + 1, ascensor: "Sin confirmar"))   // Ninguna opera todavia
}
metro.agregarLinea(linea4)                                 // Suma la linea al sistema

metro.marcarRepetidas()                                    // Detecta los nombres duplicados entre lineas

metro.agregarConexion(Conexion(lineaA: "Linea 1", estacionA: "Gamarra",
                               lineaB: "Linea 2", estacionB: "28 de Julio",
                               tipo: "Sin conexion fisica, 400 a 600 metros de distancia",
                               ubicacion: "Aviacion con 28 de Julio, La Victoria"))
metro.agregarConexion(Conexion(lineaA: "Linea 1", estacionA: "Cabitos",
                               lineaB: "Linea 3", estacionB: "Cabitos",
                               tipo: "Transbordo integrado",
                               ubicacion: "Santiago de Surco"))
metro.agregarConexion(Conexion(lineaA: "Linea 1", estacionA: "La Cultura",
                               lineaB: "Linea 4", estacionB: "La Cultura",
                               tipo: "Transbordo integrado",
                               ubicacion: "Javier Prado con Aviacion, San Borja"))
metro.agregarConexion(Conexion(lineaA: "Linea 2", estacionA: "Estacion Central",
                               lineaB: "Linea 3", estacionB: "Estacion Central",
                               tipo: "Transbordo integrado, ademas conecta con el Metropolitano",
                               ubicacion: "Paseo Colon, Cercado de Lima"))
metro.agregarConexion(Conexion(lineaA: "Linea 2", estacionA: "Mercado Santa Anita",
                               lineaB: "Linea 4", estacionB: "Mercado Santa Anita",
                               tipo: "Transbordo integrado",
                               ubicacion: "Carretera Central, Santa Anita"))
metro.agregarConexion(Conexion(lineaA: "Linea 3", estacionA: "Conde de San Isidro",
                               lineaB: "Linea 4", estacionB: "Conde de San Isidro",
                               tipo: "Transbordo integrado, ademas corredores azul y rojo",
                               ubicacion: "Arequipa con Javier Prado, San Isidro"))

// ===== MENU PRINCIPAL =====
print("")
print("=========================================")
print("   BIENVENIDO AL SISTEMA DE CONSULTA")
print("      METRO DE LIMA Y CALLAO")
print("=========================================")

var salir = false                                          // Bandera que controla el bucle del menu

while !salir {                                             // Repite mientras la bandera sea falsa
    print("")
    print("Opciones:")
    print("  1. Ver estaciones de una linea")
    print("  2. Buscar una estacion")
    print("  3. Ver conexiones entre lineas")
    print("  4. Filtrar estaciones")
    print("  5. Calcular ruta entre dos estaciones")
    print("  6. Estadisticas de la red")
    print("  7. Salir")
    print("Elija una opcion:")

    let opcion = Int(readLine() ?? "") ?? 0                // Lee la opcion, si falla usa cero

    switch opcion {                                        // Evalua la opcion elegida
    case 1:                                                // Ver estaciones de una linea
        print("Escriba el numero de linea (1 al 4):")
        let numero = Int(readLine() ?? "") ?? 0            // Lee el numero de linea
        if numero >= 1 && numero <= 4 {                    // Valida que este en el rango
            metro.lineas[numero - 1].mostrar()             // Resta uno porque el array empieza en cero
        } else {
            print("Esa linea no existe.")
        }

    case 2:                                                // Buscar una estacion
        print("Escriba el nombre o parte del nombre:")
        let texto = readLine() ?? ""                       // Lee el texto de busqueda
        let resultados = metro.buscarEstacion(texto)       // Busqueda parcial
        if resultados.count == 0 {                         // Sin coincidencias
            print("No se encontro ninguna estacion.")
        } else if resultados.count > 6 {                   // Demasiadas coincidencias
            print("Se encontraron \(resultados.count) coincidencias. Sea mas especifico:")
            for e in resultados {                          // Muestra solo los nombres
                print("  - \(e.nombre) (\(e.linea))")
            }
        } else {                                           // Cantidad manejable, muestra el detalle
            for e in resultados {
                metro.mostrarDetalle(e)                    // Ficha completa de cada coincidencia
            }
        }

    case 3:                                                // Ver conexiones
        metro.mostrarConexiones()

    case 4:                                                // Filtrar estaciones
        print("Filtros disponibles:")
        print("  1. Estaciones en funcionamiento")
        print("  2. Estaciones con ascensor confirmado")
        print("  3. Estaciones sin ascensor")
        print("  4. Estaciones que conectan con otra linea")
        print("Elija un filtro:")
        let filtro = Int(readLine() ?? "") ?? 0            // Lee el filtro elegido

        switch filtro {                                    // Switch anidado dentro del case 4
        case 1:
            metro.mostrarLista(metro.filtrarOperativas(), titulo: "ESTACIONES EN FUNCIONAMIENTO")
        case 2:
            metro.mostrarLista(metro.filtrarPorAscensor("Si"), titulo: "CON ASCENSOR CONFIRMADO")
        case 3:
            metro.mostrarLista(metro.filtrarPorAscensor("No"), titulo: "SIN ASCENSOR")
        case 4:
            metro.mostrarLista(metro.filtrarConConexion(), titulo: "CON CONEXION A OTRA LINEA")
        default:
            print("Filtro no valido.")
        }

    case 5:                                                // Calcular ruta
        print("Estacion de origen:")
        let origen = readLine() ?? ""                      // Lee el punto de partida
        print("Estacion de destino:")
        let destino = readLine() ?? ""                     // Lee el punto de llegada
        metro.calcularRuta(desde: origen, hasta: destino)  // Calcula el trayecto

    case 6:                                                // Estadisticas
        metro.mostrarEstadisticas()

    case 7:                                                // Salir
        salir = true                                       // Cambia la bandera para cortar el bucle
        print("")
        print("Gracias por usar el sistema.")

    default:                                               // Cualquier numero fuera del menu
        print("Opcion no valida.")
    }
}