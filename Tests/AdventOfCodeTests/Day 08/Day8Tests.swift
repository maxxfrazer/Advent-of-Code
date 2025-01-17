import XCTest
@testable import AdventOfCode

final class Day8Tests: XCTestCase, SolutionTest {
    typealias SUT = Day8
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 21)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 8)
    }
}
