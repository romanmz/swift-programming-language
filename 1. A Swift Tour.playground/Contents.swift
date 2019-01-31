

// VARS & CONSTANTS
// ------------------------------

var myVar = 1
myVar = 2
let myConstant = 10
// Returns an error:
// myConstant = 11

// They can be declared with no value, but you need to specify a type
var holderVar:Int
let holderConstant:Int

// If a value is passed, the type can be defined explicitely or implicitely
let implicitInteger = 70
let implicitDouble = 70.0
let explicitDouble:Double = 70

// Values are never implicitely converted to another type
let testLabel1 = "The width is "
let testLabel2 = 94
let testLabel = testLabel1 + String( testLabel2 )
// Returns an error:
// let testLabel = testLabel1 + testLabel2

// Shortcut for converting to string:
let apples = 3
let oranges = 5
let fruitSummary = "I have \( apples + oranges ) pieces of fruit"


// VARIABLE TYPES
// ------------------------------

// Create arrays and dictionaries using brackets
var colours = [ "red", "green", "blue", ]
var countries = [ "au": "Australia", "us": "United States of America" ]
colours[0]
countries["au"]

// Creating empty explicit arrays/dicts
var emptyArray = [String]()
var emptyDict = [String: Int]()

// Passing an empty array/dict
emptyArray = []
emptyDict = [:]

// Defining a parameter of a function
// [Int]
// [String:Int]

// TUPLES
// Tuples can contain multiple properties of different types, but always with the same structure
var implicitTuple = (name: "John", email: "john@email.com", age:27)
let explicitTuple: (name: String, email: String, age: Int)
explicitTuple = (name: "Lachlan", email: "lachlan@email.com", age:30)

// You can read the properties by name or index number
implicitTuple.name
implicitTuple.0


// LOOPS & CONDITIONALS
// ------------------------------

// for-in
let individualScores = [75, 43, 103, 87, 12]
var teamScore = 0
for score in individualScores {
    teamScore += score
}
teamScore

// for-in with a dict
for (countryCode, countryName) in countries {
    countryName
}

// while
var n = 2
while n < 100 {
    n = n * 2
}
n

// repeat-while
// this ensures the operation runs at least once before checking the condition
var m = 10
repeat {
    m = m * 2
} while m < 8
m

// switch
let vegetable = "red pepper"
switch vegetable {
    case "celery":
        print("Add some raisins and make ants on a log.")
    case "cucumber", "watercress":
        print("That would make a good tea sandwich.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a spicy \(x)?")
    default:
        print("Everything tastes good in soup.")
}

// if-else
// The statement must always be an explicit boolean
if teamScore > 50 {
    print( "high score" )
} else if teamScore > 20 {
    print( "medium score" )
} else {
    print( "low score" )
}

// RANGES
// Use ... or ..< to create ranges on the fly
// ..< includes numbers up to but not including the last number
var total = 0
for i in 0..<4 {
    total = i
}
total

// ... includes the last number
total = 0
for i in 0...4 {
    total = i
}
total


// OPTIONALS
// ------------------------------

// Vars marked with "?" are "optional"
// This means they can have either a defined value of the specified type, or nil
var optionalString:String? = "Hello"
print( optionalString == nil )

// Using "let" in a conditional statement checks whether or not an optional var is set
// Also lets you get the resulting value and use it within the clause (see also switch example)
// This is called "unwrapping"
var greeting = "Hello!"
var optionalName: String? = "John Appleseed"
if let name = optionalName {
    greeting = "Hello, \(name)"
}

// Use the ?? operator to check an optional and set a default value in case it is nil
let nickName: String? = nil
let fullName: String = "John Appleseed"
let informalGreeting = "Hi \(nickName ?? fullName)"


// FUNCTIONS
// ------------------------------
// Parameters must be named and have defined types
// Use -> to define the type of the returned element
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)"
}
greet(person: "Bob", day: "Tuesday")
greet(person: "Matt", day: "Friday")

// Parameter names
// Write a custom label for a parameter before their name
// Use an underscore to allow the parameter to be passed without a label
func greet2(_ person: String, on day: String) -> String {
    return "Hello \(person), today is \(day)."
}
greet2("John", on: "Wednesday")

