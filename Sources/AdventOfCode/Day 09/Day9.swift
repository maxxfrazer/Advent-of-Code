import Darwin

struct Day9: Solution {
    static let day = 9
    var allMoves: [(direction: SIMD2<Int>, count: Int)]
    init(input: String) {

        let moves = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        self.allMoves = moves.map { move in
            let moveComp = move.components(separatedBy: .whitespaces)
            var direction: SIMD2<Int>
            // Direction within a 2d space
            switch moveComp[0] {
            case "U": direction = [0, 1]
            case "D": direction = [0, -1]
            case "L": direction = [-1, 0]
            case "R": direction = [1, 0]
            default:
                fatalError("No registered move for \(moveComp[0])")
            }
            return (direction, Int(moveComp[1])!)
        }
    }
    
    func calculatePartOne() -> Int {
        self.findTailMoves(moves: allMoves, ropeLength: 2)
    }
    
    func calculatePartTwo() -> Int {
        self.findTailMoves(moves: allMoves, ropeLength: 10)
    }

    func findTailMoves(
        moves: [(direction: SIMD2<Int>, count: Int)], ropeLength: Int
    ) -> Int {
        var allPositions = [SIMD2<Int>](
            repeating: SIMD2<Int>(0, 0), count: ropeLength
        )
        var tPosSet = Set<SIMD2<Int>>()
        tPosSet.insert(allPositions.last!)
        for move in moves {
            var moveCount = move.count
            while moveCount > 0 {
                allPositions[0] &+= move.direction
                moveCount -= 1
                var i = 1
                while i < allPositions.count {
                    let hPos = allPositions[i - 1]
                    let tPos = allPositions[i]
                    if hPos.distance(to: tPos) > 1.5 {
                        // we are too far, move tpos
                        let xDist = hPos.x - tPos.x
                        let yDist = hPos.y - tPos.y
                        if xDist == 0 {
                            allPositions[i].y += yDist > 0 ? 1 : -1
                        } else if yDist == 0 {
                            allPositions[i].x += xDist > 0 ? 1 : -1
                        } else {
                            allPositions[i].y += yDist > 0 ? 1 : -1
                            allPositions[i].x += xDist > 0 ? 1 : -1
                        }
                    }
                    i += 1
                }
                tPosSet.insert(allPositions.last!)
            }
        }
        return tPosSet.count

    }
}

extension SIMD2 where SIMD2.Scalar: Comparable {
    func distance(to vector: SIMD2<Scalar>) -> Float where Scalar == Float {
        return SIMD2<Scalar>(self.x - vector.x, self.y - vector.y).magnitude()
    }

    /// Scalar distance between two vectors
    ///
    /// - Parameter vector: vector to compare
    /// - Returns: Scalar distance
    func distance(to vector: SIMD2<Scalar>) -> Float where Scalar == Int {
        return SIMD2<Float>(self).distance(to: SIMD2<Float>(vector))

    }

    func magnitude() -> Float where Scalar == Float {
        return sqrtf(x * x + y * y)
    }
}
