

// GENERICS
// ==================================================

// Generic code enables you to write flexible, reusable functions and types that can work with any type, subject to requirements that you define
// The 'Array' and 'Dictionary' types are examples of generics, as they can hold collections of any type


// GENERIC FUNCTIONS
// ------------------------------

// EXAMPLE:

// This function swaps the values of two Int variables
// but if you want to do the same with other types, you would need to create extra functions
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// Or you can write it using a generic type like this:
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var int1 = 10
var int2 = 20
var string1 = "abc"
var string2 = "def"
swapTwoValues( &int1, &int2 )
swapTwoValues( &string1, &string2 )
int1
int2
string1
string2


// SYNTAX:
// You tell the function to accept generic 'placeholder' types by adding angle brackets after the function name:
// functionName<T>
// inside the brackets you can add any name, this name will be used to represent any type of value
// which then you can use on the parameters list:
// (parameter1: T, parameter2: T)
// and as the return type
// () -> T
// also for setting properties and variables
// var items = [T]
// In this example both parameters are required to have a value of type 'T'
// which means they can get values of any type, but both of them should be of the same type

// To accept more than 1 types of variables, add more placeholders inside the angle brackets:
// functionName<T,U>(parameter1: T, parameter2: U)
// In this example the function accepts two values of any type, and the types of both values don't necessarily need to be the same (but they can be)

// The name of the placeholder types can be more specific if it makes sense for the function
// functionName<Key,Value>


// GENERIC TYPES
// ------------------------------
// In addition to generic functions, you can also define your own generic types
// These are custom classes, structures, and enumerations that can work with any type, in a similar way to Array and Dictionary

// let's say you need to create a simple type for managing 'stack' collections where you're only allowed to 'push' or 'pop' items from the list

// A non-generic version that works only with Int values would look like this:
struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// The struct can be rewritten as a generic type so you can use it with any type of values:
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

// You define a variable to use a generic type by also adding angle brackets and pass the actual type you'll be using for that variable:
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
stackOfStrings.items.count


// EXTENDING A GENERIC TYPE
// ------------------------------
// When extending a generic type, you don't need to list the names of the placeholder types again
// they will be automatically available for you to use in the body of the extension

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {
    topItem
}


// TYPE CONSTRAINTS
// ------------------------------
// You can add restrictions to the type of values that can be used in a generic function or type
// you can require the types to:
// - Belong to a class that inherits from a specific superclass
// - Conform to a particular protocol or protocol composition

// For example, the standard 'Dictionary' type requires that any types passed as the 'key' argument must conform to the 'Hashable' protocol (to ensure that each key can be represented as a unique value, regardless of the type used)


// SYNTAX:
// To add restrictions to a type parameter, add a colon after its name followed by the superclass(es) or protocol(s) it needs to conform to
// func someFunction<T: SomeClass, U: SomeProtocol>(parameter1: T, parameter2: U)


// EXAMPLE:

// This is a non-generic function to get the Int key that contains a given value in a Strings array
func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
    "The index of llama is \(foundIndex)"
}

