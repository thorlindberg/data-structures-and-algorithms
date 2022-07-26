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

// Challenge 1: Print in reverse

private func printInReverse<T>(_ node: Node<T>?) {
    guard let node  else { return }
    printInReverse(node.next)
    print(node.value)
}

func printInReverse<T>(_ list: LinkedList<T>) {
    printInReverse(list.head)
}

// Challenge 2: Find the middle node

private func length<T>(_ list: LinkedList<T>) -> Int {
    var nodes: Int = 0
    var node: Node<T>? = list.head
    while let current: Node<T> = node {
        nodes += 1
        node = current.next
    }
    return nodes
}

func middleNode<T>(_ list: LinkedList<T>) -> Node<T>? {
    let length: Int = length(list)
    let middle: Int = length / 2
    if let node: Node<T> = list.node(at: middle) {
        return node
    }
    return nil
}

/* runner’s technique */

func getMiddle<T>(_ list: LinkedList<T>) -> Node<T>? {
    var slow = list.head
    var fast = list.head
    while let nextFast = fast?.next {
        fast = nextFast.next
        slow = slow?.next
    }
    return slow
}

// Challenge 3: Reverse a linked list

private func reverse<T>(_ list: LinkedList<T>) -> LinkedList<T> {
    var reversed: LinkedList<T> = LinkedList<T>()
    var node: Node<T>? = list.head
    while let current: Node<T> = node {
        reversed.push(current.value)
        node = current.next
    }
    return reversed
}

/* without temporary list */

private func reverse<T>(_ list: inout LinkedList<T>) -> Void {
    list.tail = list.head
    var previous: Node<T>? = list.head
    var current: Node<T>? = list.head?.next
    previous?.next = nil
    while current != nil {
        let next: Node<T>? = current?.next
        current?.next = previous
        previous = current
        current = next
    }
    list.head = previous
}

// Challenge 4: Merge two lists

private func mergeSorted<T: Comparable>(
    _ first: LinkedList<T>,
    _ second: LinkedList<T>
) -> LinkedList<T> {
    guard !first.isEmpty else { return second }
    guard !second.isEmpty else { return first }
    var newhead: Node<T>?
    var tail: Node<T>?
    var currentleft: Node<T>? = first.head
    var currentright: Node<T>? = second.head
    if let left = currentleft, let right = currentright {
        if left.value < right.value {
            newhead = left
            currentleft = left.next
        } else {
            newhead = right
            currentright = right.next
        }
        tail = newhead
    }
    while let left = currentleft, let right = currentright {
        if left.value < right.value {
            tail?.next = left
            currentleft = left.next
        } else {
            tail?.next = right
            currentright = right.next
        }
        tail = tail?.next
    }
    if let left = currentleft {
        tail?.next = left
    }
    if let right = currentright {
        tail?.next = right
    }
    var merged: LinkedList<T> = LinkedList<T>()
    merged.head = newhead
    merged.tail = {
        while let next = tail?.next {
            tail = next
        }
        return tail
    }()
    return merged
}

// Challenge 5: Remove all occurrences

private func removeAll<T: Equatable>(
    _ value: T,
    _ list: inout LinkedList<T>
) -> Void {
    while let head = list.head, head.value == value {
        list.head = head.next
    }
    var prev = list.head
    var current = list.head?.next
    while let currentNode = current {
        guard currentNode.value != value else {
            prev?.next = currentNode.next
            current = prev?.next
            continue
        }
        prev = current
        current = current?.next
    }
    list.tail = prev
}

var list: LinkedList<Int> = LinkedList<Int>()
list.push(4)
list.push(3)
list.push(3)
list.push(3)
list.push(1)
print(list)
removeAll(3, &list)
print(list)