struct Day3: Solution {
    static let day = 3

    var backpackData: [(backpack: Set<Character>, common: Character)]
    
    init(input: String) {
        backpackData = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
            .map {
                let itemsArray = Array($0)
                var setLeft: Set<Character> = []
                var setRight: Set<Character> = []
                // left pointer
                var i = 0
                // right pointer
                var j = $0.count - 1
                var commonItem: String.Element?
                // when pointers meet or cross over
                while i < j {
                    // add an item to the left list
                    setLeft.insert(itemsArray[i])
                    // Find a match in either left or right list
                    if setLeft.contains(itemsArray[j]) {
                        commonItem = itemsArray[j]
                    } else if setRight.contains(itemsArray[i]) {
                        commonItem = itemsArray[i]
                    }
                    // Could break out here for part1, need the full backpack data for part 2.
                    setRight.insert(itemsArray[j])
                    i += 1
                    j -= 1
                }
                return (backpack: setLeft.union(setRight), common: Character(String(commonItem!)))
            }
    }
    
    func calculatePartOne() -> Int {
        // Calculate score for common element for pack.
        let asciBP = self.backpackData.map(\.common.score)
        // add 'em up.
        return asciBP.reduce(0, +)
    }
    
    func calculatePartTwo() -> Int {
        var group: Int = 0
        var tally: Int = 0
        while group * 3 < backpackData.count - 1 {
            let pack1 = backpackData[group * 3 + 0].backpack
            let pack2 = backpackData[group * 3 + 1].backpack
            let pack3 = backpackData[group * 3 + 2].backpack
            // Find intersection for all three packs.
            let groupUnique = pack1.intersection(pack2.intersection(pack3))
            guard groupUnique.count == 1, let firstShared = groupUnique.first else {
                fatalError("Not more or less than 1 unique item")
            }
            // Add the score for that intersection to the tally
            tally += firstShared.score
            group += 1
        }
        return tally
    }
}

fileprivate extension Character {
    var score: Int {
        let charValue: UInt8
        if self.isUppercase {
            charValue = self.asciiValue! - Character("A").asciiValue! + 27
        } else {
            charValue = self.asciiValue! - Character("a").asciiValue! + 1
        }
        return Int(charValue)

    }
}
