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
                ResumenView()
                    .tabItem { Label("Resumen", systemImage: "chart.bar.xaxis") }
                AprobarView()
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                PorPagarView()
                    .tabItem { Label("Por pagar", systemImage: "creditcard") }
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                ProveedoresView()
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
            }
        } else {
            // Comprador: Productos, Proveedores, Compra, Mis compras
            TabView {
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                ProveedoresView()
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
                NuevaCompraView()
                    .tabItem { Label("Compra", systemImage: "cart.badge.plus") }
                MisComprasView()
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle") }
            }
        }
    }
}
