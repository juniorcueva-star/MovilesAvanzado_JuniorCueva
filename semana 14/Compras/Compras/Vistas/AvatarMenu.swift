//
//  AvatarMenu.swift
//  Compras
//
//  Cuenta: menu del avatar con nombre, rol y Cerrar sesion.
//

import SwiftUI

struct AvatarCirculo: View {
    let iniciales: String
    var tamano: CGFloat = 34

    var body: some View {
        Text(iniciales)
            .font(.system(size: tamano * 0.4, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: tamano, height: tamano)
            .background(Color.accentColor.gradient, in: Circle())
    }
}

struct AvatarMenu: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        if let usuario = sesion.usuario {
            Menu {
                Section {
                    Label(usuario.nombre, systemImage: "person.fill")
                    Label("Rol: \(usuario.rol)", systemImage: usuario.esSupervisor ? "checkmark.seal.fill" : "cart.fill")
                    Label("@\(usuario.usuario)", systemImage: "at")
                }
                Section {
                    Button(role: .destructive) {
                        sesion.cerrar()   // Poner el usuario en nil: vuelve al login
                    } label: {
                        Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            } label: {
                AvatarCirculo(iniciales: usuario.iniciales)
            }
            .accessibilityLabel("Cuenta de \(usuario.nombre)")
        }
    }
}

extension View {
    /// Agrega el avatar de la sesion a la derecha de la barra
    func conAvatar() -> some View {
        toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                AvatarMenu()
            }
        }
    }
}
