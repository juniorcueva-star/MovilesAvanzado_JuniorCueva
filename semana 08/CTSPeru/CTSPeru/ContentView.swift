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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                if let result {
                    summary(result)
                } else {
                    Text("Revisa los importes y el periodo ingresado.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(.white, in: RoundedRectangle(cornerRadius: 16))
                }
                dataSection
                timeSection
                vacationSection
                if let result {
                    detailSection(result)
                }
                legalNote
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 36)
        }
        .background(CTSTheme.background.ignoresSafeArea())
        .scrollDismissesKeyboard(.interactively)
        .preferredColorScheme(.light)
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

    private func summary(_ result: CTSResult) -> some View {
        VStack(alignment: .leading, spacing: 13) {
            Text("CTS ESTIMADA DEL SEMESTRE")
                .font(.system(size: 11, weight: .bold))
                .tracking(1.1)
                .foregroundStyle(.white.opacity(0.78))
            Text(soles(result.totalCTS))
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .foregroundStyle(.white)
            Rectangle()
                .fill(.white.opacity(0.22))
                .frame(height: 1)
            HStack(spacing: 14) {
                metric("Base computable", soles(result.computablePay))
                Spacer(minLength: 0)
                metric("Vacaciones pendientes", "\(result.remainingVacationDays) días")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CTSTheme.teal, in: RoundedRectangle(cornerRadius: 20))
    }

    private func metric(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.75))
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
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
        section("04", "Detalle del cálculo") {
            detailRow("Sueldo + 1/6 de gratificación", soles(result.computablePay))
            Divider()
            detailRow("CTS por meses", soles(result.monthlyPortion))
            Divider()
            detailRow("CTS por días", soles(result.dailyPortion))
        }
    }

    private var legalNote: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Fórmula")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(CTSTheme.ink)
            Text("(Sueldo + gratificación ÷ 6) × (meses ÷ 12 + días ÷ 360)")
                .font(.system(size: 12))
            Text("30 días calendario de vacaciones por año completo, sujeto al récord. D. S. 001-97-TR y D. Leg. 713. Estimación académica para remuneración fija.")
                .font(.system(size: 11))
        }
        .foregroundStyle(CTSTheme.muted)
        .fixedSize(horizontal: false, vertical: true)
        .padding(.horizontal, 3)
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