// Use ... to allow an argument to take a variable number of values, which are collected as an array
func acceptsArray(numbers: [Int]) -> Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}
acceptsArray(numbers: [1, 2, 3])

func acceptsArgs(numbers: Int...) -> Int {
    return acceptsArray(numbers: numbers)
}
acceptsArgs(numbers: 3, 4, 5)

// Functions can be nested, variable scope is local
var testScope = 10
func level1() -> Int {
    var testScope = 20
    func level2() -> Int {
        let testScope = 30
        return testScope
    }
    return level2()
}
level1()
// Error:
// level2()

// Functions can return other functions
func returnsFunc(factor: Int) -> (Int) -> Int {
    func returnedFunc(number: Int) -> Int {
        return number * factor
    }
    return returnedFunc
}
var customFunction = returnsFunc(factor: 3)
customFunction( 11 )

// Functions can also take other functions as arguments
func double(number: Int) -> Int {
    return number * 2
}
func takesFunc(number: Int, function: (Int) -> Int) -> Int {
    return function( number )
}
takesFunc(number: 27, function:double)


// CLOSURES
// ------------------------------

// Use curly brackets to create closures
// use "in" to separate arguments and return type from the body
var closure = {
    (number: Int) -> Int in
    let result = number * 2
    return result
}
closure( 2 )

// They can be called anonymously
var closureResult = ({
    (number: Int) -> Int in
    let result = number * 2
    return result
})( 3 )
closureResult

// Closures can be used as arguments/callbacks of functions
let closureNums = [1, 5, 6, 3, 21, 17]
var mappedNums = closureNums.map({
    (number: Int) -> Int in
    let result = number * 2
    return result
})

// Arguments and returned type can be ommited if they can be inferred
mappedNums = closureNums.map({
    number in
    let result = number * 3
    return result
})

// If a closure only has one statement, the return statement can be ommited
mappedNums = closureNums.map({ number in number * 4 })
mappedNums

// You can refer to parameters by number instead of name
mappedNums = closureNums.map({ $0 * 5 })
mappedNums

// If a closure is the last parameter passed to a function, you can have it outside the parentheses
mappedNums = closureNums.map { $0 * 6 }
mappedNums


// OBJECTS AND CLASSES
// ------------------------------

// Use "class" to create a new class
// Properties and methods are defined the same way as variables and functions
class Shape {
    
    // All properties need a value assigned,
    // either in the class declaration or on the init() function
    let className: String = "shape"
    let name: String
    var numberOfSides: Int = 0
    
    // Class instance events, no "func" keyword necessary
    init(name: String) {
        // Use "self" to refer to the class properties in case there's another var with the same name, otherwise it's not necessary
        self.name = name
    }
    deinit {
        // Clean up functions if necessary
    }
    
    // Methods
    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

// Creating instances:
var myShape = Shape(name: "hexagon")
myShape.className
myShape.name
myShape.numberOfSides
myShape.simpleDescription()

// Subclasses
class Square: Shape {
    var area: Double = 0.0
    var sideLength: Double = 0.0 {
        
        // willSet and didSet are called before and after changing a property's value
        // only AFTER class initialisation
        // on willSet the new value is assigned to the newValue var (you can change the name)
        willSet {
            area = newValue * newValue
        }
        didSet {
            //
        }
    }
    
    init(_ sideLength: Double) {
        // Use "super" to refer to the parent class
        super.init(name: "square")
        self.sideLength = sideLength
        numberOfSides = 4
    }
    
    // Properties can have getter and setter functions
    var perimeter: Double {
        get {
            return sideLength * 4
        }
        set( newPerimeter ) {
            // the argument is passed with the name newValue, you can change it by adding a different name in parentheses
            sideLength = newPerimeter / 4
        }
    }
    
