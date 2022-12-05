import XCTest
@testable import AdventOfCode

final class Day5Tests: XCTestCase, SolutionTest {
    typealias SUT = Day5
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), "CMZ")
    }
    
    func testPartTwo() throws {
        try XCTAssertEqual(sut.calculatePartTwo(), "MCD")
    }
}
