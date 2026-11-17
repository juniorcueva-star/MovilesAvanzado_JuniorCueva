//
//  ProductoFormView.swift
//  Compras
//
//  Crear o editar un producto (solo supervisor).
//

import SwiftUI
import SwiftData

struct ProductoFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let producto: Producto?     // nil = nuevo

    @State private var nombre = ""
    @State private var categoria = ""
    @State private var stock = 0
    @State private var costoPromedio = 0.0

    init(producto: Producto?) {
        self.producto = producto
        _nombre = State(initialValue: producto?.nombre ?? "")
        _categoria = State(initialValue: producto?.categoria ?? "")
        _stock = State(initialValue: producto?.stock ?? 0)
        _costoPromedio = State(initialValue: producto?.costoPromedio ?? 0)
    }

    private var esValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty
            && !categoria.trimmingCharacters(in: .whitespaces).isEmpty
            && stock >= 0 && costoPromedio >= 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Producto") {
                    TextField("Nombre", text: $nombre)
                    TextField("Categoría", text: $categoria)
                }
                Section {
                    Stepper("Stock: \(stock)", value: $stock, in: 0...100_000)
                    HStack {
                        Text("Costo promedio S/")
                        TextField("0.00", value: $costoPromedio, format: .number.precision(.fractionLength(2)))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                } header: {
                    Text("Inventario")
                } footer: {
                    Text("Valor del inventario: \((Double(stock) * costoPromedio).soles)")
                }
            }
            .navigationTitle(producto == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { guardar() }
                        .disabled(!esValido)
                }
            }
        }
    }

    private func guardar() {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespaces)
        let categoriaLimpia = categoria.trimmingCharacters(in: .whitespaces)
        if let producto {
            // UPDATE
            producto.nombre = nombreLimpio
            producto.categoria = categoriaLimpia
            producto.stock = stock
            producto.costoPromedio = ReglasCompra.redondear(costoPromedio)
        } else {
            // CREATE
            let nuevo = Producto(nombre: nombreLimpio, categoria: categoriaLimpia,
                                 stock: stock, costoPromedio: ReglasCompra.redondear(costoPromedio))
            modelContext.insert(nuevo)
        }
        try? modelContext.save()
        dismiss()
    }
}
