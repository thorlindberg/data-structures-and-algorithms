// Space complexity is a measure of the resources required for the algorithm to run. For computers, the resources for algorithms is memory.

// Since array.sorted() will produce a brand new array with the same size of array, the space complexity of printSorted is O(n).

func printSorted(_ array: [Int]) {
    let sorted = array.sorted()
    for element in sorted {
        print(element)
    }
}

/*

This implementation respects space constraints. The overall goal is to iterate through the array multiple times, printing the next smallest value for each iteration.

Allocates memory to keep track of a few variables, so the space complexity is O(1). This is in contrast with the previous function, which allocates an entire array to create the sorted representation of the source array.

*/

func printSorted(_ array: [Int]) {

    guard !array.isEmpty else { return }
    var currentCount = 0
    var minValue = Int.min

    for value in array {
        if value == minValue {
            print(value)
            currentCount += 1
        }
    }

    while currentCount < array.count {

        var currentValue = array.max()!

        for value in array {
            if value < currentValue && value > minValue {
                currentValue = value
            }
        }

        for value in array {
            if value == currentValue {
                print(value)
                currentCount += 1
            }
        }

        minValue = currentValue
    }

}