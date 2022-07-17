var scores: [String: Int] = ["Eric": 9, "Mark": 12, "Wayne": 1]

/* Dictionaries don’t have any guarantees of order, nor can you insert at a specific index. They also put a requirement on the Key type that it be Hashable. */

/* You can add a new entry to the dictionary with the following syntax: */

scores["Andrew"] = 0
print(scores) // ["Eric": 9, "Mark": 12, "Andrew": 0, "Wayne": 1]

/* It is possible to traverse through the key-values of a dictionary multiple times as the Collection protocol affords. This order, while not defined, will be the same every time it is traversed until the collection is changed (mutated).

The lack of explicit ordering disadvantage comes with some redeeming traits.

Unlike the array, dictionaries don’t need to worry about elements shifting around. Inserting into a dictionary always takes a constant amount of time. */