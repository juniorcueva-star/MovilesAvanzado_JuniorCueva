//
//  ModelContainerProvider.swift
//  Compras
//

import Foundation
import SwiftData

@MainActor
final class ModelContainerProvider {

    // Singleton: un solo contenedor para toda la app (igual que en el laboratorio)
    static let shared = ModelContainerProvider()

    /// Las cuatro clases que se guardan en la base de datos
    static let esquema = Schema([Usuario.self, Proveedor.self, Producto.self, Compra.self])

    let container: ModelContainer

    private init() {
        do {
            // La carpeta Application Support puede no existir la primera vez
            let carpeta = URL.applicationSupportDirectory
            try FileManager.default.createDirectory(at: carpeta, withIntermediateDirectories: true)

            let config = ModelConfiguration(
                "ComprasData",
                schema: Self.esquema,
                url: carpeta.appendingPathComponent("ComprasData.sqlite")
            )
            print("Base de datos SQLite en: \(config.url.path)")
            container = try ModelContainer(for: Self.esquema, configurations: [config])
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error)")
        }
    }

    /// Contenedor en memoria para previews y pruebas
    static func enMemoria() -> ModelContainer {
        let config = ModelConfiguration(schema: esquema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: esquema, configurations: [config])
        } catch {
            fatalError("Error al crear el contenedor en memoria: \(error)")
        }
    }
}
