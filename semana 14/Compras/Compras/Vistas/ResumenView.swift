//
//  ResumenView.swift
//  Compras
//
//  B9 · Resumen del supervisor: inventario, credito fiscal, por pagar,
//  compras por aprobar y total comprado por proveedor con barras.
//  Valor agregado: alerta de stock bajo y enlace a Todas las compras.
//

import SwiftUI
import SwiftData
import Charts

struct ResumenView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query private var productos: [Producto]
    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var mensaje: String?

    // MARK: - Indicadores (se calculan, no se guardan)

    /// ② Valor del inventario = suma de stock x costo promedio
    private var valorInventario: Double {
        productos.reduce(0) { $0 + $1.valorInventario }
    }

    private var aprobadas: [Compra] { compras.filter { $0.estaAprobada } }

    /// ③ Credito fiscal: IGV de las compras aprobadas
    private var creditoFiscal: Double {
        aprobadas.reduce(0) { $0 + $1.igv }
    }

    /// Credito fiscal del mes actual (para el cierre de IGV con el grupo A)
    private var creditoFiscalMes: Double {
        let calendario = Calendar.current
        return aprobadas
            .filter { calendario.isDate($0.fecha, equalTo: .now, toGranularity: .month) }
            .reduce(0) { $0 + $1.igv }
    }

    private var porPagar: [Compra] { compras.filter { $0.esPorPagar } }
    private var totalPorPagar: Double { porPagar.reduce(0) { $0 + $1.total } }
    private var vencidas: Int { porPagar.filter { $0.estaVencida() }.count }

    /// ④ Compras por aprobar
    private var pendientes: [Compra] { compras.filter { $0.estaPendiente } }
    private var importePendiente: Double { pendientes.reduce(0) { $0 + $1.total } }

    /// ⑤ Total comprado por proveedor (solo aprobadas)
    private var totalPorProveedor: [TotalProveedor] {
        proveedores
            .map { proveedor in
                TotalProveedor(nombre: proveedor.nombre,
                               total: proveedor.compras.filter { $0.estaAprobada }.reduce(0) { $0 + $1.total })
            }
            .filter { $0.total > 0 }
            .sorted { $0.total > $1.total }
    }

    /// Productos con stock bajo (5 o menos), el de menor stock primero
    private var productosStockBajo: [Producto] {
        productos.filter { $0.tieneStockBajo }.sorted { $0.stock < $1.stock }
    }

    private let columnas = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // ① Saludo con la sesion
                    if let usuario = sesion.usuario {
                        HStack(spacing: 12) {
                            AvatarCirculo(iniciales: usuario.iniciales, tamano: 48)
                            VStack(alignment: .leading) {
                                Text("Hola, \(usuario.nombre)").font(.title3.bold())
                                Text(usuario.rol).foregroundStyle(.secondary)
                            }
                        }
                    }

                    LazyVGrid(columns: columnas, spacing: 12) {
                        TarjetaIndicador(titulo: "Valor del inventario", valor: valorInventario.soles,
                                         detalle: "\(productos.count) productos",
                                         icono: "shippingbox.fill", color: .teal)
                        TarjetaIndicador(titulo: "Crédito fiscal (IGV)", valor: creditoFiscal.soles,
                                         detalle: "Este mes \(creditoFiscalMes.soles)",
                                         icono: "percent", color: .indigo)
                        TarjetaIndicador(titulo: "Por pagar", valor: totalPorPagar.soles,
                                         detalle: "\(porPagar.count) compras · \(vencidas) vencidas",
                                         icono: "creditcard.fill", color: vencidas > 0 ? .red : .orange)
                        TarjetaIndicador(titulo: "Por aprobar", valor: importePendiente.soles,
                                         detalle: "\(pendientes.count) compras",
                                         icono: "checkmark.seal.fill", color: .orange)
                    }

                    // Valor agregado: alerta de stock bajo
                    if !productosStockBajo.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Stock bajo (\(ReglasCompra.stockMinimo) o menos)",
                                  systemImage: "exclamationmark.triangle.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                            ForEach(productosStockBajo) { producto in
                                HStack {
                                    Text(producto.nombre)
                                    Spacer()
                                    InsigniaStock(stock: producto.stock)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                    }

                    // Valor agregado: historial con todas las compras ("ver todo")
                    NavigationLink {
                        TodasComprasView()
                    } label: {
                        HStack {
                            Label("Todas las compras", systemImage: "list.bullet.rectangle.portrait")
                                .font(.headline)
                            Spacer()
                            Text("\(compras.count)")
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.plain)

                    // ⑤ Total comprado por proveedor con barras
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total comprado por proveedor")
                            .font(.headline)
                        if totalPorProveedor.isEmpty {
                            Text("Aún no hay compras aprobadas.")
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 80)
                        } else {
                            Chart(totalPorProveedor) { item in
                                BarMark(x: .value("Total", item.total),
                                        y: .value("Proveedor", item.nombre))
                                    .foregroundStyle(Color.accentColor.gradient)
                                    .annotation(position: .trailing) {
                                        Text(item.total.soles)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                            }
                            .chartXAxis(.hidden)
                            .frame(height: CGFloat(totalPorProveedor.count) * 48 + 20)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumen")
            .conAvatar()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            cargarEjemplo()
                        } label: {
                            Label("Cargar datos de ejemplo", systemImage: "tray.and.arrow.down")
                        }
                        .disabled(!productos.isEmpty)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Datos de ejemplo",
                   isPresented: Binding(get: { mensaje != nil },
                                        set: { if !$0 { mensaje = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensaje ?? "")
            }
        }
    }

    private func cargarEjemplo() {
        guard let usuario = sesion.usuario else { return }
        do {
            try DatosEjemplo.cargar(usuario: usuario, en: modelContext)
            mensaje = "Se cargaron 2 proveedores, 3 productos (Laptop con stock 40 y costo 110.00) y una compra al crédito vencida."
        } catch {
            mensaje = error.localizedDescription
        }
    }
}

/// Dato para el grafico de barras
struct TotalProveedor: Identifiable {
    let nombre: String
    let total: Double
    var id: String { nombre }
}

struct TarjetaIndicador: View {
    let titulo: String
    let valor: String
    let detalle: String
    let icono: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icono)
                .foregroundStyle(color)
                .font(.title3)
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(valor)
                .font(.headline)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            Text(detalle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}
