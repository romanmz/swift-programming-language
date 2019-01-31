


// PROPERTIES
// ==================================================

// 'Stored properties' are specifically defined
// 'Computed properties' are calculated on the fly as needed

// Properties are generally (and by default) assigned to each instance
// But they can also be assigned to the type itself, those are called 'type properties'

// You can also define 'property observers' to trigger actions every time a property changes its value


// STORED PROPERTIES
// ------------------------------
// Stored properties can have default values, which can be defined as part of the type definition, or in the initializer function (applies to both variables and constants)

// If an instance of a struct is passed to a constant, its stored properties cannot be changed even if they were defined as variables
// This is not the case for class instances, as the constant will only store a reference to the instance, not the instance itself

// LAZY STORED PROPERTIES
// A lazy stored property is a property whose initial value is not calculated until the first time it is used.
// This is useful when the property is time consuming and computationally expensive to initialize
// To mark a property as lazy add the 'lazy' keyword before its definition, and it always needs to be a variable

class DataImporter {
    /*
     DataImporter is a class to import data from an external file.
     The class is assumed to take a non-trivial amount of time to initialize.
     */
    var filename = "data.txt"
}
class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// the DataImporter instance for the importer property has not yet been created

// NOTE: If a lazy property is accessed by multiple threads simultaneously, there's no guarantee that it will be initialized only once



// COMPUTED PROPERTIES
// ------------------------------
// Computed properties do not actually store a value, instead they use getter and setter functions to calculate values on the fly based on other properties
// You always need to define them as variables, as their values are expected to change over time

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(
    origin: Point(x: 0.0, y: 0.0),
    size: Size(width: 10.0, height: 10.0)
)
let initialSquareCenter = square.center
square.center = Point(x: 20.0, y: 30.0)

initialSquareCenter.x
initialSquareCenter.y
square.origin.x
square.origin.y

// The previous example names the value passed to the setter function as 'newCenter'
// You can leave it empty and use the default 'newValue' variable name
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

// READ-ONLY COMPUTED PROPERTIES
// Define a computed property with a getter but no setter to make it read-only
// You can use a simplified syntax by ommiting the 'get' keyword and its braces
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
fourByFiveByTwo.volume


// PROPERTY OBSERVERS
// ------------------------------
// Property observers trigger functions every time a property's value is set
// Even if the new value is the same as the old one

// You can add observers to any stored properties you define, except lazy properties
// You can also add them to any inherited property

// You don't need to add observers to computed properties as you can just use the setter function

// Property observers functions are: willSet(newValue) and didSet(oldValue)

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360
stepCounter.totalSteps = 896


// GLOBAL AND LOCAL VARIABLES
// ------------------------------

// Computed properties and property observers are available to both global and local variables
let myAge = 33
var myBirthyear: Int {
    return 2017 - myAge
}
myBirthyear

// Global constants and variables are always computed lazily


// TYPE PROPERTIES
// ------------------------------

// These are the equivalent of PHP's static properties
// Stored type properties must always have a default value as there is no initializer for them
// Stored type properties are always lazy loaded, and guaranteed to be initialized only once, even with multithreading

// Define type properties by using the 'static' keyword
// On class types you can use the 'class' keyword on computed properties to allow them to be overriden by subclasses
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

SomeStructure.storedTypeProperty
SomeStructure.storedTypeProperty = "Another value."
SomeStructure.storedTypeProperty
SomeEnumeration.computedTypeProperty
SomeClass.computedTypeProperty

// Example:
struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()

AudioChannel.maxInputLevelForAllChannels
leftChannel.currentLevel = 7
AudioChannel.maxInputLevelForAllChannels

rightChannel.currentLevel = 11
AudioChannel.maxInputLevelForAllChannels


// 'RETHROWING' FUNCTIONS AND METHODS
// ------------------------------

// A function or method that takes throwable functions can be declared with the 'rethrows' keyword
// to indicate that it can throw errors, but only if it comes from one of those parameters
// A rethrowing function can only throw an error inside a 'catch' statement after 'try'ing its function parameters

// Example:
enum MyError: Error {
    case throwing, rethrowing
}
func throwable() throws {
    throw MyError.throwing
}
func rethrowable(testFunction: ()throws->() ) rethrows {
    // ERROR: 'throw' statements can happen anywhere on throwable functions
    // but on rethrowable functions they can only be within a 'catch' statement after trying the throwable parameter functions
    // throw MyError.unexpected
    do {
        try testFunction()
    } catch {
        throw MyError.rethrowing
    }
}

// Testing:
do {
    try rethrowable( testFunction: throwable )
} catch {
    error
}
