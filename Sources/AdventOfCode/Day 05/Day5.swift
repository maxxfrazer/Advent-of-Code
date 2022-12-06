import Foundation

struct Day5: Solution {
    static let day = 5

    /// Stacks in their initial condition
    var myStacks = [Stack<Character>]()
    /// All the moves to be applied to the stacks
    var moves: [Moves]
    
    init(input: String) {
        // Separate the stack layout and the moves
        let inpSep = input.components(separatedBy: "\n\n")

        // Find all the moves that need to be made
        self.moves = inpSep[1].trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines).map {
            let sepSpace = $0.components(separatedBy: .whitespaces)
            return Moves(count: Int(sepSpace[1])!, from: Int(sepSpace[3])!, to: Int(sepSpace[5])!)
        }

        let stacksSep1 = inpSep[0].components(separatedBy: .newlines)
        var i = stacksSep1.count - 1
        // I apologise for using this separator
        self.myStacks = stacksSep1[i].split(separator: "   ").map { _ in Stack<Character>() }
        i -= 1
        while i >= 0 {
            let lineArr = Array(stacksSep1[i])
            var j = 0
            while j < self.myStacks.count {
                if lineArr.count >= j * 4 + 1 && !lineArr[j * 4 + 1].isWhitespace {
                    self.myStacks[j].push(lineArr[j * 4 + 1])
                }
                j += 1
            }
            i -= 1
        }

    }
    
    func calculatePartOne() -> String {
        var newStacks = self.myStacks
        for move in self.moves {
            var count = 0
            while count < move.count {
                newStacks[move.to - 1].push(newStacks[move.from - 1].pop())
                count += 1
            }
        }

        return newStacks.reduce("") { partialResult, stack in
            partialResult + String(stack.peek())
        }
    }
    
    func calculatePartTwo() -> String {
        var newStacks = self.myStacks
        var tempStack = Stack<Character>()
        for move in self.moves {
            var count = 0
            while count < move.count {
                tempStack.push(newStacks[move.from - 1].pop())
                count += 1
            }
            while !tempStack.isEmpty {
                newStacks[move.to - 1].push(tempStack.pop())
            }
        }

        return newStacks.reduce("") { partialResult, stack in
            partialResult + String(stack.peek())
        }
    }
}

struct Moves {
    var count: Int
    var from: Int
    var to: Int
}

struct Stack<T> {

    private var items: [T] = []

    var isEmpty: Bool { items.isEmpty }

    func peek() -> T {
        guard let topElement = items.last else { fatalError("This stack is empty.") }
        return topElement
    }

    mutating func pop() -> T {
        return items.removeLast()
    }

    mutating func push(_ element: T) {
        items.append(element)
    }
}
