struct Day11: Solution {
    static let day = 11

    var allMonkeys: [Monkey]
    
    init(input: String) {
        let monkeySplits = input.components(separatedBy: "Monkey ").compactMap {
            let out = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            return out.isEmpty ? nil : out
        }
        self.allMonkeys = monkeySplits.map { monkey in
            let monkeyPieces = monkey.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            let monkeyItems = monkeyPieces[1].components(separatedBy: ": ").dropFirst().joined().components(separatedBy: ", ").compactMap { Int($0) }
            var operation: (Int) -> Int
            if monkeyPieces[2].contains("*") {
                operation = { input in
                    let multBy = monkeyPieces[2].components(separatedBy: " * ").last
                    if multBy == "old" {
                        return input * input
                    } else {
                        return input * Int(multBy!)!
                    }
                }
            } else {
                operation = { input in
                    let multBy = monkeyPieces[2].components(separatedBy: " + ").last
                    if multBy == "old" {
                        return input + input
                    } else {
                        return input + Int(multBy!)!
                    }
                }
            }
            let test = Int(monkeyPieces[3].components(separatedBy: "divisible by ").last!)!

            let throwsTo = [monkeyPieces[4], monkeyPieces[5]].compactMap {
                Int($0.components(separatedBy: " ").last!)
            }
            return Monkey(startingItems: monkeyItems, operation: operation, test: test, throwsTo: throwsTo)
        }
    }
    
    func calculatePartOne() -> Int {
        var i = 20
        while i > 0 {
            for monkey in allMonkeys {
                for item in monkey.startingItems {
                    monkey.inpsectCount += 1
                    // so long as this
                    let newItemVal = monkey.operation(item) / 3
                    allMonkeys[monkey.throwsTo[
                        newItemVal % monkey.test == 0 ? 0 : 1
                    ]].startingItems.append(newItemVal)
                }
                monkey.startingItems = []
            }
            i -= 1
        }
        var counts = allMonkeys.map { $0.inpsectCount }
        Day1.findKSort(nums: &counts, start: 0, end: counts.count - 1, k: 2)
        return counts[0] * counts[1]
    }
    
    func calculatePartTwo() -> Int {
        var i = 10_000
        var commonMultiple = 1
        for monkey in allMonkeys {
            // LCM would be better, but not today.
            commonMultiple *= monkey.test
        }
        while i > 0 {
            for monkey in allMonkeys {
                for item in monkey.startingItems {
                    monkey.inpsectCount += 1
                    // so long as this
                    let newItemVal = monkey.operation(item)
                    allMonkeys[monkey.throwsTo[
                        newItemVal % monkey.test == 0 ? 0 : 1
                    ]].startingItems.append(newItemVal % commonMultiple)
                }
                monkey.startingItems = []
            }
            i -= 1
        }
        var counts = allMonkeys.map { $0.inpsectCount }
        Day1.findKSort(nums: &counts, start: 0, end: counts.count - 1, k: 2)
        return counts[0] * counts[1]
    }
}

class Monkey {
    var startingItems: [Int]
    var operation: (Int) -> Int
    var test: Int
    var throwsTo: [Int]
    var inpsectCount = 0
    init(startingItems: [Int], operation: @escaping (Int) -> Int, test: Int, throwsTo: [Int]) {
        self.startingItems = startingItems
        self.operation = operation
        self.test = test
        self.throwsTo = throwsTo
    }
}
