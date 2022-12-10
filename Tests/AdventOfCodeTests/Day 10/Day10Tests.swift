import XCTest
@testable import AdventOfCode

final class Day10Tests: XCTestCase, SolutionTest {
    typealias SUT = Day10
    
    func testPartOne() throws {
        try XCTAssertEqual(sut.calculatePartOne(), 13140)
    }
    
    func testPartTwo() throws {
        let strOutput = """
        ##..##..##..##..##..##..##..##..##..##..
        ###...###...###...###...###...###...###.
        ####....####....####....####....####....
        #####.....#####.....#####.....#####.....
        ######......######......######......###.
        #######.......#######.......#######.....\n
        """
        try XCTAssertEqual(sut.calculatePartTwo(), strOutput)
    }
}
