//
//  ContentView.swift
//  demostracion
// autor : junior cueva fabian 777
//
//  Created by Tecsup on 21/10/26.
//

import SwiftUI

struct ContentView: View {
    // datos de ingreso de usuarios
    @State private var nombre: String = ""
    @State private var precioTexto: String = ""
    @State private var descuentoTexto: String = ""
    
    // resultados a mostrar
    @State private var Subtotal: Double = 0
    @State private var igv:  Double = 0
    @State private var total:  Double = 0
    @State private var descuento: Double = 0
    
    // igv
    let tasaIGV = 0.18
    
    var body: some View {
        VStack (spacing:15){
            Text("venta producto")
                .font(Font.largeTitle)
                .bold()
            //entradas
            TextField("Nombre del producto" , text: $nombre)
                .textFieldStyle(.roundedBorder)
            TextField("Precio  S/. " , text: $precioTexto)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            TextField("Descuento S/.   " , text: $descuentoTexto)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            Button("calcular"){
                // llamar a las funcion del boton
                calcular()
            }
            
            Text("Producto : \(nombre)")
            Text("Descuento : \(descuento,specifier: "%.2f")")
            
        }
        
    }
    func calcular(){
        let precio = Double(precioTexto) ?? 0
        let porcentaje = Double(descuentoTexto) ?? 0
        descuento = (precio * (porcentaje / 100))
        Subtotal = precio - descuento
        igv = (Subtotal * tasaIGV)
        total = Subtotal + igv
        
        
        
    }
}

#Preview {
    ContentView()
}
