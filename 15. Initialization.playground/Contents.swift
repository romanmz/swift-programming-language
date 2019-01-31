


// INITIALIZATION
// ==================================================

// You can add an initialization method to classes, structures and enumerations

// Classes and structs must define values for ALL their properties by the time the initialization is over
// This can be done either with 'default values' or with 'initial values' (defined during initialization)

// Property observers are never triggered until after initialization is over

// To add an initializer, create a method called 'init', no 'func' keyword is needed
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
f.temperature

// Initializing parameters
// Work the same as function parameters
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)
let bodyTemperature = Celsius(37.0)
boilingPointOfWater.temperatureInCelsius
freezingPointOfWater.temperatureInCelsius
bodyTemperature.temperatureInCelsius

// Optional properties
// Any property can be defined as an optional, and if they don't get any values during initialization, they are automatically defined as nil
class SurveyQuestion {
    var text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.response

// Constant properties
// Constant properties must always get a set value before initialization ends, and when used on a class they must be defined by the init method of the same class, they cannot be defined by a subclass

// Default initializers
// When a struct or class has default values for all their properties, and there is no init method defined, then an automatic initializer method is created that takes no arguments
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()

// Memberwise initializers for structs
// All struct types get an automatic init function where you can define the initial values of all the properties of the struct, this happens only if there is no init method defined
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)


// INITIALIZER DELEGATION FOR VALUE TYPES (STRUCTS AND ENUMS)
// ------------------------------
// Init methods can call other init methods by using 'self.init' (only works within init methods)

struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    
    // same as default initializer
    init() {}
    
    // same as memberwise initializer
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    // custom initializer, using delegation
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let basicRect = Rect()
let originRect = Rect(
    origin: Point(x: 2.0, y: 2.0),
    size: Size(width: 5.0, height: 5.0)
)
let centerRect = Rect(
    center: Point(x: 4.0, y: 4.0),
    size: Size(width: 3.0, height: 3.0)
)

// Both default and memberwise initializers are not created if you have any custom inits, but if you still want to have them you can define your type with no custom init methods, and then add them later using an extension


// CLASS INHERITANCE AND INITIALIZATION
// ------------------------------
// All properties need to get an initial value during initialization (including properties from the superclass)


// DESIGNATED INITIALIZERS:
// These are the init methods that set an initial value for any properties introduced by the same class, and then calling an init method from the superclass to set the rest
// All classes must have at least one, an exception is if the requirements for 'Automatic Initializer Inheritance' are met (see section below)

// syntax is the same as initializers for value types (structs and enums)
// they must always call a designated initializer from its superclass (if applicable)


// CONVENIENCE INITIALIZERS:
// These are secondary, supporting initializers that may call a designated initializer
// These are not required but are helpful to provide shortcuts for common patterns

// you need to add a 'convenience' modifier before the init declaration
// they must always call another initializer which always needs to be from the same class, and it always needs to ultimately call a designated initializer


// TWO PHASE INITIALIZATION
/*
 
 Class initialization happens in 2 phases:
 1. All stored properties get an initial value by the same class that introduced them
 2. After the 1st phase is done, then each class gets the chance to customize any values for the properties they inherited
 
 Swift performs 4 checks to make sure there are no errors during initialization
 1. Designated initializers must always ensure that all properties introduced by the class get an initial value
 2. Designated initializers must delegate up to a superclass initializer (and before overriding any inherited properties)
 3. A convenience initializer must always delegate to another initializer of the same class (and before overriding any properties, including its own)
 4. Initializers cannot use instance methods or properties, or refer to 'self' as a value, until after phase 1 is done
 
 The full initialization process looks like this based on the 2 phases and 4 checks:
 PHASE 1
    - A designated or convenience init method is called
    - The designated initializer confirms that all stored properties of its class have a value
    - The designated initializer hands off to its superclass initializer (which in turn will also make sure all its properties are set)
    - This continues up to the top of the inheritance chain
    - Once the superclass finishes adding values to all available properties, the instance is fully initialized and phase 1 is complete
 PHASE 2
    - Working back down from the top of the chain, each designated initializer can customize their properties (own or inherited). Methods, properties and 'self' are now fully available
    - Finally, convenience initializers can also customize any property of the instance
 
 */


// INITIALIZER INHERITANCE
// By default, subclasses do not inherit init classes from their superclass
// When overriding an initializer from a superclass, you always need to add the 'override' keyword if the initializer you are overriding is a designated initializer
// You don't add the keyword when overriding convenience initializers as those are never meant to be called from within the subclass anyway

class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
let vehicle = Vehicle()
vehicle.description


class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}
let bicycle = Bicycle()
bicycle.description

// Subclasses can modify inherited variables, but not inherited constants


// AUTOMATIC INITIALIZER INHERITANCE
/*
 
 By default subclasses do not inherit the initialization methods of their superclasses
 Except when 2 conditions are met:
 
 CASE 1
 - If all new stored properties have default values
 - AND the subclass doesn't define any designated initializers at all
 - THEN the subclass inherits ALL initializers from the superclass, both designated and convenience
 
 CASE 2:
 - If all new stored properties have default values
 - AND the subclass overrides all of its superclass' designated initializers (even if they are overriden as convenience initializers)
 - THEN the subclass inherits ALL the convenience initializers from its superclass
 
 Both cases still apply even if the subclass has additional convenience initializers
 
*/


