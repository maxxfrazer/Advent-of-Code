import XCTest
@testable import AdventOfCode

final class Day9Tests: XCTestCase, SolutionTest {
    typealias SUT = Day9
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 88)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 36)
    }
}
