struct Day12: Solution {
    static let day = 12

    var grid = [[Int]]()
    var start: [Int]!
    var end: [Int]!

    init(input: String) {
        self.grid = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines).enumerated().map { idx in
                return Array(idx.element).enumerated().map {
                    if $0.element.isLowercase {
                        return Int($0.element.asciiValue!)
                    } else if $0.element == Character("S") {
                        self.start = [idx.offset, $0.offset]
                        return Int(Character("a").asciiValue!)
                    } else if $0.element == Character("E") {
                        self.end = [idx.offset, $0.offset]
                        return Int(Character("z").asciiValue!)
                    }
                    fatalError("Invalid character '\($0.element)'")
                }
            }
    }

    let allDirections: [[Int]] = [[0, 1], [1, 0], [-1, 0], [0, -1]]

    func calculatePartOne() -> Int {
        return findPathSteps(from: self.start, to: { $0 == self.end})
    }

    func calculatePartTwo() -> Int {
        self.findPathSteps(from: self.end, to: { self.grid[$0[0]][$0[1]] == Int(Character("a").asciiValue!) }, pathDirection: -1)
    }

    /// Braedth-first-search looking for the shortest path from the start to the finish condition.
    /// - Parameters:
    ///   - start: Starting point of the path.
    ///   - atFinish: Condition to be met to know we are at the end. This could be a cell value match or a specific location.
    ///   - pathDirection: Direction up (1) or down (-1) the mountain.
    /// - Returns: The minimum number of steps required to get from the start to finishing position
    func findPathSteps(from start: [Int], to atFinish: ([Int]) -> Bool, pathDirection: Int = 1) -> Int {
        var visitedGrid = [[Int]](repeating: [Int](repeating: 0, count: grid[0].count), count: grid.count)
        var bfsQueue = Queue<([Int], Int)>() // queue with point and no. steps
        bfsQueue.push((start, 0)) // start, 0 steps to get here.
        let xRange = 0...(grid.count - 1)
        let yRange = 0...(grid[0].count - 1)
        visitedGrid[self.start[0]][self.start[1]] = 1
        while !bfsQueue.isEmpty { // continue until queue is empty
            let (cur, curStep) = bfsQueue.pop()
            let curVal = self.grid[cur[0]][cur[1]] // a/97, b/98
            if atFinish(cur) { // finish condition met
                return curStep
            }
            for direction in allDirections {
                let dirStep = zip(cur, direction).map(+) // [x, y] + direction move, such as [1, 0] or [0, -1]
                if xRange.contains(dirStep[0]), yRange.contains(dirStep[1]) { // in bounds of grid
                    let visited = visitedGrid[dirStep[0]][dirStep[1]] // 1 if cell has been visited
                    let dirVal = grid[dirStep[0]][dirStep[1]] // value of the cell a/97, b/98, etc.
                    if visited == 0, ((dirVal - curVal) * pathDirection) <= 1 { // not visited, no more than 1 difference.
                        visitedGrid[dirStep[0]][dirStep[1]] = 1 // mark as visited
                        bfsQueue.push((dirStep, curStep + 1)) // push to queue
                    }
                }
            }
        }
        return -1 // failed condition
    }
}

struct Queue<T> {

    private var items: [T] = []

    var isEmpty: Bool { items.isEmpty }
    var size: Int { items.count }
    func peek() -> T {
        guard let topElement = items.last else { fatalError("This queue is empty.") }
        return topElement
    }

    @discardableResult
    mutating func pop() -> T {
        items.removeFirst()
    }

    mutating func push(_ element: T) {
        items.append(element)
    }
}
