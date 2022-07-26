/*

A linked list is a collection of values arranged in a linear, unidirectional sequence.

Constant time insertion and removal from the front of the list.
Reliable performance characteristics.

As the diagram suggests, a linked list is a chain of nodes. Nodes have two responsibilities:
- Hold a value.
- Hold a reference to the next node. A nil value represents the end of the list.

*/

// NODE

public class Node<Value> {

    public var value: Value
    public var next: Node?

    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }

}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else {
            return "\(value)"
        }
        return "\(value) -> " + String(describing: next) + " "
    }
}

/* Create three nodes and connect them: */

let node1 = Node(value: 1)
let node2 = Node(value: 2)
let node3 = Node(value: 3)

node1.next = node2
node2.next = node3

print(node1)

// LINKEDLIST

/* A linked list has the concept of a head and tail, which refers to the first and last nodes of the list. */

public struct LinkedList<Value> {

    public var head: Node<Value>?
    public var tail: Node<Value>?

    public init() {}

    public var isEmpty: Bool {
        head == nil
    }

    public mutating func push(_ value: Value) {
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }

    public mutating func append(_ value: Value) {

        guard !isEmpty else {
            push(value)
            return
        }

        tail!.next = Node(value: value)

        tail = tail!.next

    }

    public func node(at index: Int) -> Node<Value>? {

        var currentNode = head
        var currentIndex = 0

        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }

        return currentNode

    }
    
    /* @discardableResult lets callers ignore the return value of this method without the compiler jumping up and down warning you about it. */
    
    @discardableResult
    public mutating func insert(
        _ value: Value,
        after node: Node<Value>
    ) -> Node<Value> {

        guard tail !== node else {
            append(value)
            return tail!
        }

        node.next = Node(value: value, next: node.next)
        return node.next!

    }

    @discardableResult
    public mutating func pop() -> Value? {
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }

    @discardableResult
    public mutating func removeLast() -> Value? {

        guard let head = head else {
            return nil
        }

        guard head.next != nil else {
            return pop()
        }

        var prev = head
        var current = head

        while let next = current.next {
            prev = current
            current = next
        }

        prev.next = nil
        tail = prev

        return current.value

    }

    @discardableResult
    public mutating func remove(after node: Node<Value>) -> Value? {
        guard let node = copyNodes(returningCopyOf: node) else { return nil }
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }

    private mutating func copyNodes() {

        guard !isKnownUniquelyReferenced(&head) else {
            return
        }

        guard var oldNode = head else {
            return
        }

        head = Node(value: oldNode.value)
        var newNode = head

        while let nextOldNode = oldNode.next {
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next

            oldNode = nextOldNode
        }

        tail = newNode

    }

    private mutating func copyNodes(returningCopyOf node: Node<Value>?) -> Node<Value>? {
        guard !isKnownUniquelyReferenced(&head) else {
            return nil
        }
        guard var oldNode = head else {
            return nil
        }

        head = Node(value: oldNode.value)
        var newNode = head
        var nodeCopy: Node<Value>?

        while let nextOldNode = oldNode.next {
            if oldNode === node {
                nodeCopy = newNode
            }
            newNode!.next = Node(value: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }

        return nodeCopy
    }

}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else {
            return "Empty list"
        }
        return String(describing: head)
    }
}

extension LinkedList: Collection {

    public struct Index: Comparable {

        public var node: Node<Value>?

        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }

        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }

    }

    public var startIndex: Index {
        Index(node: head)
    }

    public var endIndex: Index {
        Index(node: tail?.next)
    }

    public func index(after i: Index) -> Index {
        Index(node: i.node?.next)
    }

    public subscript(position: Index) -> Value {
        position.node!.value
    }
    
}

// ADD VALUES

/* There are three ways to add values to a linked list, each having unique performance characteristics:

- push: Adds a value at the front of the list.
- append: Adds a value at the end of the list.
- insert(after:): Adds a value after a particular list node. */

// push operation

var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)
print(list)

// append operation

/* Like before, if the list is empty, you’ll need to update both head and tail to the new node. Since append on an empty list is functionally identical to push, you invoke push to do the work for you.

You create a new node after the tail node in all other cases. Force unwrapping is guaranteed to succeed since you push in the isEmpty case with the above guard statement.

Since this is tail-end insertion, your new node is also the tail of the list. */

var list = LinkedList<Int>()
list.append(1)
list.append(2)
list.append(3)
print(list)

// insert(after:) operation

/* This operation inserts a value at a particular place in the list and requires two steps:
1. Finding a particular node in the list.
2. Inserting the new node. */

/* You create a new reference to head and track the current number of traversals.

Using a while loop, you move the reference down the list until you’ve reached the desired index. Empty lists or out-of-bounds indexes will result in a nil return value. */

var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)

print("Before inserting: \(list)")
var middleNode = list.node(at: 1)!
for _ in 1...4 {
    middleNode = list.insert(-1, after: middleNode)
}
print("After inserting: \(list)")

// REMOVE VALUES

/* There are three main operations for removing nodes:
- pop: Removes the value at the front of the list.
- removeLast: Removes the value at the end of the list.
- remove(at:): Removes a value anywhere in the list. */

// pop operation

