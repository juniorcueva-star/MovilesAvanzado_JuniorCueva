import SwiftUI

struct ContentView: View {
    @State private var salaryText = "3000"
    @State private var gratificationText = "3000"
    @State private var fullMonths = 6
    @State private var additionalDays = 0
    @State private var acquiredVacationDays = 30
    @State private var tookVacation = false
    @State private var takenVacationDays = 15

    private let ink = Color(red: 0.10, green: 0.18, blue: 0.29)
    private let blue = Color(red: 0.10, green: 0.36, blue: 0.72)

    private var result: CTSResult? {
        guard let salary = parseAmount(salaryText),
              let gratification = parseAmount(gratificationText) else { return nil }
        return try? CTSCalculator.calculate(
            CTSInput(
                monthlySalary: salary,
                semesterGratification: gratification,
                fullMonths: fullMonths,
                additionalDays: additionalDays,
                acquiredVacationDays: acquiredVacationDays,
                takenVacationDays: tookVacation ? takenVacationDays : 0
            )
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    inputsCard
                    vacationCard
                    if let result {
                        resultCard(result)
                    } else {
                        Text("Revisa los importes y el periodo ingresado.")
                            .foregroundStyle(.red)
                            .padding()
                    }
                    legalNote
                }
                .padding(18)
            }
            .background(Color(red: 0.96, green: 0.97, blue: 0.99))
            .navigationTitle("CTS Perú")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(blue)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Calcula tu CTS")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(ink)
            Text("Régimen laboral privado general · Semestre de hasta 6 meses")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var inputsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("01", "Datos para la CTS")
            amountField("Sueldo mensual computable (S/)", text: $salaryText)
            amountField("Gratificación recibida en el semestre (S/)", text: $gratificationText)
            Divider()
            Stepper("Meses completos: \(fullMonths)", value: $fullMonths, in: 1...6)
                .onChange(of: fullMonths) { _, newValue in
                    if newValue == 6 { additionalDays = 0 }
                }
            Stepper("Días adicionales: \(additionalDays)", value: $additionalDays, in: 0...(fullMonths == 6 ? 0 : 29))
            Text("Ingresa meses y días computables. Las vacaciones pagadas sí cuentan; las ausencias sin goce se excluyen del tiempo ingresado.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .cardStyle()
    }

    private var vacationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("02", "Vacaciones")
            Stepper("Días adquiridos: \(acquiredVacationDays)", value: $acquiredVacationDays, in: 0...30)
                .onChange(of: acquiredVacationDays) { _, newValue in
                    takenVacationDays = min(takenVacationDays, newValue)
                }
            Toggle("Salió de vacaciones pagadas", isOn: $tookVacation)
            if tookVacation {
                Stepper("Días gozados: \(takenVacationDays)", value: $takenVacationDays, in: 0...acquiredVacationDays)
            }
            Text("El saldo usa los días adquiridos que ingresaste. En el régimen general corresponden 30 días calendario por año completo, sujeto al récord vacacional.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .cardStyle()
    }

    private func resultCard(_ result: CTSResult) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("03", "Resultado")
            HStack(alignment: .firstTextBaseline) {
                Text("CTS estimada")
                    .font(.headline)
                Spacer()
                Text(soles(result.totalCTS))
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(blue)
            }
            Divider()
            resultRow("Remuneración computable", soles(result.computablePay))
            resultRow("Por meses completos", soles(result.monthlyPortion))
            resultRow("Por días adicionales", soles(result.dailyPortion))
            resultRow("Vacaciones pendientes", "\(result.remainingVacationDays) días")
            Text(tookVacation
                 ? "Las vacaciones pagadas no reducen la CTS. Se descuentan solo del saldo vacacional."
                 : "No haber salido de vacaciones no aumenta la CTS. Los días pendientes son un concepto separado.")
                .font(.subheadline)
                .foregroundStyle(ink)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
        }
        .cardStyle()
    }

    private var legalNote: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Cómo se calcula")
                .font(.headline)
            Text("CTS = (sueldo + gratificación del semestre ÷ 6) × (meses ÷ 12 + días ÷ 360).")
            Text("Referencia: D. S. 001-97-TR, arts. 8, 18 y 21; D. Leg. 713, arts. 10 y 22. Es una estimación académica para remuneración fija; otros conceptos y regímenes requieren revisión individual.")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal, 4)
    }

    private func sectionTitle(_ number: String, _ title: String) -> some View {
        HStack(spacing: 10) {
            Text(number)
                .font(.caption.bold())
                .foregroundStyle(blue)
                .padding(7)
                .background(blue.opacity(0.1), in: Circle())
            Text(title)
                .font(.headline)
                .foregroundStyle(ink)
        }
    }

    private func amountField(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline.weight(.medium))
            TextField("0.00", text: text)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel(title)
        }
    }

    private func resultRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            Text(value).fontWeight(.semibold)
        }
        .font(.subheadline)
    }

    private func parseAmount(_ raw: String) -> Decimal? {
        let normalized = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard !normalized.isEmpty else { return nil }
        return Decimal(string: normalized, locale: Locale(identifier: "en_US_POSIX"))
    }

    private func soles(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "PEN"
        formatter.locale = Locale(identifier: "es_PE")
        return formatter.string(from: amount as NSDecimalNumber) ?? "S/ \(amount)"
    }
}

private extension View {
    func cardStyle() -> some View {
        self
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white, in: RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
