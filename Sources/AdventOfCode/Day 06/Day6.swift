struct Day6: Solution {
    static let day = 6

    let chars: [Character]
    
    init(input: String) {
        self.chars = Array(input.trimmingCharacters(in: .whitespacesAndNewlines))
    }

    func calculatePartOne() -> Int {
        self.findUniqueSetOf(4)
    }
    
    func calculatePartTwo() -> Int {
        self.findUniqueSetOf(14)
    }

    func findUniqueSetOf(_ length: Int) -> Int {
        var mySet = Set<Character>()
        var i = 0
        var j = 0
        while i < chars.count {
            // If our new character exists in the list already,
            // remove from beginning, starting with the i pointer value
            while mySet.contains(chars[j]) {
                mySet.remove(chars[i])
                i += 1
            }
            // Add our letter, we know it is unique
            mySet.insert(chars[j])
            // If lenght is found, return j + 1
            if mySet.count == length {
                return j + 1
            }
            // Otherwise nudge end along 1
            j += 1
        }
        // Will only reach here if it fails
        return 0
    }
}
