extension Character {
    func toPoint(against: Character) -> Int {
        // Tally of points scored in round
        var tally = 0
        // Put the points with the same UInt8 values
        // So X and A both equal 0, meaning rock.
        let selfAscii = self.asciiValue! - Character("X").asciiValue!
        let againstAscii = against.asciiValue! - Character("A").asciiValue!
        // X = 0, Y = 1, Z = 2, add one to find the points for playing it.
        tally += Int(selfAscii) + 1

        // If equal then draw
        if selfAscii == againstAscii { return tally + 3 }
        // if one greater mod 3, then we win
        if ((againstAscii + 1) % 3) == selfAscii { return tally + 6 }
        // otherwise lose, no points awarded except those from earlier.
        return tally
    }

    func round2Score(against: Character) -> Int {
        let selfAscii = self.asciiValue! - Character("X").asciiValue!
        let againstAscii = against.asciiValue! - Character("A").asciiValue!
        // X (0) => need to lose, so we need to be (against + 2) % 3
        // Y (1) => need to draw, so (against + 0) % 3
        // Z (2) => need to win, so (against + 1) % 3
        // we really need to add 2 and modulo by 3 each of these
        let playOffset = selfAscii + 2
        // add the offset to the opponent's score to find the winning, losing, or drawing play.
        let newPlay = Character(UnicodeScalar((againstAscii + playOffset) % 3 + Character("X").asciiValue!))
        // Run that play against the original algo.
        return newPlay.toPoint(against: against)
    }
}

struct Day2: Solution {
    static let day = 2
    /// Each match score from the text input, will look like:
    /// `[["A", "Y"], ["B", "X"], ["C", "Z"]]`
    var scoreData: [[Character]]
    
    init(input: String) {
        scoreData = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
            .map { $0.components(separatedBy: .whitespaces).map { Character($0) }
        }
    }

    func calculatePartOne() -> Int {
        scoreData.map{ $0[1].toPoint(against: $0[0]) }.reduce(0, +)
    }
    
    func calculatePartTwo() -> Int {
        scoreData.map{ $0[1].round2Score(against: $0[0]) }.reduce(0, +)
    }
}
