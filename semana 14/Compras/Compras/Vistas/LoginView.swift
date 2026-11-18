//
//  LoginView.swift
//  Compras
//
//  B1 · Inicio de sesion
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion

    @State private var usuario = ""
    @State private var clave = ""
    @State private var mensajeError: String?
    @State private var mostrarRegistro = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // ① Logo y nombre
                    VStack(spacing: 8) {
                        Image(systemName: "shippingbox.and.arrow.backward.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 100)
                            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 24))
                        Text("Compras")
                            .font(.largeTitle.bold())
                        Text("Distribuidora · Proveedores y costos")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)

                    VStack(spacing: 14) {
                        // ② Usuario
                        TextField("Usuario", text: $usuario)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.username)
                            .campoLogin(icono: "person")

                        // ③ Clave oculta
                        // Empieza oculta; el ojo la muestra (CampoClave)
                        CampoClave(titulo: "Clave", texto: $clave)
                            .textContentType(.password)
                            .campoLogin(icono: "lock")

                        // ④ Mensaje de error generico
                        if let mensajeError {
                            Label(mensajeError, systemImage: "exclamationmark.triangle.fill")
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    // ⑤ Ingresar
                    Button {
                        ingresar()
                    } label: {
                        Text("Ingresar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(usuario.isEmpty || clave.isEmpty)

                    // ⑥ Ir a Crear cuenta
                    Button("¿No tienes cuenta? Crear cuenta") {
                        mostrarRegistro = true
                    }
                    .font(.callout)
                }
                .padding(24)
            }
            .navigationDestination(isPresented: $mostrarRegistro) {
                RegistroView()
            }
        }
    }

    private func ingresar() {
        do {
            let encontrado = try ServicioAuth.login(usuario: usuario, clave: clave, en: modelContext)
            mensajeError = nil
            clave = ""
            sesion.iniciar(encontrado)
        } catch {
            // Siempre el mismo mensaje: no se dice si fallo el usuario o la clave
            mensajeError = ErrorAuth.credencialesIncorrectas.errorDescription
        }
    }
}

/// Estilo comun para los campos del login y registro
struct CampoLogin: ViewModifier {
    let icono: String

    func body(content: Content) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icono)
                .foregroundStyle(.secondary)
                .frame(width: 22)
            content
        }
        .padding(14)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func campoLogin(icono: String) -> some View {
        modifier(CampoLogin(icono: icono))
    }
}
