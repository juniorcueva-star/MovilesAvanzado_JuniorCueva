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

    /// RUC peruano: 11 digitos y empieza con 10 o 20 (regla en ReglasCompra)
    private var rucValido: Bool { ReglasCompra.rucValido(ruc) }

    /// RUC repetido: otro proveedor ya lo tiene (#Predicate, sin contar al que se edita)
    private var rucRepetido: Bool {
        let buscado = ruc
        let descriptor = FetchDescriptor<Proveedor>(predicate: #Predicate { $0.ruc == buscado })
        let encontrados = (try? modelContext.fetch(descriptor)) ?? []
        return encontrados.contains { $0.persistentModelID != proveedor?.persistentModelID }
    }

    private var esValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty && rucValido && !rucRepetido
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
                        Text("El RUC debe tener 11 dígitos y empezar con 10 o 20")
                            .foregroundStyle(.red)
                    } else if rucRepetido {
                        Text("Ese RUC ya está registrado")
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
