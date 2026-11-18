//
//  TodasComprasView.swift
//  Compras
//
//  Historial del supervisor: ve TODAS las compras de todos los compradores
//  (contado, credito, pendientes, aprobadas y rechazadas). Se abre desde el Resumen.
//  El filtro por estado se hace con #Predicate y se busca por proveedor o comprador.
//

import SwiftUI
import SwiftData

enum FiltroHistorial: String, CaseIterable, Identifiable {
    case todas = "Todas"
    case pendientes = "Pendientes"
    case aprobadas = "Aprobadas"
    case rechazadas = "Rechazadas"

    var id: String { rawValue }

    /// Estado que se busca en la base de datos (nil = todas)
    var estado: String? {
        switch self {
        case .todas: return nil
        case .pendientes: return EstadoCompra.pendiente
        case .aprobadas: return EstadoCompra.aprobada
        case .rechazadas: return EstadoCompra.rechazada
        }
    }
}

struct TodasComprasView: View {
    @State private var filtro = FiltroHistorial.todas
    @State private var busqueda = ""

    var body: some View {
        ListaTodasCompras(filtro: filtro, busqueda: busqueda)
            .safeAreaInset(edge: .top) {
                Picker("Filtro", selection: $filtro) {
                    ForEach(FiltroHistorial.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.bar)
            }
            .searchable(text: $busqueda, prompt: "Buscar por proveedor o comprador")
            .navigationTitle("Todas las compras")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ListaTodasCompras: View {
    @Query private var compras: [Compra]
    let busqueda: String

    init(filtro: FiltroHistorial, busqueda: String) {
        self.busqueda = busqueda
        if let estado = filtro.estado {
            // El valor se guarda en un let antes de usarlo en #Predicate
            _compras = Query(filter: #Predicate<Compra> { $0.estado == estado },
                             sort: \Compra.fecha, order: .reverse)
        } else {
            _compras = Query(sort: \Compra.fecha, order: .reverse)
        }
    }

    /// Busqueda por nombre del proveedor o del comprador
    private var filtradas: [Compra] {
        if busqueda.isEmpty { return compras }
        return compras.filter {
            ($0.proveedor?.nombre ?? "").localizedCaseInsensitiveContains(busqueda)
                || ($0.comprador?.nombre ?? "").localizedCaseInsensitiveContains(busqueda)
        }
    }

    private var importe: Double {
        filtradas.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        List {
            Section {
                ForEach(filtradas) { compra in
                    FilaCompra(compra: compra, mostrarComprador: true)
                }
            } header: {
                Text("\(filtradas.count) compra(s) · \(importe.soles)")
            }
        }
        .overlay {
            if filtradas.isEmpty {
                ContentUnavailableView("Sin compras", systemImage: "cart",
                                       description: Text("Aquí aparecen las compras de todos los compradores."))
            }
        }
    }
}
