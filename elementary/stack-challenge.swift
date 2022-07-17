public struct Stack<Element> {
    
    private var storage: [Element] = []
   
    public init() { }

    public init(_ elements: [Element]) {
        storage = elements
    }

    public mutating func push(_ element: Element) {
        storage.append(element)
    }

    @discardableResult
    public mutating func pop() -> Element? {
        storage.popLast()
    }

    public func peek() -> Element? {
        storage.last
    }

    public var isEmpty: Bool {
        peek() == nil
    }

}

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

// Challenge 1: Reverse an Array

/* Create a function that uses a stack to print the contents of an array in reversed order. */

func printReverse<Element>(_ array: Array<Element>) {

    // create Stack

    var stack = Stack<Element>()

    // push Array elements to Stack
    
    for element in array {
        stack.push(element)
    }

    // pop -> print elements of Stack

    while let element = stack.pop() {
        print(element)
    }

}

printReverse([1, 2, 3, 4, 5, 6, 7, 8])

/* The time complexity of pushing the nodes into the stack is O(n). The time complexity of popping the stack to print the values is also O(n). Overall, the time complexity of this algorithm is O(n).

Since you’re allocating a container (the stack) inside the function, you also incur a O(n) space complexity cost. */

// Challenge 2: Balance the parentheses

/*

Check for balanced parentheses. Given a string, check if there are ( and ) characters, and return true if the parentheses in the string are balanced.

balanced parentheses:
h((e))llo(world)()

unbalanced parentheses:
(hello world

*/

func isBalanced(_ string: String) -> Bool {

    // create Stack

    var stack = Stack<Character>()

    // push String elements to Stack
    
    for char in string {
        stack.push(char)
    }

    // pop -> count elements of Stack

    var left: Int = 0
    var right: Int = 0

    while let element = stack.pop() {
        if element == "(" {
            left += 1
        }
        if element == ")" {
            right +=  1
        }
    }

    return left == right
    
}

print(isBalanced("h((e))llo(world)()")) // true
print(isBalanced("(hello world")) // false

func checkParentheses(_ string: String) -> Bool {

    var stack = Stack<Character>()

    for character in string {
        if character == "(" {
            stack.push(character)
        } else if character == ")" {
            if stack.isEmpty {
                return false
            } else {
                stack.pop()
            }
        }
    }

    return stack.isEmpty

}

print(checkParentheses("h((e))llo(world)()")) // true
print(checkParentheses("(hello world")) // false

/* The time complexity of this algorithm is O(n), where n is the number of characters in the string. This algorithm also incurs an O(n) space complexity cost due to the usage of the Stack data structure. */