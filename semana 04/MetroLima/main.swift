// Desarrollado por: Junior Cueva
// Docente: Juan Leon - Tecsup


import Foundation

// estacion
class Estacion {
    var nombre: String
    var codigo: String
    var linea: String
    var orden: Int
    var operativa: Bool
    var ascensor: String
    var repetida: Bool

    init(nombre: String, codigo: String, linea: String, orden: Int, operativa: Bool, ascensor: String) {
        self.nombre = nombre
        self.codigo = codigo
        self.linea = linea
        self.orden = orden
        self.operativa = operativa
        self.ascensor = ascensor
        self.repetida = false
    }

    func numeroLinea() -> String {
        if linea == "Linea 1" {
            return "1"
        }
        if linea == "Linea 2" {
            return "2"
        }
        if linea == "Linea 3" {
            return "3"
        }
        return "4"
    }

    func nombreCompleto() -> String {
        if repetida {
            return "\(nombre) \(numeroLinea())"
        }
        return nombre
    }

    func marca() -> String {
        if operativa {
            return "(F)"
        }
        return "(NF)"
    }

    func etiqueta() -> String {
        if codigo == "" {
            return "\(orden). \(nombreCompleto()) \(marca())"
        }
        return "\(codigo)  \(nombreCompleto()) \(marca())"
    }

    func etiquetaConLinea() -> String {
        return "\(linea) - \(nombre) \(marca())"
    }
}

// ===== CLASE LINEA =====
class Linea {
    var nombre: String
    var color: String
    var estaciones: [Estacion]

    init(nombre: String, color: String) {
        self.nombre = nombre
        self.color = color
        self.estaciones = []
    }

    func agregar(_ e: Estacion) {
        estaciones.append(e)
    }

    func mostrar() {
        print("")
        print("--- \(nombre)  (color \(color)) ---")
        for e in estaciones {
            print("  " + e.etiqueta())
        }
        print("  Total: \(estaciones.count) estaciones")
    }
}

// CONEXION 
class Conexion {
    var lineaA: String
    var estacionA: String
    var lineaB: String
    var estacionB: String
    var tipo: String
    var ubicacion: String

    init(lineaA: String, estacionA: String, lineaB: String, estacionB: String, tipo: String, ubicacion: String) {
        self.lineaA = lineaA
        self.estacionA = estacionA
        self.lineaB = lineaB
        self.estacionB = estacionB
        self.tipo = tipo
        self.ubicacion = ubicacion
    }

    func conecta(nombre: String, linea: String) -> Bool {
        if estacionA == nombre && lineaA == linea {
            return true
        }
        if estacionB == nombre && lineaB == linea {
            return true
        }
        return false
    }

    func destino(nombre: String, linea: String) -> String {
        if estacionA == nombre && lineaA == linea {
            return "\(lineaB), en la estacion \(estacionB)"
        }
        return "\(lineaA), en la estacion \(estacionA)"
    }

    func mostrar() {
        print("  \(lineaA) (\(estacionA))  <-->  \(lineaB) (\(estacionB))")
        print("     Tipo: \(tipo)")
        print("     Ubicacion: \(ubicacion)")
    }
}

// sitema metro
class SistemaMetro {
    var lineas: [Linea]
    var conexiones: [Conexion]

    init() {
        self.lineas = []
        self.conexiones = []
    }

    func agregarLinea(_ l: Linea) {
        lineas.append(l)
    }

    func agregarConexion(_ c: Conexion) {
        conexiones.append(c)
    }

    func todasLasEstaciones() -> [Estacion] {
        var todas: [Estacion] = []
        for linea in lineas {
            for e in linea.estaciones {
                todas.append(e)
            }
        }
        return todas
    }

    func marcarRepetidas() {
        let todas = todasLasEstaciones()
        for a in todas {
            for b in todas {
                if a.nombre == b.nombre && a.linea != b.linea {
                    a.repetida = true
                }
            }
        }
    }

    func tieneConexion(_ e: Estacion) -> Bool {
        for c in conexiones {
            if c.conecta(nombre: e.nombre, linea: e.linea) {
                return true
            }
        }
        return false
    }

    func mostrarLista(_ lista: [Estacion], titulo: String) {
        print("")
        print("--- \(titulo) ---")
        if lista.count == 0 {
            print("  No hay estaciones que cumplan el filtro.")
        }
        for e in lista {
            print("  " + e.etiquetaConLinea())
        }
        print("  Total: \(lista.count) estaciones")
    }
}


