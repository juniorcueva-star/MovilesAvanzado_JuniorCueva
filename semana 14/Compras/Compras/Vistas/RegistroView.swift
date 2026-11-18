//
//  RegistroView.swift
//  Compras
//
//  B2 · Crear cuenta
//

import SwiftUI
import SwiftData

struct RegistroView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(Sesion.self) private var sesion
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var usuario = ""
    @State private var clave = ""
    @State private var confirmacion = ""
    @State private var rol = Rol.comprador
    @State private var mensajeError: String?

    /// ③ Aviso en vivo si el usuario ya existe
    private var usuarioRepetido: Bool {
        !usuario.trimmingCharacters(in: .whitespaces).isEmpty
            && ServicioAuth.existeUsuario(usuario, en: modelContext)
    }

    private var claveCorta: Bool { !clave.isEmpty && clave.count < ServicioAuth.minimoClave }
    private var clavesDistintas: Bool { !confirmacion.isEmpty && clave != confirmacion }

    var body: some View {
        Form {
            Section("Datos personales") {
                // ② Nombre completo
                TextField("Nombre completo", text: $nombre)
                    .textContentType(.name)

                // ③ Usuario unico
                TextField("Usuario", text: $usuario)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                if usuarioRepetido {
                    Label("Ese usuario ya existe", systemImage: "xmark.circle.fill")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            // ④ Clave (minimo 6) y confirmacion
            Section {
                CampoClave(titulo: "Clave", texto: $clave)
                CampoClave(titulo: "Confirmar clave", texto: $confirmacion)
                if claveCorta {
                    Text("Mínimo \(ServicioAuth.minimoClave) caracteres")
                        .font(.footnote)
                        .foregroundStyle(.orange)
                }
                if clavesDistintas {
                    Text("Las claves no coinciden")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            } header: {
                Text("Clave")
            }

            // ⑤ Rol: Comprador o Supervisor
            Section("Rol") {
                Picker("Rol", selection: $rol) {
                    ForEach(Rol.todos, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
            }

            if let mensajeError {
                Section {
                    Label(mensajeError, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }
            }

            // ⑥ Registrarme (entra directo a la app)
            Section {
                Button {
                    registrarme()
                } label: {
                    Text("Registrarme")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .disabled(nombre.isEmpty || usuario.isEmpty || clave.isEmpty || confirmacion.isEmpty)
            }
        }
        // ① Titulo y volver al login (boton atras del NavigationStack)
        .navigationTitle("Crear cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Login") { dismiss() }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func registrarme() {
        do {
            let nuevo = try ServicioAuth.registrar(nombre: nombre, usuario: usuario, clave: clave,
                                                   confirmacion: confirmacion, rol: rol,
                                                   en: modelContext)
            mensajeError = nil
            sesion.iniciar(nuevo)   // Entra directo a la app
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        RegistroView()
    }
    .environment(Sesion())
    .modelContainer(ModelContainerProvider.enMemoria())
}
