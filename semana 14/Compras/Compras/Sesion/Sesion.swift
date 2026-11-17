//
//  Sesion.swift
//  Compras
//
//  Recuerda al usuario conectado mientras la app esta abierta.
//  Se pone en el entorno con .environment(sesion) desde ComprasApp.
//

import Foundation
import Observation

@Observable
final class Sesion {
    var usuario: Usuario?

    init(usuario: Usuario? = nil) {
        self.usuario = usuario
    }

    var esSupervisor: Bool { usuario?.esSupervisor ?? false }

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
    }

    /// Poner la variable en nil: la vista principal cambia sola al login
    func cerrar() {
        usuario = nil
    }
}