    // to override methods from the parent class, you must do it explicitely by using the "override" keyword
    override func simpleDescription() -> String {
        return "A simple square shape"
    }
}
var mySquare = Square( 8 )
mySquare.sideLength
mySquare.area
mySquare.sideLength = 5
mySquare.area
mySquare.perimeter = 40
mySquare.perimeter
mySquare.sideLength
mySquare.area

// To attempt to use properties and methods of optional objects
// add an exclamation mark between the variable name and the property/method
// The result will also be an optional var
var optionalSquare: Square?
var optionalLength1 = optionalSquare?.sideLength
optionalSquare = Square( 7 )
var optionalLength2 = optionalSquare?.sideLength


// ENUMERATIONS
// ------------------------------
enum Rank: Int {
    
    // Use the "case" keyword to define them
    // Values start at 0 by default, you can change the starting point or manually set the values of each property (int, string or float)
    // Use the "rawValue" property to get the value of an enumeration case
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    
    // Enumerations can also have methods
    func description() -> String {
        
        // when looping through its own properties, you don't need to repeat "self" every time
        switch self {
            case .ace:
                return "ace"
            case .jack:
                return "jack"
            case .queen:
                return "queen"
            case .king:
                return "king"
            default:
                return String(self.rawValue)
        }
    }
}

// You can create an instance by enumeration case
let card = Rank.queen
card.rawValue
card.description()

// Or you can create it by the raw value, this returns an optional
let card2 = Rank(rawValue: 11)
card2?.rawValue
card2?.description()

let card3 = Rank(rawValue: 15)
card3?.rawValue
card3?.description()

// Enums don't always need to have a separate raw value
enum Suit {
    case spades, hearts, diamonds, clubs
    func description() -> String {
        switch self {
            case .spades:
                return "spades"
            case .hearts:
                return "hearts"
            case .diamonds:
                return "diamonds"
            case .clubs:
                return "clubs"
        }
    }
}
let suit = Suit.spades
suit.description()
// Error:
// suit.rawValue



// If an enum has raw values, those are defined on initialization and cannot be changed later, so all instances will have the same raw values
// But another option is to have enum cases hold custom vars for each instance:
enum ServerResponse {
    case result(String, String)
    case failure(String)
    
    func description() -> String {
        switch self {
            case let .result(sunrise, sunset):
                return "Sunrise is at \(sunrise) and sunset is at \(sunset)."
            case let .failure(message):
                return "Failure...  \(message)"
        }
    }
}
let success = ServerResponse.result("6:00 am", "8:09 pm")
let failure = ServerResponse.failure("Out of cheese.")
success.description()
failure.description()


// STRUCTS
// ------------------------------

// Structs are similar to classes, except that:
// 1. You can omit the init function, in that case all properties are required as arguments when instantiating the struct
struct Card {
    var rank: Rank
    var suit: Suit
    func description() -> String {
        return "The \( rank.description() ) of \( suit.description() )"
    }
    
