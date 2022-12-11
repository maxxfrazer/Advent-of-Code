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
        // we could get a valid output of: [7, 9, 10, 6, 4, 5, 1]
        // Therefore the first 4 (7, 9, 10, 6) are the greatest 4 numbers in the array, with "6" being the pivot.
        // This will give O(nlogn) for some cases, but as an average will give O(n).
        var mutableData = self.caloriesData
        // target pivot means we end when we find the pivot at the 4th place
        // as we want the largest 3 values.
        let targetPivot = 3

        Day1.findKSort(nums: &mutableData, start: 0, end: caloriesData.count - 1, k: targetPivot)
        return mutableData.dropLast(caloriesData.count - 3).reduce(0, +)
    }

    @discardableResult
    static func findKSort(nums: inout [Int], start: Int, end: Int, k: Int) -> Int {
        var start_ = start
        var end_ = end
        while (start < end) {
            let piv = qsort(&nums, from: start_, to: end_);
            if (piv + 1 == k) {
                return nums[k - 1]
            } else if (piv < k) {
                start_ = piv + 1
            } else {
                end_ = piv - 1
            }
        }
        return nums[k - 1]
    }

    static func qsort(_ nums: inout [Int], from: Int, to: Int) -> Int {
        let pivot = nums[to]
        var cur = from
        var i = from
        while (i < to) {
            if (nums[i] > pivot) {
                nums.swapAt(cur, i)
                cur += 1;
            }
            i += 1
        }
        nums.swapAt(cur, to)
        return cur
    }
}
