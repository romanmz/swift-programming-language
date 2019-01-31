
// SYNTAX
enum CompassPoint {
    case north
    case south
    case east
    case west
}
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}

// Each enum defines a brand new type
// They should start with a capital letter
// and preferrably have a singular name

// Initializing instances
// After a var is initialized, you can change the value with a simple dot syntax and the type will be inferred to be the previously defined enum
var directionToHead = CompassPoint.west
directionToHead = .east

// Using with switch statements
directionToHead = .south
switch directionToHead {
    case .north:
        print("Lots of planets have a north")
    case .south:
        print("Watch out for penguins")
    case .east:
        print("Where the sun rises")
    case .west:
        print("Where the skies are blue")
}


// ASSOCIATED VALUES

// Each case can have an associated value to provide more detailed information
// Values can be of any type, and cases don't necessarily need to be all of the same type

// You can initialize each case with the expected type, but no default value:
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

// When creating an instance, you need to pass all the required values depending on each case
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")

// On a switch statement, you can extract the associated values as variables or constants
switch productBarcode {
    case .upc(let numberSystem, let manufacturer, let product, let check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
    case .qrCode(let productCode):
        print("QR code: \(productCode).")
}

// If you are defining all associated values as either variable or constant
// You can place the keyword before each case name
switch productBarcode {
    case let .upc(numberSystem, manufacturer, product, check):
        print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
    case let .qrCode(productCode):
        print("QR code: \(productCode).")
}


// RAW VALUES
// Enumerations can come with default values (called raw values),
// which all need to be of the same type
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
// Raw values can be strings, characters, integers or floats
// And each case needs to have a different raw value


// raw values are defined once and always remain the same across all enum instances
// associated values are defined each time the enum is instantiated, and can be different every time

// For strings and integers, raw values can be implicitely assigned
// Integers are increased by 1 after each case (by default starts at 0, unless a case is defined with a specific value)
// Strings are set to match the case name
enum Planet2: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
enum CompassPoint2: String {
    case north, south, east, west
}

let earthsOrder = Planet2.earth.rawValue
let sunsetDirection = CompassPoint2.west.rawValue

// Initializing from a raw value
// If an enum has raw values, you can use an init function to set the case based on its raw value
// This will return an optional type
let possiblePlanet = Planet2(rawValue: 7)
let impossiblePlanet = Planet2(rawValue: 17)


// RECURSIVE ENUMERATIONS
// Enumerations can have associated values that are an instance of the same enumeration
// These are called 'recursive enumerations', to allow an associated value to be recursive
// you need to add an 'indirect' keyword before each case
enum ArithmeticExpression {
    case number(Int)
    indirect case addition(ArithmeticExpression, ArithmeticExpression)
    indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}

// or you can add it before the enum definition, to allow any case to be recursive if necessary
indirect enum ArithmeticExpression2 {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

// you can use functions and switch statements to parse the value of a recursive enumeration
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
        case let .number(value):
            return value
        case let .addition(left, right):
            return evaluate(left) + evaluate(right)
        case let .multiplication(left, right):
        	return evaluate(left) * evaluate(right)
    }
}
evaluate(product)
