//
//  ProveedorFormView.swift
//  Compras
//
//  Crear o editar un proveedor (solo supervisor).
//

import SwiftUI
import SwiftData

struct ProveedorFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let proveedor: Proveedor?

    @State private var nombre: String
    @State private var ruc: String

    init(proveedor: Proveedor?) {
        self.proveedor = proveedor
        _nombre = State(initialValue: proveedor?.nombre ?? "")
        _ruc = State(initialValue: proveedor?.ruc ?? "")
    }

    /// RUC peruano: 11 digitos
    private var rucValido: Bool { ruc.count == 11 && ruc.allSatisfy(\.isNumber) }

    private var esValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && rucValido
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Razón social", text: $nombre)
                    TextField("RUC (11 dígitos)", text: $ruc)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Proveedor")
                } footer: {
                    if !ruc.isEmpty && !rucValido {
                        Text("El RUC debe tener 11 dígitos")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(proveedor == nil ? "Nuevo proveedor" : "Editar proveedor")
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
        if let proveedor {
            proveedor.nombre = nombreLimpio
            proveedor.ruc = ruc
        } else {
            modelContext.insert(Proveedor(nombre: nombreLimpio, ruc: ruc))
        }
        try? modelContext.save()
        dismiss()
    }
}
