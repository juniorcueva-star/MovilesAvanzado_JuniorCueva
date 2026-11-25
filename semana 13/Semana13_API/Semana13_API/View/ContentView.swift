//
//  ContentView.swift
//  Semana13_API
//
//  Created by Junior Cueva Fabian on 24/11/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()

    var body: some View {
        NavigationStack {
            List {
                // Tarjeta de resumen
                HeaderCard(total: viewModel.users.count)
                    .cleanRow(top: 4, bottom: 10)

                // Campo de búsqueda
                SearchBar(text: $viewModel.searchText)
                    .cleanRow(top: 4, bottom: 10)

                // Lista de usuarios filtrados
                usersSection
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Usuarios")
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }

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
            ContentUnavailableView.search(text: viewModel.searchText)
                .cleanRow()
        } else {
            ForEach(viewModel.filteredUsers) { user in
                UserRowView(user: user)
                    .cleanRow()
            }
        }
    }
}

#Preview {
    ContentView()
}
