import XCTest
@testable import AdventOfCode

final class Day13Tests: XCTestCase, SolutionTest {
    typealias SUT = Day13
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 13)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 140)
    }
}
