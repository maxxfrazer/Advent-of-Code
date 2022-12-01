struct Day1: Solution {
    static let day = 1

    /// List of the number of calories per elf, unsorted, same order as input.
    var caloriesData: [Int]

    init(input: String) {
        caloriesData = input.split(separator: "\n\n").map {
            $0.components(separatedBy: .newlines)
                .compactMap(Int.init).reduce(0, +)
        }
    }

    func calculatePartOne() -> Int {
        // Simple way
//        return data.max() ?? 0
        // Optimised way, O(n)
        var largest: Int = Int.min
        caloriesData.forEach { if $0 > largest { largest = $0 } }
        return largest
    }
}

extension Day1 {
    func calculatePartTwo() -> Int {
        // Simple way O(nlogn)
//        return self.data.sorted().dropFirst(data.count - 3).reduce(0, +)

        // Optimised way, using a variant of quicksort to find the kth-to-last pivot.
        // This avoids sorting the entire array, but quickly tries to find the kth largest.
        // Values before the pivot will be unordered but all less than the pivot, and vice versa
        // for the values after the pivot. For example if we want the top 4,
        // we could get a valid output of: [4, 3, 2, 6, 10, 9, 7]
        // Therefore the last 4 (6, 10, 9, 7) are the greatest 4 numbers in the array, with "6" being the pivot.
        // This will give O(nlogn) for some cases, but as an average will give O(n).
        var mutableData = self.caloriesData
        var high = caloriesData.count - 1
        var low = 0
        // target pivot means we end when we find the pivot at the 3rd from last place
        // as we want the top 3 values.
        let targetPivot = caloriesData.count - 3
        while low < high {
            var pivot: Int! = Int.random(in: low...high)
            let pivotVal = mutableData[pivot]
            mutableData.swapAt(pivot, high)
            pivot = high
            high -= 1
            while low <= high && pivot != nil {
                if mutableData[low] < pivotVal {
                    low += 1
                    continue
                }
                while high > low && mutableData[high] >= pivotVal {
                    high -= 1
                }
                if low == high {
                    // we have crossed, swap with the pivot and reset low, high
                    mutableData.swapAt(high, pivot)
                    swap(&pivot, &low)
                    if pivot > targetPivot {
                        low = 0
                        high = pivot - 1
                    } else {
                        low = pivot + 1
                        high = mutableData.count - 1
                    }
                    pivot = nil
                } else {
                    mutableData.swapAt(low, high)
                    low += 1
                }
            }
        }
        return mutableData.dropFirst(targetPivot).reduce(0, +)
    }
}
