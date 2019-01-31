
// Basic syntax
func foo() {
    print( "this does nothing lol")
}
foo()

// Just like with types, you need to specify the type of the arguments, and also for the return value
func openWebsite(url:String, tabs:Int) -> String {
    return "content"
}

// Functions without a return value actually return an empty tuple (), also called "Void"

// There can be multiple functions with the same name, if they accept different arguments
func greet(person: String) -> String {
    return "Hello \( person )"
}
func greet(person: String, count:Int) -> String {
    guard count >= 2 else {
        return greet(person:person)
    }
    
    var greeting = "Hello"
    for _ in 2...count {
        greeting += " hello"
    }
    greeting += " \( person )"
    return greeting
}
func greet(pet: String) -> String {
    return "Good boy \(pet)!"
}
greet(person: "Joe")
greet(person: "Paul", count: 3)
greet(pet: "Fido")

// When a function returns a tuple, the values of the tuple can be labeled within the function definition
func minMax(array: [Int]) -> (min: Int, max: Int)? {
    if array.isEmpty { return nil }
    var currentMin = array[0]
    var currentMax = array[0]
    for value in array[1..<array.count] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}
if let bounds = minMax(array: [8, -6, 2, 109, 3, 71]) {
    bounds.min
    bounds.max
}

// When naming the arguments of a function you can specify a different label to be used when calling the function
// These are called "argument labels", you set it before the label to be used internally within the function
// Use an underscore to indicate that the argument doesn't need to be named when calling the function
func greet(_ person: String, from hometown: String) -> String {
    return "Hello \(person)! Glad you could visit from \(hometown)."
}
greet("Pat", from:"Boston")

// Default values
func addNumbers(number: Int, add: Int = 10) -> Int {
    return number + add
}
addNumbers(number: 50, add:20)
addNumbers(number: 50)

// Variadic parameters
// You can make an argument accept an indeterminate number of values by adding three dots after the argument type
// the values will be available in the function as an array of the defined type
func average(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
average(3, 8.25, 18.75)

// In-out parameters
// By default functions don't alter any data outside of them and the arguments are set as constants
// You can change this behaviour by adding the 'inout' keyword before the type of an argument
// In those cases you can only pass variables to those arguments of the function (not constants), and you need to prepend an '&' character
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var myAge = 33
var yourAge = 40
swapTwoInts(&myAge, &yourAge)
myAge
yourAge

// Each function has a type, which works just like any other types in Swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
var mathFunction: (Int, Int) -> Int = addTwoInts
mathFunction(3, 4)
mathFunction = multiplyTwoInts
mathFunction(3, 4)

// Functions can accept other functions as parameters
func runFunction(_ function:(Int,Int)->Int, _ a:Int, _ b:Int) -> Int {
    let result:Int = function(a, b)
    return result
}
runFunction(multiplyTwoInts, 10, 7)

// And they can also return other functions
func multiplyFunc(_ factor: Int) -> (Int)->Int {
    func newFunc(_ number: Int) -> Int {
        return number * factor
    }
    return newFunc
}
let multiplyBy3 = multiplyFunc(3)
var multiplyInt = 3
multiplyInt = multiplyBy3( multiplyInt )
multiplyInt = multiplyBy3( multiplyInt )

// Nested functions
// As seen on the previous example, functions can have other nested functions inside them
// Those nested functions are only available within the scope of the enclosing function
// Unless they are specifically returned by the enclosing function to be used on other scopes
