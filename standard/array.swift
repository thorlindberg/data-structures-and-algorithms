// array literal

let people = ["Brian", "Stanley", "Ringo"]

/* Swift defines arrays using protocols. Each of these protocols layers more capabilities on the array.

For example:
- An Array is a Sequence, which means that you can iterate through it at least once.
- It is also a Collection, which means it can be traversed multiple times, non-destructively, and accessed using a subscript operator.
- An array is also a RandomAccessCollection, which makes guarantees about efficiency.

The Swift Array is known as a generic collection, because it can work with any type. In fact, most of the Swift standard library is built with generic code. */

// order

/* Elements in an array are explicitly ordered. */

people[0] // "Brian"
people[1] // "Stanley"
people[2] // "Ringo"

// random-access

/* Random-access is a trait that data structures can claim if they can handle element retrieval in a constant amount of time. */

// PERFORMANCE

// insertion location

/* Inserting "Charles" using the append method will place the string at the end of the array. This is a constant-time operation, meaning the time it takes to perform this operation stays the same no matter how large the array becomes. */

people.append("Charles")
print(people) // prints ["Brian", "Stanley", "Ringo", "Charles"]

/* If he were terribly rude, he’d try to insert himself at the head of the line. This is the worst-case scenario because every person in the lineup would need to shuffle back to make room for this new person in front!

To be precise, every element must shift backward by one index, which takes n steps. If the number of elements in the array doubles, the time required for this insert operation will also double. */

people.insert("Andy", at: 0)
print(people)  // ["Andy", "Brian", "Stanley", "Ringo", "Charles"]

/* If inserting elements in front of a collection is a common operation for your program, you may want to consider a different data structure to hold your data. */

// capacity

/* The second factor that determines the speed of insertion is the array’s capacity.

Swift arrays are allocated with a predetermined amount of space for its elements. If you try to add new elements to an array that is already at maximum capacity, the Array must restructure itself to make more room for more elements. This is done by copying all the current elements of the array in a new and bigger container in memory. However, this comes at a cost; Each element of the array has to be visited and copied.

This means that any insertion, even at the end, could take n steps to complete if a copy is made. Each time it runs out of storage and needs to copy, it doubles the capacity. */