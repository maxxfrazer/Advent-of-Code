import Foundation
struct Day10: Solution {
    static let day = 10

    var instructions: [Int]
    
    init(input: String) {
        let instr1 = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map {
            $0.components(separatedBy: .whitespaces)
        }
        self.instructions = instr1.compactMap {
            // I'm making an assumption that "addx 0"
            // does not exist. So any 0 means the input
            // was "noop", everything else is "addx `Int`"
            if $0.count == 1 {
                return 0
            }
            return Int($0[1])
        }
    }
    
    func calculatePartOne() -> Int {
        var xVal = 1
        var sumEvery20 = 0
        var cycleNum = 0
        func addToCycleNum() {
            cycleNum += 1
            if cycleNum > 19 && (cycleNum + 20) % 40 == 0 {
                sumEvery20 += xVal * cycleNum
            }
        }
        for instruction in instructions {
            addToCycleNum()
            if instruction != 0 { addToCycleNum() }
            xVal += instruction
        }
        return sumEvery20
    }
    
    func calculatePartTwo() -> String {
        var xVal = 1
        var cycleNum = 0
        var totalImg = ""
        func addToImage() {
            cycleNum += 1
            if (xVal...xVal+2).contains(cycleNum % 40) {
                totalImg += "#"
            } else { totalImg += "." }
            if cycleNum % 40 == 0 { totalImg += "\n" }
        }
        for instruction in instructions {
            addToImage()
            if instruction != 0 { addToImage() }
            xVal += instruction
        }
        return totalImg
    }
}
