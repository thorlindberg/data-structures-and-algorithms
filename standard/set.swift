/* A set is a container that holds unique values. Values in a set have no notion of order. */

var bag: Set<String> = ["Candy", "Juice", "Gummy"]
bag.insert("Candy")
print(bag) // prints ["Candy", "Juice", "Gummy"]

/* Finding duplicate elements in a collection of values: */

let values: [String] = [...]
var bag: Set<String> = []

for value in values {
    if bag.contains(value) {
        print("\(value) already in bag")
    }
    bag.insert(value)
}