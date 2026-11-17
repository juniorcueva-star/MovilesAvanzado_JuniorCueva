//
//  NuevaCompraView.swift
//  Compras
//
//  B5 · Nueva compra (Comprador).
//  Total menor a S/ 5,000: queda Aprobada al instante.
//  Desde S/ 5,000: se envia a aprobacion del supervisor.
//

import SwiftUI
import SwiftData

struct NuevaCompraView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidad = 1
    @State private var costoUnitario = 0.0
    @State private var alCredito = false
    @State private var resultado: String?
    @State private var mensajeError: String?

    private var calculo: CalculoCompra {
        CalculoCompra(cantidad: cantidad, costoUnitario: costoUnitario)
    }

    private var puedeRegistrar: Bool {
        proveedor != nil && producto != nil && cantidad > 0 && costoUnitario > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                // ① Comprador de la sesion (automatico)
                if let usuario = sesion.usuario {
                    Section {
                        HStack(spacing: 12) {
                            AvatarCirculo(iniciales: usuario.iniciales, tamano: 40)
                            VStack(alignment: .leading) {
                                Text(usuario.nombre).font(.headline)
                                Text("Comprador de la sesión").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Compra") {
                    // ② Proveedor
                    Picker("Proveedor", selection: $proveedor) {
                        Text("Elegir").tag(nil as Proveedor?)
                        ForEach(proveedores) { proveedor in
                            Text(proveedor.nombre).tag(proveedor as Proveedor?)
                        }
                    }

                    // ③ Producto
                    Picker("Producto", selection: $producto) {
                        Text("Elegir").tag(nil as Producto?)
                        ForEach(productos) { producto in
                            Text(producto.nombre).tag(producto as Producto?)
                        }
                    }
                    if let producto {
                        Text("Stock \(producto.stock) · costo prom. \(producto.costoPromedio.soles)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    // ④ Cantidad
                    Stepper("Cantidad: \(cantidad)", value: $cantidad, in: 1...10_000)

                    HStack {
                        Text("Costo unitario S/")
                        TextField("0.00", value: $costoUnitario, format: .number.precision(.fractionLength(2)))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                // ⑤ Contado o Credito 30 dias
                Section("Forma de pago") {
                    Picker("Pago", selection: $alCredito) {
                        Text("Contado").tag(false)
                        Text("Crédito 30 días").tag(true)
                    }
                    .pickerStyle(.segmented)
                    if alCredito {
                        Text("Vence el \(ReglasCompra.fechaVencimiento(desde: .now, alCredito: true).corta)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Resumen") {
                    FilaMonto(titulo: "Subtotal", monto: calculo.subtotal)
                    FilaMonto(titulo: "IGV 18 % (crédito fiscal)", monto: calculo.igv)
                    FilaMonto(titulo: "Total", monto: calculo.total, destacado: true)

                    // ⑥ Aviso cuando el total llega a S/ 5,000
                    if calculo.requiereAprobacion {
                        Label("Desde \(ReglasCompra.limiteAprobacion.soles) la compra necesita aprobación del supervisor.",
                              systemImage: "exclamationmark.shield.fill")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                    }
                }

                if let mensajeError {
                    Section {
                        Text(mensajeError).foregroundStyle(.red)
                    }
                }

                // ⑦ Enviar a aprobacion o Registrar compra
                Section {
                    Button {
                        registrar()
                    } label: {
                        Label(calculo.requiereAprobacion ? "Enviar a aprobación" : "Registrar compra",
                              systemImage: calculo.requiereAprobacion ? "paperplane.fill" : "checkmark.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(!puedeRegistrar)
                }
            }
            .navigationTitle("Nueva compra")
            .conAvatar()
            .onChange(of: producto) { _, nuevo in
                // Sugerimos el costo promedio actual como costo unitario
                if let nuevo { costoUnitario = nuevo.costoPromedio }
            }
            .alert("Compra registrada",
                   isPresented: Binding(get: { resultado != nil },
                                        set: { if !$0 { resultado = nil } })) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(resultado ?? "")
            }
        }
    }

    private func registrar() {
        guard let usuario = sesion.usuario else { return }
        do {
            let compra = try ServicioCompras.registrar(cantidad: cantidad,
                                                       costoUnitario: costoUnitario,
                                                       alCredito: alCredito,
                                                       comprador: usuario,
                                                       proveedor: proveedor,
                                                       producto: producto,
                                                       en: modelContext)
            mensajeError = nil
            if compra.estaPendiente {
                resultado = "Total \(compra.total.soles). Quedó Pendiente de aprobación del supervisor."
            } else {
                let pago = compra.alCredito ? "Por pagar, vence el \(compra.vence.corta)." : "Pagada al contado."
                resultado = "Total \(compra.total.soles). Quedó Aprobada. \(pago)"
            }
            // Limpiar el formulario
            cantidad = 1
            producto = nil
            costoUnitario = 0
            alCredito = false
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}

/// Fila de resumen: titulo a la izquierda y monto a la derecha
struct FilaMonto: View {
    let titulo: String
    let monto: Double
    var destacado = false

    var body: some View {
        HStack {
            Text(titulo)
            Spacer()
            Text(monto.soles)
                .monospacedDigit()
                .fontWeight(destacado ? .bold : .regular)
        }
        .font(destacado ? .headline : .body)
    }
}
