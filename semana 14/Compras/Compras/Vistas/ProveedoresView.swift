//
//  ProveedoresView.swift
//  Compras
//
//  B4 · Proveedores: insignia "por pagar" o "Al dia" y total comprado.
//  Los valores se calculan desde las compras del proveedor (relacion proveedor.compras).
//

import SwiftUI
import SwiftData

struct ProveedoresView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var proveedorAEditar: Proveedor?
    @State private var mensajeBorrado: String?

    private var proveedoresFiltrados: [Proveedor] {
        if busqueda.isEmpty { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) || $0.ruc.contains(busqueda)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(proveedoresFiltrados) { proveedor in
                    FilaProveedor(proveedor: proveedor)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if sesion.esSupervisor { proveedorAEditar = proveedor }
                        }
                }
                .onDelete(perform: sesion.esSupervisor ? borrar : nil)
            }
            .overlay {
                if proveedores.isEmpty {
                    ContentUnavailableView("Sin proveedores", systemImage: "building.2",
                                           description: Text(sesion.esSupervisor
                                                             ? "Pulsa + para registrar el primero."
                                                             : "El supervisor aún no registra proveedores."))
                }
            }
            .searchable(text: $busqueda, prompt: "Buscar por nombre o RUC")
            .navigationTitle("Proveedores")
            .conAvatar()
            .toolbar {
                // ① Boton + solo supervisor
                if sesion.esSupervisor {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            mostrarNuevo = true
                        } label: {
                            Label("Nuevo proveedor", systemImage: "plus")
                        }
                    }
                }
            }
            .sheet(isPresented: $mostrarNuevo) {
                ProveedorFormView(proveedor: nil)
            }
            .sheet(item: $proveedorAEditar) { proveedor in
                ProveedorFormView(proveedor: proveedor)
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

    /// Regla .deny: no se borra un proveedor con compras
    private func borrar(offsets: IndexSet) {
        for index in offsets {
            let proveedor = proveedoresFiltrados[index]
            if !proveedor.compras.isEmpty {
                mensajeBorrado = "\(proveedor.nombre) tiene \(proveedor.compras.count) compra(s) registradas."
                return
            }
            modelContext.delete(proveedor)
        }
        try? modelContext.save()
    }
}

/// ② Fila con insignia y total comprado · ③ valores calculados desde sus compras
struct FilaProveedor: View {
    let proveedor: Proveedor

    /// Total comprado: solo compras aprobadas
    private var totalComprado: Double {
        proveedor.compras.filter { $0.estaAprobada }.reduce(0) { $0 + $1.total }
    }

    /// Deuda: compras aprobadas al credito sin pagar
    private var porPagar: Double {
        proveedor.compras.filter { $0.esPorPagar }.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(proveedor.nombre)
                    .font(.headline)
                Text("RUC \(proveedor.ruc)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Total comprado \(totalComprado.soles)")
                    .font(.subheadline)
                    .monospacedDigit()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                if porPagar > 0 {
                    Insignia(texto: "por pagar", color: .orange)
                    Text(porPagar.soles)
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .monospacedDigit()
                } else {
                    Insignia(texto: "Al día", color: .green)
                }
            }
        }
        .padding(.vertical, 2)
    }
}

/// Etiqueta pequena de color reutilizable
struct Insignia: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundStyle(color)
            .background(color.opacity(0.15), in: Capsule())
    }
}
