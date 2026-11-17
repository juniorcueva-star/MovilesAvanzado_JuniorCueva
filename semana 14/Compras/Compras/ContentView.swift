//
//  ContentView.swift
//  Compras
//
//  Pantalla inicial: si hay sesion muestra la app, si no el login.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        if let usuario = sesion.usuario {
            // Temporal: luego se cambia por el TabView segun el rol
            VStack(spacing: 12) {
                Text("Hola, \(usuario.nombre)")
                    .font(.title2.bold())
                Text("Rol: \(usuario.rol)")
                    .foregroundStyle(.secondary)
                Button("Cerrar sesión", role: .destructive) {
                    sesion.cerrar()
                }
                .buttonStyle(.bordered)
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
        .environment(Sesion())
        .modelContainer(ModelContainerProvider.enMemoria())
}
