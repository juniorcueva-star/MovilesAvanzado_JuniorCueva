import SwiftUI

private enum CTSTheme {
    static let background = Color(red: 0.97, green: 0.96, blue: 0.94)
    static let ink = Color(red: 0.13, green: 0.20, blue: 0.22)
    static let teal = Color(red: 0.07, green: 0.34, blue: 0.34)
    static let orange = Color(red: 0.85, green: 0.43, blue: 0.25)
    static let muted = Color(red: 0.40, green: 0.45, blue: 0.45)
}

struct ContentView: View {
    @State private var salaryText = "3000"
    @State private var gratificationText = "3000"
    @State private var fullMonths = 6
    @State private var additionalDays = 0
    @State private var acquiredVacationDays = 30
    @State private var tookVacation = false
    @State private var takenVacationDays = 15
    @State private var displayedResult: CTSResult?
    @State private var validationMessage: String?

    private var inputSignature: String {
        [salaryText, gratificationText, String(fullMonths), String(additionalDays),
         String(acquiredVacationDays), String(tookVacation), String(takenVacationDays)]
            .joined(separator: "|")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                dataSection
                timeSection
                vacationSection
                calculateButton
                if let validationMessage {
                    Text(validationMessage)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if let result = displayedResult {
                    detailSection(result)
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 36)
        }
        .background(CTSTheme.background.ignoresSafeArea())
        .scrollDismissesKeyboard(.interactively)
        .preferredColorScheme(.light)
        .onChange(of: inputSignature) { _, _ in
            displayedResult = nil
            validationMessage = nil
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "banknote.fill")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(CTSTheme.orange, in: RoundedRectangle(cornerRadius: 13))
            VStack(alignment: .leading, spacing: 2) {
                Text("CTS Perú")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(CTSTheme.ink)
                Text("Calculadora · régimen privado general")
                    .font(.system(size: 13))
                    .foregroundStyle(CTSTheme.muted)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }

    private var dataSection: some View {
        section("01", "Datos de remuneración") {
            amountField("Sueldo mensual (S/)", text: $salaryText)
            Divider()
            amountField("Gratificación del semestre (S/)", text: $gratificationText)
        }
    }

    private var timeSection: some View {
        section("02", "Tiempo computable") {
            counterRow("Meses completos", value: $fullMonths, limits: 1...6)
                .onChange(of: fullMonths) { _, newValue in
                    if newValue == 6 { additionalDays = 0 }
                }
            Divider()
            counterRow("Días adicionales", value: $additionalDays, limits: 0...(fullMonths == 6 ? 0 : 29))
            Text("Las vacaciones pagadas cuentan. Excluye del tiempo ingresado las ausencias sin goce.")
                .font(.system(size: 12))
                .foregroundStyle(CTSTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var vacationSection: some View {
        section("03", "Vacaciones") {
            counterRow("Días adquiridos", value: $acquiredVacationDays, limits: 0...30)
                .onChange(of: acquiredVacationDays) { _, newValue in
                    takenVacationDays = min(takenVacationDays, newValue)
                }
            Divider()
            Toggle(isOn: $tookVacation) {
                Text("Salió de vacaciones pagadas")
                    .font(.system(size: 15))
                    .foregroundStyle(CTSTheme.ink)
            }
            .tint(CTSTheme.orange)
            if tookVacation {
                Divider()
                counterRow("Días gozados", value: $takenVacationDays, limits: 0...acquiredVacationDays)
            }
            Text("Los días gozados cambian el saldo vacacional, no la CTS.")
                .font(.system(size: 12))
                .foregroundStyle(CTSTheme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func detailSection(_ result: CTSResult) -> some View {
        section("04", "Resultado") {
            detailRow("Sueldo + 1/6 de gratificación", soles(result.computablePay))
            Divider()
            detailRow("CTS por meses", soles(result.monthlyPortion))
            Divider()
            detailRow("CTS por días", soles(result.dailyPortion))
            Divider()
            HStack {
                Text("CTS estimada")
                Spacer()
                Text(soles(result.totalCTS))
                    .font(.system(size: 21, weight: .bold, design: .rounded))
            }
            .foregroundStyle(CTSTheme.ink)
            Divider()
            detailRow("Vacaciones pendientes", "\(result.remainingVacationDays) días")
        }
    }

    private var calculateButton: some View {
        Button(action: calculate) {
            HStack {
                Image(systemName: "equal.circle.fill")
                Text("Calcular CTS")
                Spacer()
                Image(systemName: "arrow.right")
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.white)
            .padding(17)
            .frame(maxWidth: .infinity)
            .background(CTSTheme.orange, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private func calculate() {
        guard let salary = parseAmount(salaryText),
              let gratification = parseAmount(gratificationText) else {
            displayedResult = nil
            validationMessage = "Ingresa sueldo y gratificación válidos."
            return
        }

        do {
            displayedResult = try CTSCalculator.calculate(
                CTSInput(
                    monthlySalary: salary,
                    semesterGratification: gratification,
                    fullMonths: fullMonths,
                    additionalDays: additionalDays,
                    acquiredVacationDays: acquiredVacationDays,
                    takenVacationDays: tookVacation ? takenVacationDays : 0
                )
            )
            validationMessage = nil
        } catch {
            displayedResult = nil
            validationMessage = error.localizedDescription
        }
    }

    private func section<Content: View>(
        _ number: String,
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 9) {
                Text(number)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(CTSTheme.orange)
                    .frame(width: 30, height: 30)
                    .background(CTSTheme.orange.opacity(0.11), in: Circle())
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(CTSTheme.ink)
            }
            content()
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(CTSTheme.teal.opacity(0.08)))
    }

    private func amountField(_ label: String, text: Binding<String>) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(CTSTheme.ink)
            Spacer(minLength: 4)
            TextField("0.00", text: text)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(CTSTheme.teal)
                .frame(width: 95)
                .accessibilityLabel(label)
        }
    }

    private func counterRow(_ label: String, value: Binding<Int>, limits: ClosedRange<Int>) -> some View {
        HStack(spacing: 9) {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(CTSTheme.ink)
            Spacer(minLength: 4)
            Button {
                value.wrappedValue -= 1
            } label: {
                Image(systemName: "minus")
                    .frame(width: 28, height: 28)
            }
            .disabled(value.wrappedValue <= limits.lowerBound)
            Text("\(value.wrappedValue)")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .frame(minWidth: 22)
            Button {
                value.wrappedValue += 1
            } label: {
                Image(systemName: "plus")
                    .frame(width: 28, height: 28)
            }
            .disabled(value.wrappedValue >= limits.upperBound)
        }
        .buttonStyle(.plain)
        .foregroundStyle(CTSTheme.teal)
    }

    private func detailRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(CTSTheme.muted)
            Spacer()
            Text(value)
                .foregroundStyle(CTSTheme.ink)
                .fontWeight(.semibold)
        }
        .font(.system(size: 13))
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

#Preview {
    ContentView()
}
