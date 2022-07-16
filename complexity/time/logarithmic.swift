// The Big O notation for logarithmic time complexity is O(log n).

let numbers = [1, 3, 56, 66, 68, 80, 99, 105, 450]

func naiveContains(_ value: Int, in array: [Int]) -> Bool {
    for element in array {
        if element == value {
            return true
        }
    }
    return false
}

/*

The algorithm first checks the middle value to see how it compares with the desired value. If the middle value is bigger than the desired value, the algorithm won’t bother looking at the values on the right half of the array; since the array is sorted, values to the right of the middle value can only get bigger.

In the other case, if the middle value is smaller than the desired value, the algorithm won’t look at the left side of the array. This is a small but meaningful optimization that cuts the number of comparisons by half.

When you have an input size of 100, halving the comparisons means you save 50 comparisons. If input size was 100,000, halving the comparisons means you save 50,000 comparisons. The more data you have, the more the halving effect scales. Thus, you can see that the graph appears to approach horizontal.

*/

func naiveContains(_ value: Int, in array: [Int]) -> Bool {
    
    guard !array.isEmpty else { return false }
    let middleIndex = array.count / 2

    if value <= array[middleIndex] {
        for index in 0...middleIndex {
            if array[index] == value {
                return true
            }
        }
    } else {
        for index in middleIndex..<array.count {
            if array[index] == value {
                return true
            }
        }
    }

    return false

}
