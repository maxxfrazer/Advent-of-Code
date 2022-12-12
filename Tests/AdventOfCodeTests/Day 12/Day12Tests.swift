import XCTest
@testable import AdventOfCode

final class Day12Tests: XCTestCase, SolutionTest {
    typealias SUT = Day12
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 31)
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), 29)
    }
}
