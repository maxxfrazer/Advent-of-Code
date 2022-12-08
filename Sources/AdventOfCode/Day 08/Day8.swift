struct Day8: Solution {
    static let day = 8

    var myGrid: [[Int]]
    
    init(input: String) {
        self.myGrid = input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map {
            $0.split(separator: "").map {
                Int($0)!
            }
        }
    }
    
    func calculatePartOne() -> Int {
        var outputGrid = [[Int]](
            repeating: [Int](repeating: 0, count: myGrid[0].count),
            count: myGrid.count
        )
        // maxLeft is the highest number to the left of the current index
        var maxLeft = [Int](repeating: -1, count: myGrid.count)
        var maxRight = [Int](repeating: -1, count: myGrid.count)
        var maxAbove = [Int](repeating: -1, count: myGrid[0].count)
        var maxBelow = [Int](repeating: -1, count: myGrid[1].count)

        var countingVisible = Set<String>()
        // first calculate those seen from above and to the left
        var i = 0 // current row
        while i < myGrid.count {
            // current row = i
            var j = 0 // current column
            while j < myGrid[1].count {
                let curVal = self.myGrid[i][j]
                if curVal > maxLeft[i] {
                    maxLeft[i] = curVal
                    outputGrid[i][j] += 1
                }
                if curVal > maxAbove[j] {
                    maxAbove[j] = curVal
                    outputGrid[i][j] += 1
                }
                if outputGrid[i][j] != 0 {
                    countingVisible.insert("\(i):\(j)")
                }
                j += 1
            }
            i += 1
        }

        // then calculate those seen from the right and below
        i = myGrid.count - 1 // current row
        while i >= 0 {
            // current row = i
            var j = myGrid[1].count - 1 // current column
            while j >= 0 {
                let curVal = self.myGrid[i][j]
                if curVal > maxRight[i] {
                    maxRight[i] = curVal
                    outputGrid[i][j] += 1
                }
                if curVal > maxBelow[j] {
                    maxBelow[j] = curVal
                    outputGrid[i][j] += 1
                }
                if outputGrid[i][j] != 0 {
                    countingVisible.insert("\(i):\(j)")
                }
                j -= 1
            }
            i -= 1
        }
        return countingVisible.count
    }
    
    func calculatePartTwo() -> Int {
        var outputGrid = [[Int]](
            repeating: [Int](repeating: 1, count: myGrid[0].count),
            count: myGrid.count
        )
        var largestVal = 0
        // calculating left and above
        var i = 1
        while i < myGrid.count - 1 {
            var j = 1
            while j < myGrid[0].count - 1 {
                var prevCounter = 1
                while j - prevCounter > 0 && myGrid[i][j - prevCounter] < myGrid[i][j] {
                    prevCounter += 1
                }
                outputGrid[i][j] *= prevCounter

                prevCounter = 1
                while j - prevCounter > 0 && myGrid[j - prevCounter][i] < myGrid[j][i] {
                    prevCounter += 1
                }
                outputGrid[j][i] *= prevCounter
                largestVal = max(
                    max(largestVal, outputGrid[i][j]),
                    outputGrid[j][i]
                )
                j += 1
            }
            i += 1
        }

        // calculating right and below
        i = myGrid.count - 2
        while i > 0 {
            var j = myGrid[0].count - 2
            while j > 0 {
                var prevCounter = 1
                while j + prevCounter < myGrid.count - 1 && myGrid[i][j + prevCounter] < myGrid[i][j] {
                    prevCounter += 1
                }
                outputGrid[i][j] *= prevCounter

                prevCounter = 1
                while j + prevCounter < myGrid.count - 1 && myGrid[j + prevCounter][i] < myGrid[j][i] {
                    prevCounter += 1
                }
                outputGrid[j][i] *= prevCounter
                largestVal = max(
                    max(largestVal, outputGrid[i][j]),
                    outputGrid[j][i]
                )
                j -= 1
            }
            i -= 1
        }
        return largestVal // 187200 is too low
    }
}
