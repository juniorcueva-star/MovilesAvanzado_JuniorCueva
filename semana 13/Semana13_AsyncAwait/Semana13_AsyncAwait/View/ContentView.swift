//
//  ContentView.swift
//  Semana13_AsyncAwait
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    @State private var showingForm = false
    @State private var editingUser: User? = nil

    var body: some View {
        NavigationStack {
            List {
                headerSection
                usersSection
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Usuarios")
            .safeAreaInset(edge: .bottom) {
                PrimaryButton(title: "Agregar Usuario", icon: "plus") {
                    editingUser = nil
                    showingForm = true
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            .refreshable {
                // Deslizar hacia abajo vuelve a pedir la lista a la API
                await viewModel.fetchUsers()
            }
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
            }
            .sheet(isPresented: $showingForm) {
                if let user = editingUser {
                    UserFormView(name: user.name, email: user.email, isEditing: true, avatarId: user.id) { name, email in
                        let updated = User(id: user.id, name: name, email: email)
                        Task {
                            await viewModel.updateUser(user: updated)
                        }
                    }
                } else {
                    UserFormView(name: "", email: "", isEditing: false) { name, email in
                        Task {
                            await viewModel.createUser(name: name, email: email)
                        }
                    }
                }
            }
        }
    }

    // Tarjeta de resumen y buscador
    private var headerSection: some View {
        Section {
            HeaderCard(total: viewModel.users.count)
                .cleanRow(top: 4, bottom: 10)
            SearchBar(text: $viewModel.searchText)
                .cleanRow(top: 4, bottom: 10)
        }
    }

    // Lista de usuarios, carga o mensaje cuando no hay resultados
    @ViewBuilder
    private var usersSection: some View {
        if viewModel.isLoading && viewModel.users.isEmpty {
            HStack {
                Spacer()
                ProgressView("Cargando usuarios...")
                Spacer()
            }
            .padding(.top, 40)
            .cleanRow()
        } else if viewModel.filteredUsers.isEmpty {
            emptyState
                .cleanRow()
        } else {
            ForEach(viewModel.filteredUsers) { user in
                UserRowView(user: user)
                    .cleanRow()
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteUser(id: user.id)
                            }
                        } label: {
                            Label("Eliminar", systemImage: "trash")
                        }

                        Button {
                            editingUser = user
                            showingForm = true
                        } label: {
                            Label("Editar", systemImage: "pencil")
                        }.tint(.blue)
                    }
            }
        }
    }

    @ViewBuilder
    private var emptyState: some View {
        if viewModel.searchText.isEmpty {
            ContentUnavailableView("Sin usuarios",
                                   systemImage: "person.crop.circle.badge.questionmark",
                                   description: Text("Agrega un usuario con el botón de abajo."))
        } else {
            ContentUnavailableView.search(text: viewModel.searchText)
        }
    }
}

#Preview {
    ContentView()
}