/* By moving the head down a node, you’ve effectively removed the first node of the list. ARC will remove the old node from memory once the method finishes since no more references will be attached to it. If the list becomes empty, you set tail to nil. */

var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)

print("Before popping list: \(list)")
let poppedValue = list.pop()
print("After popping list: \(list)")
print("Popped value: " + String(describing: poppedValue))

// removeLast operation

/* Although you have a reference to the tail node, you can’t chop it off without having a reference to the node before it. Thus, you’ll have to do an arduous traversal. */

var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)

print("Before removing last node: \(list)")
let removedValue = list.removeLast()

print("After removing last node: \(list)")
print("Removed value: " + String(describing: removedValue))

/* removeLast requires you to traverse all the way down the list. This makes for an O(n) operation, which is relatively expensive. */

// remove(after:) operation

/* You’ll first find the node immediately before the node you wish to remove and then unlink it. */

var list = LinkedList<Int>()
list.push(3)
list.push(2)
list.push(1)

print("Before removing at particular index: \(list)")
let index = 1
let node = list.node(at: index - 1)!
let removedValue = list.remove(after: node)

print("After removing at index \(index): \(list)")
print("Removed value: " + String(describing: removedValue))

/* Similar to insert(at:), the time complexity of this operation is O(1), but it requires you to have a reference to a particular node beforehand. */

// COLLECTION PROTOCOLS

/* Tier 1, Sequence: A sequence type provides sequential access to its elements. It comes with an important caveat: Using the sequential access may destructively consume the elements so that you can’t revisit them.

Tier 2, Collection: A collection type is a sequence type that provides additional guarantees. A collection type is finite and allows for repeated nondestructive sequential access.

Tier 3, BidirectionalColllection: A collection type can be a bidirectional collection type if it, as the name suggests, can allow for bidirectional travel up and down the sequence. This isn’t possible for the linked list since you can only go from the head to the tail, but not the other way around.

Tier 4, RandomAccessCollection: A bidirectional collection type can be a random-access collection type if it can guarantee that accessing an element at a particular index will take just as long as access an element at any other index. This is not possible for the linked list since accessing a node near the front of the list is substantially quicker than one further down the list. */

// BECOMING A SWIFT COLLECTION

/* A collection type is a finite sequence and provides nondestructive sequential access. A Swift Collection also allows for access via a subscript, a fancy term for saying an index can be mapped to a value in the collection. */

array[5]

// Custom collection indexes

/* Unlike other storage options such as the Swift Array, the linked list cannot achieve O(1) subscript operations using integer indexes. Thus, your goal is to define a custom index that contains a reference to its respective node. */

var list = LinkedList<Int>()
for i in 0...9 {
    list.append(i)
}

print("List: \(list)")
print("First element: \(list[list.startIndex])")
print("Array containing first 3 elements: \(Array(list.prefix(3)))")
print("Array containing last 3 elements: \(Array(list.suffix(3)))")

let sum = list.reduce(0, +)
print("Sum of all values: \(sum)")

// Value semantics and copy-on-write

/* Another important quality of a Swift collection is that it has value semantics. This is implemented efficiently using copy-on-write, hereby referred to as COW. */

let array1 = [1, 2]
var array2 = array1

print("array1: \(array1)")
print("array2: \(array2)")

print("---After adding 3 to array 2---")
array2.append(3)
print("array1: \(array1)")
print("array2: \(array2)")

/* The strategy to achieve value semantics with COW is reasonably straightforward. Before mutating the contents of the linked list, you want to perform a copy of the underlying storage and update all references (head and tail) to the new copy. */

// OPTIMIZING COW (Copy On Write)

/* The O(n) overhead on every mutating call is unacceptable. Two strategies help alleviate this problem. The first is to avoid copying when the nodes only have one owner. */

// isKnownUniquelyReferenced

/* In the Swift standard library lives a function named isKnownUniquelyReferenced. This function can be used to determine whether or not an object has exactly one reference to it. */

var list1 = LinkedList<Int>()
list1.append(1)
list1.append(2)
print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list1.head))")
var list2 = list1
print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list1.head))")
print("List1: \(list1)")
print("List2: \(list2)")

print("After appending 3 to list2")
list2.append(3)
print("List1: \(list1)")
print("List2: \(list2)")

/* Using isKnownUniquelyReferenced, you can check whether or not the underlying node objects are shared. */

// A minor predicament

/* The remove operation is no longer working. The reason for this lies in the CoW optimization we made. Because every mutation can trigger a copy of the nodes, the remove(after:) implementation is making a removal on the wrong set of nodes. To rectify that, you’ll write a specialized version of the copyNodes method. */

var list1 = LinkedList<Int>()
list1.append(1)
list1.append(2)
print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list1.head))")
var list2 = list1
print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list1.head))")
print("List1: \(list1)")
print("List2: \(list2)")

print("After appending 3 to list2")
list2.append(3)
print("List1: \(list1)")
print("List2: \(list2)")

print("Removing middle node on list2")
if let node = list2.node(at: 0) {
    list2.remove(after: node)
}
print("List2: \(list2)")

// Sharing nodes

/* The second optimization is a partial sharing of nodes. As it turns out, there are certain scenarios where you can avoid a copy. The unidirectional nature of the linked list means that head-first insertions can ignore the “COW tax”! */