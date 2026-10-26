import XCTest
@testable import CTSPeru

final class CTSPeruTests: XCTestCase {
    private func example(vacationDays: Int, months: Int = 6, days: Int = 0) -> CTSInput {
        CTSInput(
            monthlySalary: 3000,
            semesterGratification: 3000,
            fullMonths: months,
            additionalDays: days,
            acquiredVacationDays: 30,
            takenVacationDays: vacationDays
        )
    }

    func testFullSemester() throws {
        let result = try CTSCalculator.calculate(example(vacationDays: 0))
        XCTAssertEqual(result.computablePay, 3500)
        XCTAssertEqual(result.totalCTS, 1750)
        XCTAssertEqual(result.remainingVacationDays, 30)
    }

    func testPaidVacationDoesNotReduceCTS() throws {
        let withoutVacation = try CTSCalculator.calculate(example(vacationDays: 0))
        let withVacation = try CTSCalculator.calculate(example(vacationDays: 15))
        XCTAssertEqual(withVacation.totalCTS, withoutVacation.totalCTS)
        XCTAssertEqual(withVacation.remainingVacationDays, 15)
    }

    func testComputableDaysAndValidation() throws {
        let result = try CTSCalculator.calculate(example(vacationDays: 0, months: 5, days: 15))
        XCTAssertEqual(result.totalCTS, Decimal(string: "1604.17"))
        XCTAssertThrowsError(try CTSCalculator.calculate(example(vacationDays: 0, months: 6, days: 15)))
    }
}
