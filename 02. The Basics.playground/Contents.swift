
// var and let
// var multiple = 0, declarations = 1, inoneline = 3

// var type_annotation: String
// var single, annotation, formultiplevars: String

// let implicitValue = 10
// let explicitValue: String

// vars and constant names can't begin with a number

print( "test", "lorem", "ipsum", separator:" | ", terminator:" ~" )
var count = 10
var string = "Escaping strings: \( count )"

// single line comment

/* multi
 line
 comment */

/* nested
 /* multiline */
 comments */

// semicolons are not required unless you are writing multiple statements on a single line


// INTEGERS
/*
 Types:
 Int8
 Int16
 Int32
 Int64
 
 UInt8
 UInt16
 UInt32
 UInt64
 
 Int
 UInt
 */

// You can get the min and max possible values of each type
let minValue = UInt8.min
let maxValue = UInt8.max

// Int and UInt are the same size as the current platform
// 32-bit platform: Int32
// 64-bit platform: Int64
// Same with UInt


// FLOATS
// Float: 32-bit floating number, at least 6 decimals
// Double: 64-bit floating number, at least 15 decimals

// Swift is type-safe

// Int literals:
let decimalInteger = 17
let binaryInteger = 0b10001       // binary
let octalInteger = 0o21           // octal
let hexadecimalInteger = 0x11     // hexadecimal

// Exponents
let decimalExp = 3e3              // "e" for decimals, multiplies by 10exp
let hexadeciamlExp = 0x3p3        // "p" for hexs, multiplies by 2exp

// Float literals (always set as "Double")
let decimalDouble = 12.1875
let exponentDouble = 0.121875e2
let hexadecimalDouble = 0xC.3p2   // Hex floats always need to have an exponent

// You can add underscores and left-hand 0's to make numbers more readable
let paddedInt = 000123
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

// All numbers need to be of the same type if you want to perform operations on them
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)

// However you don't need to convert them if you're only comparing them
let integer = Int(8)
let integerU8 = UInt8( 8 )
integer == integerU8

// Converting floats into integers truncats the decimal values
let float1 = 4.1
let float2 = 4.9
let float3 = -2.2
Int( float1 )
Int( float2 )
Int( float3 )


// TYPE ALIASES
// Use typealias to use a type with a different name, useful for adding context
typealias AudioSample = UInt16
AudioSample.min
AudioSample.max


// BOOLEANS
let inferredTrue = true
let inferredFalse = false

// TUPLES
// Tuples group multiple values of different types in a single compound value
let http404Error = (404, "Not Found")

// Syntax to break it down into single vars
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
print("The status message is \(statusMessage)")

// Use underscore to ignore some fields
let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")

// You can access the values using index numbers
print("The status code is \( http404Error.0 )")
print("The status message is \( http404Error.1 )")

// Or you can also name each individual value when defining the tuple
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode)")
print("The status message is \(http200Status.description)")

// Explicitely define the types
let http500Status: (statusCode: Int, description: String)
http500Status = (500, "Unknown error")



// OPTIONALS

// You can define vars to have an "optional" value by adding "?" after any type definition
let optionalConstant: Int?
var optionalVariable: Int?

// Optional constants still need to have a specific value defined, this throws an error:
// optionalConstant

// Optional variables are automatically set as nil if no value was passed
optionalVariable

// Functions can return optional values, for example the Int initializer function
let possibleNumber = "Hello world"
let convertedNumber = Int(possibleNumber)

// Optionals and non optionals are not interoperable, even if they are of the same type
let possibleNumber2 = "123"
let convertedNumber2 = Int(possibleNumber2)
// Throws an error:
// let intSum = 123 + convertedNumber2

// To check whether an optional has a value or not, you can check against nil
if convertedNumber2 == nil {
    print( "not a number" )
} else {
    // You can force "unwrap" the number by adding "!" after the variable name, but you must be 100% sure that is not nil, otherwise errors will be generated
    print( "it's the number: \( convertedNumber2! )" )
}

// You can also use "optional binding", which is trying to pass the value of the optional to another variable or constant inside an "if" or "while" statement, if the optional has a value the statement will return tru
if let actualNumber = Int(possibleNumber2) {
    print("\"\(possibleNumber2)\" has an integer value of \(actualNumber)")
} else {
    print("\"\(possibleNumber2)\" could not be converted to an integer")
}

// You can define an optional using "!" instead of "?"
// This will allow you to access the value without having to manually unwrap it
// This is called an "implicitly unwrapped optional", and they are used when it is assumed that the variable will eventually have a defined value
// It is most often used for initializing class properties
let assumedString: String! = "An implicitly unwrapped optional string."
let implicitString: String = assumedString // no need to unwrap the optional

// note that if the optional was defined as nil at some point, it will still throw errors if you try to access it
// implicitly unwrapped optionals should only ever be used when you are sure the variable will eventually get a defined value, and never go back to nil



// ERROR HANDLING
// Same as on "A swift tour"


// ASSERTIONS and PRECONDITIONS
// ------------------------------

// Assertions and preconditions check for a necessary condition, if it is not met the program stops and throws an error

// Unlike the error conditions discussed in Error Handling, assertions and preconditions aren’t used for recoverable or expected errors.
// Using them to enforce valid data and state causes your app to terminate more predictably if an invalid state occurs, and helps makes the problem easier to debug

// Assertions are only checked in debug builds, preconditions are checked both in debug and production builds
// this means you can use as many assertions in your code as you want without impacting performance in production

// Use 'asert' to check for a condition
let age = 3
assert(age >= 0, "A person's age cannot be less than zero")

// or 'assertionFailure(_:file:line:)' when the check has already been made and you want to indicate that an error happened:
if age > 10 {
	"Older than 10"
} else if age > 0 {
	"Younger than 10"
} else {
	assertionFailure("Invalid age value")
}

// To use preconditions instead use the 'precondition(_:_:file:line:)' and 'preconditionFailure(_:file:line:)' functions
// Preconditions can still be ignored when compiling in 'unchecked' mode

// 'fatalError(_:file:line:)' functions always run regardless of the compiling mode
