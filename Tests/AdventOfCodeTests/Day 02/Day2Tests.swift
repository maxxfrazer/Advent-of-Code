import XCTest
@testable import AdventOfCode

final class Day2Tests: XCTestCase, SolutionTest {
    typealias SUT = Day2
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 15)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 12)
    }
}
