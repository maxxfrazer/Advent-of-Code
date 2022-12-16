import Foundation

struct Day13: Solution {
    static let day = 13

    var allPairs: [(first: [ArrayOrGroup], second: [ArrayOrGroup])] = []

    init(input: String) {
        let t1 = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n\n")
        allPairs = t1.map {
                let pairs = $0.components(separatedBy: .newlines).compactMap {
                    (try! JSONSerialization.jsonObject(with: $0.data(using: .utf8)!) as! [Any]).map {
                        try! ArrayOrGroup(from: $0)
                    }
                }
                return (first: pairs[0], second: pairs[1])
            }
    }

    func calculatePartOne() -> Int {
        self.calculateCorrectIndices().enumerated().reduce(0) { partialResult, nextEl in
            return partialResult + (nextEl.element ? (nextEl.offset + 1) : 0)
        }
    }
    
    func calculatePartTwo() -> Int {
        var allValues: [[ArrayOrGroup]] = []
        self.allPairs.forEach { (first, second) in
            allValues.append(first)
            allValues.append(second)
        }
        let checkVals: [[ArrayOrGroup]] = [
            [.arr([.val(2)])],
            [.arr([.val(6)])]
        ]
        allValues.append(checkVals[0])
        allValues.append(checkVals[1])
        allValues = allValues.sorted { first, second in
            ArrayOrGroup.compare(lhs: first, rhs: second) == .orderedAscending
        }
        var decodeKey = 1
        var i = 0
        var j = 0
        // Could binary search to find the two values, but ain't no time for that.
        while i < allValues.count, j < 2 {
            if ArrayOrGroup.compare(lhs: allValues[i], rhs: checkVals[j]) == .orderedSame {
                decodeKey *= (i + 1)
                j += 1
            }
            i += 1
        }
        return decodeKey
    }

    func calculateCorrectIndices() -> [Bool] {
        self.allPairs.map { ArrayOrGroup.compare(lhs: $0.first, rhs: $0.second) != .orderedDescending }
    }

    func test(l: [Any], r: [Any]) -> Bool? {
        let maxLength = max(l.count, r.count)
        var i = -1
        while(i < maxLength - 1){
            i += 1
            if i >= l.count {return true} // left ran out of values
            if i >= r.count {return false} // right ran out of values
            let iL = l[i]
            let iR = r[i]
            if let iL = iL as? Int, let iR = iR as? Int {
                if iL > iR { return false }
                if iL < iR { return true }
                // if equal, continue to next val
            } else if let iL = iL as? Int {
                return test(l: [iL], r: iR as! [Any])
            } else if let iR = iR as? Int {
                return test(l: iL as! [Any], r: [iR])
            } else if let kwons = test(l: iL as! [Any], r: iR as! [Any]) {
                return kwons
            } else {
                fatalError("Should not get here, oh nooo")
            }
        }
        return true
    }
}

enum ArrayOrGroup: Codable {
    case val(Int)
    case arr([ArrayOrGroup])
    enum ArrayOrGroupError: Error {
        case invalidInput
    }
    init(from fromVal: Any) throws {
        if let from = fromVal as? Int {
            self = .val(from)
        } else if let fromArr = fromVal as? [Any] {
            self = try .arr(fromArr.map { try ArrayOrGroup(from: $0) })
        } else {
            self = .arr([])
        }
    }
    static func compare(lhs: [ArrayOrGroup], rhs: [ArrayOrGroup]) -> ComparisonResult {
        for (index, packet) in lhs.enumerated() {
            guard index < rhs.count else {
                return .orderedDescending
            }
            let result = compare(lhs: packet, rhs: rhs[index])
            if result == .orderedSame { continue
            } else { return result }
        }
        return lhs.count == rhs.count ? .orderedSame : .orderedAscending
    }
    static func compare(lhs: ArrayOrGroup, rhs: ArrayOrGroup) -> ComparisonResult {
        switch (lhs, rhs) {
        case (.val(let leftInt), .val(let rightInt)):
            return compare(lhs: leftInt, rhs: rightInt)
        case (.val, .arr):
            return compare(lhs: .arr([lhs]), rhs: rhs)
        case (.arr, .val):
            return compare(lhs: lhs, rhs: .arr([rhs]))
        case (.arr(let leftArr), .arr(let rightArr)):
            return compare(lhs: leftArr, rhs: rightArr)
        }
    }
    static func compare(lhs: Int, rhs: Int) -> ComparisonResult {
        lhs < rhs ? .orderedAscending : lhs > rhs ? .orderedDescending : .orderedSame
    }
}
