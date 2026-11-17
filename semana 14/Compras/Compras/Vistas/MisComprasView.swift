//
//  MisComprasView.swift
//  Compras
//
//  B6 · Mis compras (Comprador): Todas / Pendientes / Rechazadas.
//  El filtro por estado se hace con #Predicate en @Query y el comprador solo ve las suyas.
//

import SwiftUI
import SwiftData

enum FiltroEstado: String, CaseIterable, Identifiable {
    case todas = "Todas"
    case pendientes = "Pendientes"
    case rechazadas = "Rechazadas"

    var id: String { rawValue }
}

struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion

    @State private var filtro = FiltroEstado.todas
    @State private var busqueda = ""

    var body: some View {
        NavigationStack {
            ListaMisCompras(filtro: filtro, busqueda: busqueda, usuario: sesion.usuario)
                // ① Segmented Todas / Pendientes / Rechazadas
                .safeAreaInset(edge: .top) {
                    Picker("Filtro", selection: $filtro) {
                        ForEach(FiltroEstado.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.bar)
                }
                .searchable(text: $busqueda, prompt: "Buscar por proveedor")
                .navigationTitle("Mis compras")
                .conAvatar()
        }
    }
}

struct ListaMisCompras: View {
    @Query private var compras: [Compra]
    let busqueda: String
    let usuario: Usuario?

    init(filtro: FiltroEstado, busqueda: String, usuario: Usuario?) {
        self.busqueda = busqueda
        self.usuario = usuario

        // Los valores se guardan en un let antes de usarlos en #Predicate
        let pendiente = EstadoCompra.pendiente
        let rechazada = EstadoCompra.rechazada

        switch filtro {
        case .todas:
            _compras = Query(sort: \Compra.fecha, order: .reverse)
        case .pendientes:
            _compras = Query(filter: #Predicate<Compra> { $0.estado == pendiente },
                             sort: \Compra.fecha, order: .reverse)
        case .rechazadas:
            _compras = Query(filter: #Predicate<Compra> { $0.estado == rechazada },
                             sort: \Compra.fecha, order: .reverse)
        }
    }

    /// ④ El comprador solo ve las suyas (relacion compra.comprador) y se busca por proveedor
    private var misCompras: [Compra] {
        guard let usuario else { return [] }
        return compras.filter { compra in
            compra.comprador?.persistentModelID == usuario.persistentModelID
                && (busqueda.isEmpty
                    || (compra.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(busqueda))
        }
    }

    var body: some View {
        List {
            // ② Compra pendiente · ③ Compra rechazada con su motivo
            ForEach(misCompras) { compra in
                FilaCompra(compra: compra)
            }
            // Sin swipe de Pagar: el comprador no puede pagar
        }
        .overlay {
            if misCompras.isEmpty {
                ContentUnavailableView("Sin compras", systemImage: "cart",
                                       description: Text("Registra una compra en la pestaña Compra."))
            }
        }
    }
}