// datos
let metro = SistemaMetro()

let linea1 = Linea(nombre: "Linea 1", color: "Verde")
let nombresL1 = ["Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa Maria",
                 "Maria Auxiliadora", "San Juan", "Atocongo", "Jorge Chavez", "Ayacucho",
                 "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra",
                 "Miguel Grau", "El Angel", "Presbitero Maestro", "Caja de Agua",
                 "Piramide del Sol", "Los Jardines", "Los Postes", "San Carlos",
                 "San Martin", "Santa Rosa", "Bayovar"]
let ascensorL1 = ["Si", "Si", "No", "No", "No", "Si", "Si", "Si", "Si", "Si", "Si", "No",
                  "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si", "Si",
                  "Si", "Si"]
for i in 0..<nombresL1.count {
    linea1.agregar(Estacion(nombre: nombresL1[i], codigo: "", linea: "Linea 1",
                            orden: i + 1, operativa: true, ascensor: ascensorL1[i]))
}
metro.agregarLinea(linea1)

let linea2 = Linea(nombre: "Linea 2", color: "Amarillo")
let nombresL2 = ["Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
                 "Carmen de la Legua", "Oscar R. Benavides", "San Marcos", "Elio",
                 "La Alborada", "Tingo Maria", "Parque Murillo", "Plaza Bolognesi",
                 "Estacion Central", "Manco Capac", "Cangallo", "28 de Julio",
                 "Nicolas Ayllon", "Circunvalacion", "San Juan de Dios", "Evitamiento",
                 "Ovalo Santa Anita", "Colectora Industrial", "Hermilio Valdizan",
                 "Mercado Santa Anita", "Vista Alegre", "Prolongacion Javier Prado",
                 "Municipalidad de Ate"]
for i in 0..<nombresL2.count {
    var codigo = "E-\(i + 1)"
    if i + 1 < 10 {
        codigo = "E-0\(i + 1)"
    }
    let enServicio = (i + 1 >= 20 && i + 1 <= 24)
    var ascensorL2 = "Sin confirmar"
    if enServicio {
        ascensorL2 = "Si"
    }
    linea2.agregar(Estacion(nombre: nombresL2[i], codigo: codigo, linea: "Linea 2",
                            orden: i + 1, operativa: enServicio, ascensor: ascensorL2))
}
metro.agregarLinea(linea2)

let linea3 = Linea(nombre: "Linea 3", color: "Celeste")
let nombresL3 = ["Pedro Miotta", "Los Heroes", "Las Gardenias", "Alejandro Velasco",
                 "Cabitos", "Juana Alarco", "Republica de Panama", "Parque Reducto",
                 "Parque Central de Miraflores", "Huaca Pucllana", "Andres Aramburu",
                 "Conde de San Isidro", "Cesar Canevaro", "Museo de Historia Natural",
                 "Parque de la Reserva", "Estacion Central", "Garcilaso de la Vega",
                 "Tacna", "Caqueta", "Jose Granda", "Bartolome de las Casas",
                 "Tomas Valle", "Carlos Izaguirre", "Naranjal", "Villa Sol",
                 "2 de Octubre", "Huandoy", "El Alamo"]
for i in 0..<nombresL3.count {
    linea3.agregar(Estacion(nombre: nombresL3[i], codigo: "", linea: "Linea 3",
                            orden: i + 1, operativa: false, ascensor: "Sin confirmar"))
}
metro.agregarLinea(linea3)

let linea4 = Linea(nombre: "Linea 4", color: "Rojo")
let nombresL4 = ["Venezuela", "Rafael Escardo", "Pando", "Jose de Sucre", "Brasil",
                 "Felipe Salaverry", "Guillermo Prescott", "Las Palmeras",
                 "Conde de San Isidro", "Rivera Navarrete", "Pablo Carriquiry",
                 "La Cultura", "San Luis", "Monterrico", "Manuel Olguin", "Los Frutales",
                 "La Molina", "Santa Patricia", "Mayorazgo", "Mercado Santa Anita"]
for i in 0..<nombresL4.count {
    linea4.agregar(Estacion(nombre: nombresL4[i], codigo: "", linea: "Linea 4",
                            orden: i + 1, operativa: false, ascensor: "Sin confirmar"))
}
metro.agregarLinea(linea4)

metro.marcarRepetidas()

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