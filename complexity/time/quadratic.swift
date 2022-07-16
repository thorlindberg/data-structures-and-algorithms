// The Big O notation for quadratic time is O(n²).

func printNames(names: [String]) {
    for _ in names {
        for name in names {
            print(name)
        }
    }
}