    // 2. By default methods can't change the properties of the struct, unless you add the "mutating" keyword before their name
    mutating func changeSuite() {
        self.suit = Suit.diamonds
    }
}

// 3. They are always copied instead of passed as reference
var cardTest1 = Card(rank: .three, suit: .spades)
cardTest1.description()
var cardTest2 = cardTest1
cardTest2.rank = Rank.four
cardTest2.description()
cardTest1.description()

cardTest1.changeSuite()
cardTest1.description()

// Compare with a class:
class CardClass {
    var rank: Rank
    var suit: Suit
    init(rank: Rank, suit:Suit) {
        self.rank = rank
        self.suit = suit
    }
    func description() -> String {
        return "The \( rank.description() ) of \( suit.description() )"
    }
    func changeSuite() {
        self.suit = Suit.diamonds
    }
}
var cardTest3 = CardClass(rank: .jack, suit: .hearts)
cardTest3.description()
var cardTest4 = cardTest3
cardTest4.suit = .clubs
cardTest4.description()
cardTest3.description()

cardTest3.changeSuite()
cardTest3.description()


// PROTOCOLS
// ------------------------------

// Classes, enums and structs can all adopt protocols
protocol ExampleProtocol {
    var description: String { get }
    mutating func adjust()
}

class classProtocol: ExampleProtocol {
    var description: String = "Class with protocol"
    var anotherProperty: String = "lorem ipsum"
    func adjust() {
        description += ", now adjusted"
    }
}
var protocol1 = classProtocol()
protocol1.description
protocol1.adjust()
protocol1.description
protocol1.anotherProperty

struct structProtocol: ExampleProtocol {
    var description: String = "Struct with protocol"
    mutating func adjust() {
        description += ", now adjusted"
    }
}
var protocol2 = structProtocol()
protocol2.description
protocol2.adjust()
protocol2.description

// not sure how to use protocols with enums


// EXTENSIONS
// ------------------------------

// Use extensions to add more properties and methods to existing types
extension Int {
    var isExtended: Bool {
        return true
    }
    mutating func multiplyBy10() {
        self *= 10
    }
}
var extensionNum = 12
extensionNum.multiplyBy10()
extensionNum
extensionNum.isExtended

// You can also use it to make them conform to a protocol
extension Int: ExampleProtocol {
    mutating func adjust() {
        self += 1
    }
}
extensionNum.adjust()
extensionNum.adjust()
extensionNum.description

// You can use a protocol as a variable type
// if you pass an instance of a class, only the protocol properties and methods will be available
let protocolValue: ExampleProtocol = protocol1
protocolValue
protocolValue.description
// Uncomment to see the error:
// protocolValue.anotherProperty


// ERROR HANDLING
// ------------------------------

// There is a default Error protocol, so you can create your own handlers based on it
enum PrinterError: Error {
    case outOfPaper
    case noToner
    case onFire
}

// If a function can throw errors, you need to add the "throws" keyword
func send(job: Int, toPrinter printerName: String) throws -> String {
    if printerName == "Patito" {
        // When using "throw" you can only throw instances that conform to the Error protocol
        throw PrinterError.noToner
    } else if printerName == "Gutenberg" {
        throw PrinterError.onFire
    }
    return "Job \(job) sent"
}

// Error handling - Generic
do {
    let printerResponse = try send(job: 1040, toPrinter: "Epson")
    printerResponse
} catch {
    error
}

// Error handling - Conditional checks
do {
    let printerResponse = try send(job: 1440, toPrinter: "Gutenberg")
    printerResponse
} catch PrinterError.onFire {
    "I'll just put this over here, with the rest of the fire."
} catch let printerError as PrinterError {
    "Printer error: \(printerError)."
} catch {
    error
}

// Error handling - Return as optionals using "try?"
let printerSuccess = try? send(job: 1884, toPrinter: "Mergenthaler")
let printerFailure = try? send(job: 1885, toPrinter: "Patito")


// DEFER
// ------------------------------

// A "defer" statement always runs at the end of a function (before returning the value)
// It also runs even if the function threw an error

var programIsOpen = false
func codeIsClean(_ code: String) -> Bool {
    programIsOpen = true
    defer {
        programIsOpen = false
    }
    let result = code == "abc"
    return result
}
programIsOpen
codeIsClean("abc")
programIsOpen


// GENERICS
// ------------------------------

// Use angle brackets to create a generic placeholder to handle variables of an unknown type

func makeArray<Item>(repeating item: Item, numberOfTimes: Int) -> [Item] {
    var result = [Item]()
    for _ in 0..<numberOfTimes {
        result.append(item)
    }
    return result
}
makeArray(repeating: "knock", numberOfTimes:3)
makeArray(repeating: 12.2, numberOfTimes:5)

// Can also be used on classes, enums and structs
enum OptionalValue<Wrapped> {
    case none
    case some(Wrapped)
}
// If the variable type can't be inferred, you need to specify it also within angle brackets:
var possibleInteger: OptionalValue<Int> = .none
possibleInteger = .some(100)

// Use the "where" clause to make sure that the passed variables meet certain criteria
func hasCommonElements<T: Sequence, U: Sequence>(_ lhs: T, _ rhs: U) -> Bool
    where T.Iterator.Element: Equatable, U.Iterator.Element: Equatable, T.Iterator.Element == U.Iterator.Element
{
    for lhsItem in lhs {
        for rhsItem in rhs {
            if lhsItem == rhsItem {
                return true
            }
        }
    }
    return false
}
hasCommonElements([1, 2, 3], [3])
hasCommonElements([1, 2, 5], [3])
// Throws error because type of arguments don't match the "where" conditions
// hasCommonElements("trololol", "lol")
