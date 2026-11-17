//
//  PrincipalView.swift
//  Compras
//
//  TabView cuyas pestanas dependen del rol.
//

import SwiftUI

struct PrincipalView: View {
    let usuario: Usuario

    var body: some View {
        if usuario.esSupervisor {
            // Supervisor: Resumen, Aprobar, Por pagar, Productos, Proveedores
            TabView {
                PestanaPendiente(titulo: "Resumen")
                    .tabItem { Label("Resumen", systemImage: "chart.bar.xaxis") }
                PestanaPendiente(titulo: "Aprobar")
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                PestanaPendiente(titulo: "Por pagar")
                    .tabItem { Label("Por pagar", systemImage: "creditcard") }
                PestanaPendiente(titulo: "Productos")
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                PestanaPendiente(titulo: "Proveedores")
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
            }
        } else {
            // Comprador: Productos, Proveedores, Compra, Mis compras
            TabView {
                PestanaPendiente(titulo: "Productos")
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                PestanaPendiente(titulo: "Proveedores")
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
                PestanaPendiente(titulo: "Compra")
                    .tabItem { Label("Compra", systemImage: "cart.badge.plus") }
                PestanaPendiente(titulo: "Mis compras")
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle") }
            }
        }
    }
}

/// Pantalla temporal mientras se construye cada pestana
struct PestanaPendiente: View {
    let titulo: String

    var body: some View {
        NavigationStack {
            ContentUnavailableView(titulo, systemImage: "hammer",
                                   description: Text("Pantalla en construcción"))
                .navigationTitle(titulo)
                .conAvatar()
        }
    }
}
