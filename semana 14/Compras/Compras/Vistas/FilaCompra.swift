//
//  FilaCompra.swift
//  Compras
//
//  Fila reutilizable para mostrar una compra en las listas.
//

import SwiftUI

struct FilaCompra: View {
    let compra: Compra
    var mostrarComprador = false

    private var colorEstado: Color {
        if compra.estaPendiente { return .orange }
        if compra.estaRechazada { return .red }
        return .green
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(compra.producto?.nombre ?? "Producto")
                    .font(.headline)
                Spacer()
                Text(compra.total.soles)
                    .font(.headline)
                    .monospacedDigit()
            }

            Text("\(compra.proveedor?.nombre ?? "Proveedor") · \(compra.cantidad) × \(compra.costoUnitario.soles)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if mostrarComprador {
                Label("Solicitó \(compra.comprador?.nombre ?? "—")", systemImage: "person")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                Insignia(texto: compra.estado, color: colorEstado)
                Insignia(texto: compra.alCredito ? "Crédito" : "Contado", color: .blue)
                if compra.estaAprobada && compra.alCredito {
                    if compra.pagada {
                        Insignia(texto: "Pagada", color: .green)
                    } else if compra.estaVencida() {
                        Insignia(texto: "VENCIDA", color: .red)
                    } else {
                        Insignia(texto: "Vence \(compra.vence.corta)", color: .orange)
                    }
                }
                Spacer()
                Text(compra.fecha.corta)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Compra rechazada con su motivo
            if compra.estaRechazada, let motivo = compra.motivoRechazo {
                Label("Motivo: \(motivo)", systemImage: "text.bubble")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, 4)
    }
}
