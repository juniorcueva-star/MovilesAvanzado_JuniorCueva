//
//  ServicioAuth.swift
//  Compras
//
//  Registro y login con SwiftData.
//

import Foundation
import SwiftData

enum ErrorAuth: LocalizedError, Equatable {
    case nombreVacio
    case usuarioVacio
    case usuarioRepetido
    case claveCorta
    case clavesDistintas
    case rolInvalido
    case credencialesIncorrectas

    var errorDescription: String? {
        switch self {
        case .nombreVacio: return "Escribe tu nombre completo."
        case .usuarioVacio: return "Escribe un usuario."
        case .usuarioRepetido: return "Ese usuario ya existe. Elige otro."
        case .claveCorta: return "La clave debe tener mínimo 6 caracteres."
        case .clavesDistintas: return "La clave y su confirmación no coinciden."
        case .rolInvalido: return "Elige un rol."
        // Mensaje generico: no dice si fallo el usuario o la clave
        case .credencialesIncorrectas: return "Usuario o clave incorrectos"
        }
    }
}

enum ServicioAuth {

    static let minimoClave = 6

    /// Normaliza el usuario: sin espacios y en minusculas
    static func normalizar(_ usuario: String) -> String {
        usuario.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    /// Usuario unico sin distinguir mayusculas: FetchDescriptor + #Predicate + fetchCount
    static func existeUsuario(_ usuario: String, en contexto: ModelContext) -> Bool {
        let buscado = normalizar(usuario)      // se guarda en un let antes de usarlo en #Predicate
        let descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.usuario == buscado }
        )
        let cantidad = (try? contexto.fetchCount(descriptor)) ?? 0
        return cantidad > 0
    }

    /// Valida los datos del registro. Devuelve el primer error encontrado o nil.
    static func validarRegistro(nombre: String, usuario: String, clave: String,
                                confirmacion: String, rol: String,
                                en contexto: ModelContext) -> ErrorAuth? {
        if nombre.trimmingCharacters(in: .whitespaces).isEmpty { return .nombreVacio }
        if normalizar(usuario).isEmpty { return .usuarioVacio }
        if existeUsuario(usuario, en: contexto) { return .usuarioRepetido }
        if clave.count < minimoClave { return .claveCorta }
        if clave != confirmacion { return .clavesDistintas }
        if !Rol.todos.contains(rol) { return .rolInvalido }
        return nil
    }

    /// Crea el usuario y lo guarda. Al registrarse la persona entra directo a la app.
    @discardableResult
    static func registrar(nombre: String, usuario: String, clave: String,
                          confirmacion: String, rol: String,
                          en contexto: ModelContext) throws -> Usuario {
        if let error = validarRegistro(nombre: nombre, usuario: usuario, clave: clave,
                                       confirmacion: confirmacion, rol: rol, en: contexto) {
            throw error
        }
        let nuevo = Usuario(nombre: nombre.trimmingCharacters(in: .whitespaces),
                            usuario: normalizar(usuario),
                            clave: clave,
                            rol: rol)
        contexto.insert(nuevo)
        try contexto.save()
        return nuevo
    }

    /// Login: busca usuario y clave. Si no coinciden, error generico.
    static func login(usuario: String, clave: String, en contexto: ModelContext) throws -> Usuario {
        let buscado = normalizar(usuario)
        let descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.usuario == buscado && $0.clave == clave }
        )
        guard let encontrado = try contexto.fetch(descriptor).first else {
            throw ErrorAuth.credencialesIncorrectas
        }
        return encontrado
    }
}
