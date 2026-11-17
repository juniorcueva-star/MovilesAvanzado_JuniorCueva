//
//  ContentView.swift
//  Compras
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "cart.fill")
                .font(.system(size: 60))
                .foregroundStyle(.tint)
            Text("Compras")
                .font(.largeTitle.bold())
            Text("Distribuidora · Grupo B")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