// In order to make a generic version of this function, we need to make sure that the types used in the array allow themselves to be compared with each other (using the != and == operators)
// For this Swift has a standard protocol called 'Equatable', so any type that conforms to that protocol can be used on this function
// This is the generic version of the previous function, including the necessary type constraint:
func findIndexGeneric<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
findIndexGeneric(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
findIndexGeneric(of: 0.1, in: [3.14159, 0.1, 0.25])
findIndexGeneric(of: 9.3, in: [3.14159, 0.1, 0.25])


// ASSOCIATED TYPES (GENERIC PROTOCOLS)
// ------------------------------
// To name a type parameter inside a protocol, use the 'associatedtype' keyword
// followed by the placeholder name you want to use
// you can then use that type parameter name elsewhere in the protocol definition

// This sample protocol adds an associated type named 'Item'
// And uses it as the parameter type for the 'append' method, and the return value of the subscript:
protocol Container {
    associatedtype Item
    var count: Int { get }
    mutating func append(_ item: Item)
    subscript(i: Int) -> Item { get }
}

// So any type that conforms to this protocol can use any type of value on those two methods,
// but it must be the same type on both of them

// This non-generic struct conforms to the protocol, always using Int values:
struct IntContainer: Container {
    var items = [Int]()
    
    // Conformance to the 'Container' protocol
    // typealias Item = Int
    var count: Int {
        return items.count
    }
    mutating func append(_ item: Int) {
        items.append(item)
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// The 'typealias Item = Int' line allows you to use 'Item' as a type name (in this case making it equivalent to the 'Int' type)
// you can use this typealias to match the same placeholder name(s) used on the protocol definition
// but the code is still valid if you just pass the actual types to be used, as long as they meet the requirements defined on the protocol
// in this case the protocol requires that the values passed to 'append' and the return value of the subscript should both be of the same type
// this struct meets that requirement by using 'Int' on both of them, so the typealias becomes redundant

// Here's the same struct written as a generic type:
struct GenericContainer<Element>: Container {
    var items = [Element]()
    
    // Conformance to the 'Container' protocol
    // typealias Item = Element
    var count: Int {
        return items.count
    }
    mutating func append(_ item: Element) {
        items.append(item)
    }
    subscript(i: Int) -> Element {
        return items[i]
    }
}

// You can extend an existing type to declare conformance to a generic protocol the same way as with regular protocols
extension Array: Container {}


// GENERIC 'WHERE' CLAUSES
// ------------------------------

// Type constraints allow you to add restrictions to the type of values that can be used within a particular function or type
// But you can also add restrictions for the 'associated types' of those types
// -- When a type conforms to a generic protocol, it keeps track of what's the actual type it is using in place of the 'associated type(s)' defined by the protocol

// For example in the 'IntContainer' struct defined before, the 'Item' associated type defined by the protocol becomes of 'Int' type
// and on the 'GenericContainer' struct it becomes a generic 'Element' type, which in turn can become any other type
// To add constraints to associated types, you add a 'where' clause after the function or type definition, right before the opening brace

// You can add constraints to associated types based on:
// - conformance to a protocol, or
// - equality relationships between types and associated types

// The following functions has these requirements:
// Type constraints: 'container1' and 'container2' can get values of different types
// Type constraints: 'container1' and 'container2' can only get values of types that conform to the 'Container' protocol
// Associated type constraints: The associated type (Item) of both values must be of the same type (e.g. both Int's, or both String's, etc…)
// Associated type constraints: The associated type (Item) of 'container1' must conform to the 'Equatable' protocol
//      (and since the associated type of 'container2' is of the same type, we can assume that it also conforms to that protocol)

// (you can also add type constraints to the 'where' clause, but in this case the requirements set within the angle brackets are enough)

func allItemsMatch<C1: Container, C2: Container>
    (_ container1: C1, _ container2: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {
        
        // Check that both containers contain the same number of items.
        if container1.count != container2.count {
            return false
        }
        
        // Check each pair of items to see if they are equivalent.
        for i in 0..<container1.count {
            if container1[i] != container2[i] {
                return false
            }
        }
        
        // All items match, so return true.
        return true
}

var stringContainer = GenericContainer<String>()
stringContainer.append("uno")
stringContainer.append("dos")
stringContainer.append("tres")
var stringArray1 = ["uno", "dos", "tres"]
var stringArray2 = ["cuatro", "cinco", "seis"]
var intArray = [1,2,3]

// OK: two values of the same type
allItemsMatch(stringArray1, stringArray2)

// OK: two values of different types, but meeting all the requirements
allItemsMatch(stringContainer, stringArray1)

// ERROR: two values of different types, not meeting all the requirements
// allItemsMatch(intArray, stringArray1)


// EXTENSIONS WITH A GENERIC 'WHERE' CLAUSE
// ------------------------------

// You can add extensions to types and protocols, but have the new functionality be available only for instances that meet certain requirements

// TYPE EXAMPLE
// -----
// For example this extension adds an 'isTop' function to the 'GenericContainer' struct,
// but it's using type constraints to add this function only to instances where the 'Element' type parameter
// was replaced with a type that conforms to the 'Equatable' protocol
extension GenericContainer where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

// 'String' conforms to the 'Equatable' protocol, so 'isTop' becomes available
var testString = GenericContainer<String>()
testString.append("lorem")
testString.append("ipsum")
testString.append("dolor")
testString.isTop("lorem")
testString.isTop("dolor")

// doesn't work on types that don't conform to 'Equatable'
struct NotEquatable {}
var dummyStruct = NotEquatable()
var testNotEquatable = GenericContainer<NotEquatable>()
testNotEquatable.append( dummyStruct )
testNotEquatable.count
// ERROR: isTop is not available:
// testNotEquatable.isTop( dummyStruct )


// PROTOCOL EXAMPLE
// -----
// When extending protocols you can add constraints based on its associated types:

extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}
testString.startsWith("lorem")
testString.startsWith("dolor")
// ERROR:
// testNotEquatable.startsWith( dummyStruct )


// You can also add constraints matching exact types:
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum / Double(count)
    }
}
[1260.0, 1200.0, 98.6, 37.0].average()
// ERROR:
// testString.average()


// ASSOCIATED TYPES WITH A GENERIC 'WHERE' CLAUSE
// ------------------------------

// You can add 'where' clauses when defining associated types of a protocol
protocol Container2 {
	associatedtype Item
	mutating func append(_ item: Item)
	var count: Int { get }
	subscript(i: Int) -> Item { get }
	
	associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
	func makeIterator() -> Iterator
}

// If you need to add restrictions to the associated types of a protocol you're inheriting from, you can add a 'where' clause on the protocol definition itself
protocol Container3: Container2 where Item: Comparable {}

// When using associated types on a protocol, you can add a condition so that the associated type conforms to the same protocol you're currently defining
// this is helpful to make sure the elements introduced by the protocol have the same type as the type that is adopting the protocol
// (or another type that has also adopted the same protocol)
protocol SuffixableContainer: Container {
    associatedtype Suffix: SuffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}


// GENERIC SUBSCRIPTS
// ------------------------------

// Subscripts can also accept generics, and they can include 'where' clauses
/*
struct GenericSubscripts: Container {
	var items: [Item] = []

	// in this example, the subscript accepts only a sequence of integers
	subscript<Indices: Sequence>(indices: Indices) -> [Item] where Indices.Iterator.Element == Int {
		var result: [Item] = []
		for index in indices {
			result.append( self[index] )
		}
		return result
	}
}
*/


// -+-+-+-+-
// (C1 and C2 are 'type parameters')
