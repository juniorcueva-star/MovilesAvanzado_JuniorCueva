//
//  PorPagarView.swift
//  Compras
//
//  B8 · Cuentas por pagar (Supervisor): Pendientes / Vencidas / Pagadas.
//  Solo compras al credito y aprobadas. Filtros hechos con #Predicate.
//

import SwiftUI
import SwiftData

enum FiltroPago: String, CaseIterable, Identifiable {
    case pendientes = "Pendientes"
    case vencidas = "Vencidas"
    case pagadas = "Pagadas"

    var id: String { rawValue }

    /// #Predicate segun el filtro. Los valores se guardan en let antes de usarlos.
    func predicado(hoy: Date) -> Predicate<Compra> {
        let aprobada = EstadoCompra.aprobada
        switch self {
        case .pendientes:
            return #Predicate<Compra> {
                $0.estado == aprobada && $0.alCredito == true && $0.pagada == false && $0.vence >= hoy
            }
        case .vencidas:
            return #Predicate<Compra> {
                $0.estado == aprobada && $0.alCredito == true && $0.pagada == false && $0.vence < hoy
            }
        case .pagadas:
            return #Predicate<Compra> {
                $0.estado == aprobada && $0.alCredito == true && $0.pagada == true
            }
        }
    }
}

struct PorPagarView: View {
    // Todas las cuentas por pagar (pendientes + vencidas) para el total
    @Query(filter: #Predicate<Compra> {
        $0.estado == "Aprobada" && $0.alCredito == true && $0.pagada == false
    })
    private var deudas: [Compra]

    @State private var filtro = FiltroPago.pendientes
    @State private var busqueda = ""

    /// ⑤ Total por pagar
    private var totalPorPagar: Double {
        deudas.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        NavigationStack {
            ListaPorPagar(filtro: filtro, busqueda: busqueda)
                .safeAreaInset(edge: .top) {
                    // ① Segmented Pendientes / Vencidas / Pagadas
                    Picker("Filtro", selection: $filtro) {
                        ForEach(FiltroPago.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.bar)
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Label("Total por pagar", systemImage: "creditcard")
                        Spacer()
                        Text(totalPorPagar.soles)
                            .font(.title3.bold())
                            .monospacedDigit()
                    }
                    .padding()
                    .background(.bar)
                }
                .searchable(text: $busqueda, prompt: "Buscar por proveedor")
                .navigationTitle("Por pagar")
                .conAvatar()
        }
    }
}

struct ListaPorPagar: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query private var compras: [Compra]
    let filtro: FiltroPago
    let busqueda: String

    @State private var mensaje: String?

    init(filtro: FiltroPago, busqueda: String) {
        self.filtro = filtro
        self.busqueda = busqueda
        _compras = Query(filter: filtro.predicado(hoy: .now), sort: \Compra.vence)
    }

    /// Busqueda por proveedor
    private var filtradas: [Compra] {
        if busqueda.isEmpty { return compras }
        return compras.filter { ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(busqueda) }
    }

    var body: some View {
        List {
            ForEach(filtradas) { compra in
                // ② Compra a credito · ③ Etiqueta VENCIDA (dentro de FilaCompra)
                FilaCompra(compra: compra, mostrarComprador: true)
                    .swipeActions(edge: .trailing) {
                        // ④ Deslizar Pagar (solo supervisor)
                        if sesion.esSupervisor && !compra.pagada {
                            Button {
                                pagar(compra)
                            } label: {
                                Label("Pagar", systemImage: "checkmark.circle")
                            }
                            .tint(.green)
                        }
                    }
            }
        }
        .overlay {
            if filtradas.isEmpty {
                ContentUnavailableView("Sin compras \(filtro.rawValue.lowercased())",
                                       systemImage: "creditcard",
                                       description: Text("Aquí aparecen las compras al crédito aprobadas."))
            }
        }
        .alert("Pagar",
               isPresented: Binding(get: { mensaje != nil },
                                    set: { if !$0 { mensaje = nil } })) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(mensaje ?? "")
        }
    }

    private func pagar(_ compra: Compra) {
        guard let usuario = sesion.usuario else { return }
        do {
            try ServicioCompras.pagar(compra, por: usuario, en: modelContext)
        } catch {
            mensaje = error.localizedDescription
        }
    }
}
