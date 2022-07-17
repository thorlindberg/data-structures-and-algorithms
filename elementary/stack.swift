/* There are only two essential operations for a stack:
- push: Adding an element to the top of the stack.
- pop: Removing the top element of the stack.

In computer science, a stack is known as a LIFO (last-in-first-out) data structure. Elements that are pushed in last are the first ones to be popped out.

Memory allocation uses stacks at the architectural level. Memory for local variables is also managed using a stack.

Key points:

A stack is a LIFO, last-in first-out, data structure.
Despite being so simple, the stack is a key data structure for many problems.
The only two essential operations for the stack are the push method for adding elements and the pop method for removing elements. */

// HELPER

public func example(of description: String, content: () -> ()) {
    print("---Example of \(description)---")
    content()
}

// IMPLEMENTATION

/* A stack’s purpose is to limit the number of ways to access your data. Adopting protocols such as Collection would go against this goal by exposing all the elements via iterators and the subscript. In this case, less is more! */

public struct Stack<Element> {
    
    private var storage: [Element] = []
   
    public init() { }

    public init(_ elements: [Element]) {
        storage = elements
    }

    /* push and pop both have a O(1) time complexity. */

    public mutating func push(_ element: Element) {
        storage.append(element)
    }

    @discardableResult
    public mutating func pop() -> Element? {
        storage.popLast()
    }

    /* A stack interface often includes a peek operation. The idea of peek is to look at the top element of the stack without mutating its contents. */

    public func peek() -> Element? {
        storage.last
    }

    public var isEmpty: Bool {
        peek() == nil
    }

}

/* Make your stack initializable from an array literal */

extension Stack: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        storage = elements
    }
}

extension Stack: CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(storage.map { "\($0)" }.reversed().joined(separator: "\n"))"
    }
}

// EXAMPLE

example(of: "using a stack") {
    
    var stack = Stack<Int>()
    
    stack.push(1)
    stack.push(2)
    stack.push(3)
    stack.push(4)

    print(stack)

    if let poppedElement = stack.pop() {
        assert(4 == poppedElement)
        print("Popped: \(poppedElement)")
    }

    print(stack)

}

/* You might want to take an existing array and convert it to a stack to guarantee the access order. Of course it would be possible to loop through the array elements and push each element.

However, since you can write an initializer that sets the underlying private storage. Add the following to your stack implementation: */

example(of: "initializing a stack from an array") {
    let array = ["A", "B", "C", "D"]
    var stack = Stack(array)
    print(stack)
    stack.pop()
}

/* This creates a stack of Doubles and pops the top value 4.0. Again, type inference saves you from having to type the more verbose Stack<Double>. */

example(of: "initializing a stack from an array literal") {
    var stack: Stack = [1.0, 2.0, 3.0, 4.0]
    print(stack)
    stack.pop()
}
