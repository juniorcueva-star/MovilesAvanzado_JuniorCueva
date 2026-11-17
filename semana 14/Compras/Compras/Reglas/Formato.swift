//
//  Formato.swift
//  Compras
//

import Foundation

extension Double {
    /// 1416 -> "S/ 1,416.00"
    var soles: String {
        "S/ " + numero2
    }

    /// 1416 -> "1,416.00"
    var numero2: String {
        formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "en_US")))
    }
}

extension Date {
    /// 17/11/2026
    var corta: String {
        formatted(.dateTime.day(.twoDigits).month(.twoDigits).year())
    }
}
