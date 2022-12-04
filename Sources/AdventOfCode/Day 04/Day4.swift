struct Day4: Solution {
    static let day = 4

    var assignmentPairs: [(Assignment, Assignment)]!
    
    init(input: String) {
        self.assignmentPairs = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .map({ str1 in
                let bothArrays = str1.components(separatedBy: ",").map({ str2 in
                    let assignArray = str2.components(separatedBy: "-").map { Int($0)! }
                    return Assignment(start: assignArray[0], end: assignArray[1])
                })
                return (bothArrays[0], bothArrays[1])
            })
    }

    func calculatePartOne() -> Int {
        assignmentPairs.reduce(0) { partialResult, newPair in
            partialResult + (newPair.0.bothContains(newPair.1) ? 1 : 0)
        }
    }
    
    func calculatePartTwo() -> Int {
        assignmentPairs.reduce(0) { partialResult, newPair in
            partialResult + (newPair.0.overlap(with: newPair.1) ? 1 : 0)
        }
    }
}

class Assignment {
    var start: Int
    var end: Int
    init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }

    /// Tests if the two provided ``Assignment``s overlap with each other.
    /// - Parameter other: The assignment being tested, other than `self`.
    /// - Returns: `True` if either assignment overlaps.
    func overlap(with other: Assignment) -> Bool {
        return start <= other.end && end >= other.start
    }
    /// Test if self contains other, and also if other contains self.
    /// - Parameter other: The second assignment beign tested against.
    /// - Returns: `True` if either assignment contains the other, else `False`
    func bothContains(_ other: Assignment) -> Bool {
        return self.contains(other) || other.contains(self)
    }
    func contains(_ other: Assignment) -> Bool {
        return (start <= other.start && end >= other.end)
    }
}
