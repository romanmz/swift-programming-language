
// There's 3 types of closures:
// +name -captures  Global functions
// +name +captures  Nested functions, capture values from enclosing function
// -name +captures  Closures


// CLOSURE EXPRESSIONS
// ==================================================
// Closure expressions are a way to write inline closures in a brief, focused syntax.

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// 1. Define and use a function
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
var reversedNames = names.sorted(by: backward)

// 2. Closure expression syntax
// Same as the function, but inline and unnamed
reversedNames = names.sorted(by: {
    (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// 3. Inferring types from context
// Parameter and return types can be ommited if they can be inferred
reversedNames = names.sorted(by: {
    s1, s2 in
    return s1 > s2
})

// 4. Implicit returns from single-expression closures
// If the closure only has one expression, the 'return' keyword can be ommited
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })

// 5. Shorthand argument names ($0, $1, etc…)
// Swfit automatically adds numbered variables that capture the arguments values
// You can use those instead of defining custom argument names
reversedNames = names.sorted(by: { $0 > $1 })

// 6. Operator methods
// Each type has its own implementation of operators (==, <, >, etc) as class methods
// Those methods have their own type just like any other function
// So if the operator method fits within the context, you can pass just the operator as an argument
reversedNames = names.sorted(by: >)


// TRAILING CLOSURES
// ==================================================
// If the last argument of a method is a closure, it can be passed unnamed and after the closing bracket of the function
reversedNames = names.sorted() { $0 > $1 }

// If the closure is the only argument the function takes, then the brackets of the function can be ommited
reversedNames = names.sorted { $0 > $1 }



// CAPTURING VALUES
// ==================================================
// Same as in JS



// CLOSURES ARE REFERENCE TYPES
// ==================================================
// If a closure is passed to a variable or constant, what is stored is a reference to that closure, not the closure itself
// This means that a constant with a closure can't change to use a different closure, but the closure itself can still change its internal values
// In the same way, if there are two or more different variables or constants pointing to the same closure, the internal values of the closure will be the same on every case



// ESCAPING CLOSURES
// ==================================================
// When a function takes a closure as an argument, but that closure needs to be executed outside the function itself or/and after the function has ended, then they are called escaping closures
// To mark a closure as an escaping closure use the @escaping keyword
var completionHandlers: [() -> Void] = []
func escapingFunc(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
func nonEscapingFunc(closure: () -> Void) {
    closure()
}

// When using variables, constants and properties within an escaping closure, you need to use the self keyword
class SomeClass {
    var x = 10
    func doSomething() {
        escapingFunc { self.x = 100 }
        nonEscapingFunc { x = 200 }
    }
}
let instance = SomeClass()
instance.doSomething()
print(instance.x)

completionHandlers.first?()
print(instance.x)



// AUTOCLOSURES
// ==================================================
// Autoclosures allow you to delay the execution of a closure passed as a parameter to a function or method
// Thanks to this you can omit the brackets when passing the closure as an argument
// This only works for closures that don't take any arguments, and the return type still needs to be of the correct type as defined in the function or method
// To allow autoclosures in a function, add the @autoclosure keyword
var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0))
