import Foundation

/// Modelo educativo para el régimen laboral privado general peruano.
/// El tiempo se ingresa ya depurado en meses y días computables del semestre.
struct CTSInput {
    let monthlySalary: Decimal
    let semesterGratification: Decimal
    let fullMonths: Int
    let additionalDays: Int
    let acquiredVacationDays: Int
    let takenVacationDays: Int
}

struct CTSResult {
    let computablePay: Decimal
    let monthlyPortion: Decimal
    let dailyPortion: Decimal
    let totalCTS: Decimal
    let remainingVacationDays: Int
}

enum CTSError: Error, LocalizedError {
    case invalidAmount
    case invalidPeriod
    case invalidVacation

    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Ingresa sueldo y gratificación válidos, sin valores negativos."
        case .invalidPeriod:
            return "Ingresa de 1 a 6 meses y de 0 a 29 días computables."
        case .invalidVacation:
            return "Los días gozados deben estar entre 0 y los días adquiridos."
        }
    }
}

enum CTSCalculator {
    static func calculate(_ input: CTSInput) throws -> CTSResult {
        guard input.monthlySalary >= 0, input.semesterGratification >= 0 else {
            throw CTSError.invalidAmount
        }
        guard (1...6).contains(input.fullMonths), (0...29).contains(input.additionalDays),
              input.fullMonths < 6 || input.additionalDays == 0 else {
            throw CTSError.invalidPeriod
        }
        guard (0...30).contains(input.acquiredVacationDays),
              (0...input.acquiredVacationDays).contains(input.takenVacationDays) else {
            throw CTSError.invalidVacation
        }

        let computablePay = input.monthlySalary + input.semesterGratification / 6
        let monthlyPortion = computablePay * Decimal(input.fullMonths) / 12
        let dailyPortion = computablePay * Decimal(input.additionalDays) / 360
        return CTSResult(
            computablePay: roundSoles(computablePay),
            monthlyPortion: roundSoles(monthlyPortion),
            dailyPortion: roundSoles(dailyPortion),
            totalCTS: roundSoles(monthlyPortion + dailyPortion),
            remainingVacationDays: input.acquiredVacationDays - input.takenVacationDays
        )
    }

    private static func roundSoles(_ value: Decimal) -> Decimal {
        var source = value
        var result = Decimal()
        NSDecimalRound(&result, &source, 2, .plain)
        return result
    }
}
