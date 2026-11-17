//
//  ProductosView.swift
//  Compras
//
//  B3 · Productos: costo promedio, stock en color y valor del inventario.
//  Comprador: solo consultar y buscar. Supervisor: crear, editar y borrar.
//

import SwiftUI
import SwiftData

struct ProductosView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var productoAEditar: Producto?
    @State private var mensajeBorrado: String?

    /// ② Busqueda por nombre o categoria
    private var productosFiltrados: [Producto] {
        if busqueda.isEmpty { return productos }
        return productos.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda)
                || $0.categoria.localizedCaseInsensitiveContains(busqueda)
        }
    }

    /// ④ Valor del inventario = suma de stock x costo promedio
    private var valorInventario: Double {
        productosFiltrados.reduce(0) { $0 + $1.valorInventario }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Label("Valor del inventario", systemImage: "banknote")
                        Spacer()
                        Text(valorInventario.soles)
                            .font(.headline)
                            .monospacedDigit()
                    }
                } footer: {
                    Text("Stock × costo promedio de \(productosFiltrados.count) producto(s)")
                }

                Section("Productos") {
                    ForEach(productosFiltrados) { producto in
                        FilaProducto(producto: producto)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if sesion.esSupervisor { productoAEditar = producto }
                            }
                    }
                    // ⑤ Deslizar para borrar: solo supervisor (nil desactiva el swipe)
                    .onDelete(perform: sesion.esSupervisor ? borrar : nil)
                }
            }
            .overlay {
                if productos.isEmpty {
                    ContentUnavailableView("Sin productos", systemImage: "shippingbox",
                                           description: Text(sesion.esSupervisor
                                                             ? "Pulsa + para registrar el primero."
                                                             : "El supervisor aún no registra productos."))
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar producto o categoría")
            .navigationTitle("Productos")
            .conAvatar()
            .toolbar {
                // ① Boton + solo para el supervisor
                if sesion.esSupervisor {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            mostrarNuevo = true
                        } label: {
                            Label("Nuevo producto", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevo) {
                ProductoFormView(producto: nil)
            }
            .sheet(item: $productoAEditar) { producto in
                ProductoFormView(producto: producto)
            }
            .alert("No se puede borrar",
                   isPresented: Binding(get: { mensajeBorrado != nil },
                                        set: { if !$0 { mensajeBorrado = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(mensajeBorrado ?? "")
            }
        }
    }

    /// Borrado con regla .deny: si el producto tiene compras se bloquea y se avisa
    private func borrar(offsets: IndexSet) {
        for index in offsets {
            let producto = productosFiltrados[index]
            if !producto.compras.isEmpty {
                mensajeBorrado = "\(producto.nombre) tiene \(producto.compras.count) compra(s) registradas."
                return
            }
            modelContext.delete(producto)
        }
        try? modelContext.save()
    }
}

/// ③ Fila con costo promedio y stock en color
struct FilaProducto: View {
    let producto: Producto

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(producto.nombre)
                    .font(.headline)
                Text(producto.categoria)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Costo prom. \(producto.costoPromedio.soles)")
                    .font(.subheadline)
                    .monospacedDigit()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                InsigniaStock(stock: producto.stock)
                Text(producto.valorInventario.soles)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 2)
    }
}

/// Stock en color: verde mas de 10, ambar de 6 a 10, rojo 5 o menos
struct InsigniaStock: View {
    let stock: Int

    static func color(para stock: Int) -> Color {
        if stock > 10 { return .green }
        if stock >= 6 { return .orange }
        return .red
    }

    var body: some View {
        Text("Stock \(stock)")
            .font(.caption.bold())
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(Self.color(para: stock))
            .background(Self.color(para: stock).opacity(0.15), in: Capsule())
    }
}
