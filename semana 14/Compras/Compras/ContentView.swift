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
            PrincipalView(usuario: usuario)
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
