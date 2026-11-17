//
//  ComprasApp.swift
//  Compras
//
//  Grupo B · Caso Compras (SwiftUI + SwiftData)
//

import SwiftUI
import SwiftData

@main
struct ComprasApp: App {
    // Sesion compartida: la app recuerda al usuario mientras esta abierta
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(sesion)
                // Contenedor persistente: los datos no se pierden al cerrar la app
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
