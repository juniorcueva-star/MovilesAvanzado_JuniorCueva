//
//  Usuario.swift
//  Compras
//

import Foundation
import SwiftData

/// Roles permitidos en la app. Se guardan como texto en Usuario.rol.
enum Rol {
    static let comprador = "Comprador"
    static let supervisor = "Supervisor"
    static let todos = [comprador, supervisor]
}

@Model
final class Usuario {
    var nombre: String      // Nombre completo
    var usuario: String     // Se guarda en minusculas para que sea unico sin distinguir mayusculas
    var clave: String       // Practica: texto plano (en la proxima clase se cambia por hash)
    var rol: String         // "Comprador" o "Supervisor"

    // Un usuario registra muchas compras.
    // .deny: no se puede borrar un usuario que ya tiene compras.
    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, rol: String) {
        self.nombre = nombre
        self.usuario = usuario.lowercased()
        self.clave = clave
        self.rol = rol
    }

    var esSupervisor: Bool { rol == Rol.supervisor }

    /// Iniciales para el avatar: "Maria Torres" -> "MT"
    var iniciales: String {
        let partes = nombre.split(separator: " ").prefix(2)
        let letras = partes.compactMap { $0.first }.map { String($0) }.joined()
        return letras.isEmpty ? "?" : letras.uppercased()
    }
}
