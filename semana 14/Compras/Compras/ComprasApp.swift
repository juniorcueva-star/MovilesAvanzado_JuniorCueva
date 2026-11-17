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
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Contenedor persistente: los datos no se pierden al cerrar la app
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