// EXAMPLE WITH DESIGNATED, CONVENIENCE, AND INHERITED INITIALIZERS
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
class ShoppingListItem2: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()
namedMeat.name
mysteryMeat.name

let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
let oneBacon = RecipeIngredient(name: "Bacon")
let oneMysteryItem = RecipeIngredient()
"\( sixEggs.quantity ) \( sixEggs.name )"
"\( oneBacon.quantity ) \( oneBacon.name )"
"\( oneMysteryItem.quantity ) \( oneMysteryItem.name )"

let shopMysteryMeat = ShoppingListItem2()
let shopBacon = ShoppingListItem2(name: "Bacon")
let shopEggs = ShoppingListItem2(name: "Eggs", quantity: 6)
shopMysteryMeat.description
shopBacon.description
shopEggs.description
shopEggs.purchased = true
shopEggs.description


// FAILABLE INITIALIZERS
// ------------------------------

// Sometimes the initialization of a class, struct or enum can fail
// Reasons can be invalid initialization parameters, an abscence of a required resource, etc…

// To mark an initializer as failable, add a question mark after the init keyword: 'init?'
// Failable intializers return an optional value of the type it initializes, with the value set to nil if the initialization failed

struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

// Returns an optional
let someCreature = Animal(species: "Giraffe")
if let isAnimal = someCreature {
    isAnimal.species
}
let anotherCreature = Animal(species: "")
if let isAnimal = anotherCreature {
    isAnimal.species
} else {
    "not an animal"
}
if anotherCreature != nil {
    anotherCreature?.species
} else {
    "not an animal"
}


// IN ENUMERATIONS:
enum TemperatureUnit {
    case kelvin, celsius, fahrenheit
    init?(symbol: Character) {
        switch symbol {
            case "K":
                self = .kelvin
            case "C":
                self = .celsius
            case "F":
                self = .fahrenheit
            default:
                return nil
        }
    }
}
let kelvinUnit = TemperatureUnit.kelvin
let fahrenheitUnit = TemperatureUnit(symbol: "F")
let unknownUnit = TemperatureUnit(symbol: "X")

// Optional enumerations don't need to be unwrapped
if( fahrenheitUnit != nil ) {
    fahrenheitUnit
}


// IN ENUMERATIONS WITH RAW VALUES:
// Enumerations with raw values automatically get the init?(rawValue:) failable initializer
enum TemperatureUnit2: Character {
    case kelvin = "K", celsius = "C", fahrenheit = "F"
}
let fahrenheitUnit2 = TemperatureUnit2(rawValue: "F")
let unknownUnit2 = TemperatureUnit2(rawValue: "X")


// PROPAGATION OF INITIALIZATION FAILURE
// A failable initializer can delegate to other failables within the same type, or from a superclass
// If the initialization fails at any point, the whole process stops and no more code is executed
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}

let twoSocks = CartItem(name: "sock", quantity: 2)
let zeroShirts = CartItem(name: "shirt", quantity: 0)
let oneUnnamed = CartItem(name: "", quantity: 1)

// init? and init! can delegate to any other init, init? or init!
// init can delegate only to init and init!, but it can still delegate to init? if it add forced unwrapping (e.g: super.init()! )


// OVERRIDING A FAILABLE INITIALIZER
// You can override failable initializers from a superclass just like any other initializer
// You can keep them as failable but you can also turn them into non-failable
// However you cannot do the opposite (turn a non-failable into a failable)

class Document {
    var name: String?
    
    // this initializer creates a document with a nil name value
    init() {}
    
    // this initializer creates an optional document with a nonempty name value
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

// You can use forced unwrapping to call a failable initializer from a superclass in a non-failable initializer
// But you'll need to be 100% sure that the call to the superclass will never fail
class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}
let untitled = UntitledDocument()
untitled.name


// USING init!
// You can also create failable initializers that return implicitely unwrapped types instead of optional types
// Do this by using an exclamation mark instead of a question mark
// You can delegate and override between init! and init? without issues
// You can also delegate from init to init! but you will get an error if init! fails


// REQUIRED INITIALIZERS
// ------------------------------

// Write the 'required' modifier before an init method to indicate that all subclasses must implement it
class SomeClass {
    required init() {
    }
}

// This requirement only goes down one level, so if subclasses of a subclass also need to implement the method then add the 'required' modifier again
class SomeSubclass: SomeClass {
    required init() {
    }
}

// There's no need to add the 'override' keyword when overriding required initializers
// You can use inherited initializers to meet these requirements


// SETTING DEFAULT PROPERTY VALUES WITH A CLOSURE OR FUNCTION
// ------------------------------
// You can use global functions or closures to calculate the default value of a property on initialization
// Note that you need to add parentheses after a closure to make sure it runs and returns the value
// otherwise you would be assigning the closure itself as the value of the property

// Also note that you cannot use other properties or methods as the instance hasn't finished initialized yet

struct Chessboard {
    
    // Trigger a closure to define a default value during initialization
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...8 {
            for j in 1...8 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
    }()
    
    // Utility function
    func squareIsBlackAt(row: Int, column: Int) -> Bool {
        return boardColors[(row * 8) + column]
    }
}
let board = Chessboard()
board.squareIsBlackAt(row: 0, column: 1)
board.squareIsBlackAt(row: 7, column: 7)
