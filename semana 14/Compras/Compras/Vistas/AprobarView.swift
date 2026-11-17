//
//  AprobarView.swift
//  Compras
//
//  B7 · Aprobar (Supervisor): compras desde S/ 5,000 que esperan aprobacion.
//  Muestra la vista previa del efecto: stock y costo promedio antes y despues.
//

import SwiftUI
import SwiftData

struct AprobarView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    // Solo compras pendientes (#Predicate)
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" },
           sort: \Compra.fecha)
    private var pendientes: [Compra]

    @State private var compraARechazar: Compra?
    @State private var mensaje: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(pendientes) { compra in
                        TarjetaAprobacion(compra: compra,
                                          aprobar: { aprobar(compra) },
                                          rechazar: { compraARechazar = compra })
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .overlay {
                if pendientes.isEmpty {
                    ContentUnavailableView("Nada por aprobar", systemImage: "checkmark.seal",
                                           description: Text("Las compras desde \(ReglasCompra.limiteAprobacion.soles) aparecen aquí."))
                }
            }
            .navigationTitle("Aprobar")
            .conAvatar()
            .sheet(item: $compraARechazar) { compra in
                RechazoView(compra: compra)
            }
            .alert("Aprobar",
                   isPresented: Binding(get: { mensaje != nil },
                                        set: { if !$0 { mensaje = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensaje ?? "")
            }
        }
    }

    private func aprobar(_ compra: Compra) {
        guard let usuario = sesion.usuario else { return }
        do {
            try ServicioCompras.aprobar(compra, por: usuario, en: modelContext)
        } catch {
            mensaje = error.localizedDescription
        }
    }
}

/// ② Tarjeta de la compra pendiente con quien la solicito
struct TarjetaAprobacion: View {
    let compra: Compra
    let aprobar: () -> Void
    let rechazar: () -> Void

    var body: some View {
        let previa = ServicioCompras.vistaPrevia(de: compra)

        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                AvatarCirculo(iniciales: compra.comprador?.iniciales ?? "?", tamano: 36)
                VStack(alignment: .leading) {
                    Text(compra.comprador?.nombre ?? "—").font(.subheadline.bold())
                    Text("Solicitó el \(compra.fecha.corta)").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Insignia(texto: "Pendiente", color: .orange)
            }

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text(compra.producto?.nombre ?? "Producto").font(.headline)
                Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.alCredito ? "Crédito 30 días" : "Contado")")
                    .font(.subheadline).foregroundStyle(.secondary)
                Text("\(compra.cantidad) × \(compra.costoUnitario.soles)")
                    .font(.subheadline)
            }

            VStack(spacing: 4) {
                FilaMonto(titulo: "Subtotal", monto: compra.subtotal)
                FilaMonto(titulo: "IGV", monto: compra.igv)
                FilaMonto(titulo: "Total", monto: compra.total, destacado: true)
            }
            .font(.subheadline)

            // ③ Vista previa del efecto
            VStack(alignment: .leading, spacing: 6) {
                Text("Si se aprueba")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                FilaAntesDespues(titulo: "Stock",
                                 antes: "\(previa.stockAntes)",
                                 despues: "\(previa.stockDespues)")
                FilaAntesDespues(titulo: "Costo promedio",
                                 antes: previa.costoAntes.soles,
                                 despues: previa.costoDespues.soles)
            }
            .padding(10)
            .background(Color.accentColor.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))

            // ④ Rechazar (pide motivo) o Aprobar
            HStack(spacing: 12) {
                Button(role: .destructive, action: rechazar) {
                    Label("Rechazar", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: aprobar) {
                    Label("Aprobar", systemImage: "checkmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

struct FilaAntesDespues: View {
    let titulo: String
    let antes: String
    let despues: String

    var body: some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(antes).foregroundStyle(.secondary)
            Image(systemName: "arrow.right").font(.caption)
            Text(despues).bold()
        }
        .font(.subheadline)
        .monospacedDigit()
    }
}

/// Hoja para rechazar: el motivo es obligatorio
struct RechazoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion
    @Environment(\.dismiss) private var dismiss

    let compra: Compra
    @State private var motivo = ""
    @State private var mensajeError: String?

    private var motivoVacio: Bool {
        motivo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Compra") {
                    Text("\(compra.producto?.nombre ?? "Producto") · \(compra.total.soles)")
                    Text("Solicitó \(compra.comprador?.nombre ?? "—")")
                        .foregroundStyle(.secondary)
                }
                Section {
                    TextField("Escribe el motivo", text: $motivo, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Motivo del rechazo (obligatorio)")
                } footer: {
                    Text("Al rechazar no cambia el stock ni el costo promedio. El comprador verá este motivo.")
                }
                if let mensajeError {
                    Text(mensajeError).foregroundStyle(.red)
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .destructiveAction) {
                    Button("Rechazar", role: .destructive) { rechazar() }
                        .disabled(motivoVacio)   // Sin motivo no se puede
                }
            }
        }
    }

    private func rechazar() {
        guard let usuario = sesion.usuario else { return }
        do {
            try ServicioCompras.rechazar(compra, motivo: motivo, por: usuario, en: modelContext)
            dismiss()
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}
