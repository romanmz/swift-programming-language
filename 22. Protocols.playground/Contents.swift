

// PROTOCOLS
// ==================================================

// A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality
// The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements


// SYNTAX
// ------------------------------

// Use the 'protocol' keyword to define new protocols
protocol NewProtocol {
}
protocol AnotherProtocol {
}
protocol AnotherProtocol2 {
}

// To make a class follow a protocol, list them after a colon character
class NewClass: NewProtocol, AnotherProtocol {
}

// When creating subclasses, add the superclass first after the colon, and then list the protocols the subclass will follow
class NewSubClass: NewClass, AnotherProtocol2 {
}


// PROPERTY REQUIREMENTS
// ------------------------------
/*
 
 A protocol can require conforming types to include particular properties
 
 The protocol defines:
 - if it's an instance or type property
    - for type properties you always use 'static' (even if classes can also use 'class')
 - all properties as variables (even if they can be constants in their actual implementation)
 - name
 - type
 - if it needs to be at least readable, or read-write
    - this is a minimum requirement, if it's defined as only readable in the protocol, the conforming class can still make it read-write if it wants
    - if a property is read-write, it cannot be defined as a constant in the implementation
 
 The protocol can't define:
 - if it should be a stored or computed property
 
 */

// Syntax:
protocol ProtocolWithProperties {
    static var someTypeProperty: Int { get set }
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

// Sample protocol:
protocol FullyNamed {
    var fullName: String { get }
}

// Sample implementation:
struct Person: FullyNamed {
    var fullName: String
}
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
    
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
}
var john = Person(fullName: "John")
john.fullName
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName


// METHOD REQUIREMENTS
// ------------------------------
/*
 
 The protocol defines:
 - if it's an instance or type method
    - for type methods you always use 'static' (even if classes can also use 'class')
 - if it needs to be a 'mutating' method (required by structs and enums to alter their own values)
    - if a method is defined as mutating in the protocol, the implementation can't be non-mutating, and vice-versa
    - classes don't need to worry about this since they are always mutating by default
 - name
 - arguments list (name and type)
    - variadic parameters are allowed
    - default values are NOT allowed
 - return type
 
 The protocol can't define:
 - default values for parameters
 - method body
 
 */

// Syntax:
protocol ProtocolWithMethods {
    static func typeMethod()
    mutating func mutatingMethod()
    func method1(firstName: String, lastName: String) -> String
    func method2(_ numbers: Int...) -> Int
    // func invalidMethod(color: String = "red")
}

// Sample protocol:
protocol RandomNumberGenerator {
    mutating func random() -> Double
    func fixed() -> Double
}

// Sample implementation:
struct LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    mutating func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
    func fixed() -> Double {
        return m
    }
}
var generator = LinearCongruentialGenerator()
generator.random()
generator.fixed()
generator.random()
generator.fixed()


// INITIALIZER REQUIREMENTS
// ------------------------------
/*
 
 The protocol defines:
 - the minimum required type of initializer
 - non-failable (init)
 - can be init or init! in the implementation
 - failable (init?)
 - can be init or init? in the implementation
 - implicitely unwrapped failable (init!)
 - ???
 - arguments list (labels and type)
 - variadic parameters are allowed
 - default values are NOT allowed
 - internal parameter names are not necessary, and ignored if provided
 
 The protocol can't define:
 - default values for parameters
 - initializer body
 
 When implementing them on a class, the initializers:
 - can be 'designated' or 'convenience'
 - must be marked as 'required' on class types that are not 'final' (and therefore can be subclassed), this is to ensure that any subclasses based on the class also conform with the protocol
 
 */

// Syntax:
protocol ProtocolWithInitializers {
    init(fullName: String)
    init(firstName: String, grades: Int...)
    init?(withinRange: Int)
    init!(outsideRange: Int)
}

// Sample protocol:
protocol RequestName {
    init(name: String)
    init?(withinRange: Int)
    init!(outsideRange: Int)
}

// Sample implementations:
enum MovieGenre: String, RequestName {
    case horror, comedy, thriller, drama, musical
    init(name: String) {
        if let genre = MovieGenre(rawValue: name) {
            self = genre
        } else {
            self = .horror
        }
    }
    init(withinRange number: Int) {
        self = .horror
    }
    init(outsideRange number: Int) {
        self = .horror
    }
}
struct Shape: RequestName {
    let name: String
    init(name: String) {
        self.name = name
        print("The shape's name is \( name )")
    }
    
    // init? as init
    init(withinRange number: Int) {
        self.name = "UNTITLED"
        print("Number within range: \( number )")
    }
    
    // init! as init
    init(outsideRange number: Int) {
        self.name = "UNTITLED"
        print("Number outside range: \( number )")
    }
}
class Student: RequestName {
    let name: String
    required init(name: String) {
        self.name = name
        print("The student's name is \(name)")
    }
    
    // init? as init?
    required init?(withinRange number: Int) {
        self.name = "UNTITLED"
        if number >= 0 && number <= 100 {
            print("Student within range: \( number )")
        } else {
            return nil
        }
    }
    
    // init! as init?
    required init?(outsideRange number: Int) {
        self.name = "UNTITLED"
        if number >= 0 && number <= 100 {
            return nil
        } else {
            print("Student outside range: \( number )")
        }
    }
}
final class Teacher: RequestName {
    let name: String
    init(name: String) {
        self.name = name
        print("The teacher's name is \(name)")
    }
    
    // init? as init!
    init!(withinRange number: Int) {
        self.name = "UNTITLED"
        if number >= 0 && number <= 100 {
            print("Student within range: \( number )")
        } else {
            return nil
        }
    }
    
    // init! as init!
    required init!(outsideRange number: Int) {
        self.name = "UNTITLED"
        if number >= 0 && number <= 100 {
            return nil
        } else {
            print("Teacher outside range: \( number )")
        }
    }
}

// Testing init
let testGenre = MovieGenre(name: "- invalid name -")
let testShape = Shape(name: "Triangle")
let testStudent = Student(name: "Alex")
let testTeacher = Teacher(name: "Jessica")
testShape.name      // implemented as init
testStudent.name    // implemented as init, init? is not allowed
testTeacher.name    // implemented as init, init! is allowed in theory, but can cause many issues

// Testing init?
let testShape1 = Shape(withinRange: 5)
let testStudent1 = Student(withinRange: 7)
let testStudent2 = Student(withinRange: -10)
let testTeacher1 = Teacher(withinRange: 7)
let testTeacher2 = Teacher(withinRange: -10)

testShape1.name         // implemented as init
testStudent1?.name      // implemented as init?
testStudent2?.name      // implemented as init?
testTeacher1?.name      // implemented as init!, returns optional anyway
testTeacher2?.name      // implemented as init!, returns optional anyway

// Testing init!
let testShape2 = Shape(outsideRange: 5)
let testStudent3 = Student(outsideRange: 7)
let testStudent4 = Student(outsideRange: -10)
let testTeacher3 = Teacher(outsideRange: 7)
let testTeacher4 = Teacher(outsideRange: -10)

testShape2.name         // implemented as init
testStudent3?.name      // implemented as init?
testStudent4?.name      // implemented as init?
testTeacher3?.name      // implemented as init!, returns optional anyway
testTeacher4?.name      // implemented as init!, returns optional anyway


// SUBSCRIPT REQUIREMENTS
// ------------------------------
// in theory the syntax for adding subscript requirements is this:
// but it's currently not working (???)
class ProtocolSubscript {
    // subscript(i: Int) -> Int { get set }
}


// PROTOCOLS AS TYPES
// ------------------------------

/*
 Protocols are types just like any other object
 So you can also use them in places like:
 - As a parameter type or return type
 - As a type of variable, constant or property
 - As the type of items in an array, dictionary, or other containers
 */

class Dice {
    let sides: Int
    var generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

// In this example, the property 'generator' accepts an instance of any type that conforms to the 'RandomNumberGenerator' protocol
var diceRoller = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(diceRoller.roll())")
}


// DELEGATION
// ------------------------------
// Delegation is a design pattern that enables a class or structure to hand off (or delegate) some of its responsibilities to an instance of another type.
// For this to happen, the delegate needs to conform to a protocol that defines the tasks it needs to perform

protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    let finalSquare = 25
    var square = 0
    var board: [Int]
    var delegate: DiceGameDelegate?
    
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08;
        board[06] = +11;
        board[09] = +09;
        board[10] = +02
        board[14] = -10;
        board[19] = -11;
        board[22] = -02;
        board[24] = -08
    }
    
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
                case finalSquare:
                    break gameLoop
                case let newSquare where newSquare > finalSquare:
                    continue gameLoop
                default:
                    square += diceRoll
                    square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

// In this case, the SnakesAndLadders class has an optional 'delegate' property which is triggered at the beginning and end of the game
// This delegate is used to trigger actions at every step of the game, and can be assigned to any type that conforms to the 'DiceGameDelegate' protocol

// In the following example we create a class that conforms to that protocol, and use it as the delegate of the game:

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()


// USING EXTENSIONS TO CONFORM TO A PROTOCOL
// ------------------------------
// You can use extensions to make any existing types conform to a given protocol

// SYNTAX:
/*
 extension ExistingType: ProtocolName {
    // properties and methods to meet the protocol requirements
 }
 */

// EXAMPLE 1:
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}
game.textualDescription
game.dice.textualDescription

// EXAMPLE 2:
// An existing type does not automatically conform to a protocol even if it already meets all the requirements,
// it still needs to explicitely declare their adoption
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
let simonTheHamster = Hamster(name: "Simon")
simonTheHamster.textualDescription


// COLLECTIONS OF PROTOCOLS TYPES
// ------------------------------
// As seen on 'Protocols as Types', protocols can be used as any other types, including creating collections with them.
// You can create a collection that includes different types that implement the same protocol, and have that collection be of the same type as the protocol
// This works in a similar as when you create a collection with subclasses that all share the same superclass
// the only difference is that it doesn't happen automatically with protocols, you still need to explicitely set the type of collection:

let things: [TextRepresentable] = [game, diceRoller, simonTheHamster]
for thing in things {
    // you can use type casting to use properties and methods specific to each type
    switch thing {
        case is Dice:
            "is dice"
        case is DiceGame, is SnakesAndLadders:
            "is dice game"
        case is Hamster:
            "hamster"
        default:
            "--"
            break
    }
    // or freely use common properties and methods as specificed by the protocol
    print(thing.textualDescription)
}


// PROTOCOL INHERITANCE
// ------------------------------
// A protocol can inherit from one or a few other protocols
// and any types that conform to that protocol will need to meet the requirements for that, and all inherited protocols

protocol LongDescription: TextRepresentable {
    var longDescription: String { get }
}
class Clothing: LongDescription {
    var name: String
    init(name: String) {
        self.name = name
    }
    var textualDescription: String {
        return "name: \(name)"
    }
    var longDescription: String {
        return "this piece of clothing is a \(name)"
    }
}
let shirt = Clothing(name: "shirt")
shirt.textualDescription
shirt.longDescription


// CLASS-ONLY PROTOCOLS
// ------------------------------
// You can limit protocol adoption to class types (and not structures or enumerations)
// by adding the 'class' keyword after the colon, before any inherited protocols

protocol SomeClassOnlyProtocol: class, TextRepresentable {
    // class-only protocol definition goes here
}

// Use a class-only protocol when the behavior defined by that protocol’s requirements assumes or requires
// that a conforming type has 'reference' semantics rather than 'value' semantics


// PROTOCOL COMPOSITION
// ------------------------------
// When using a protocols as types, you can specify that a given value needs to be an instance of a type that conforms to 2 or more protocols
// To indicate this, list the required protocols separated by an ampersand '&'

protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Robot: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}

// In this example, the wishHappyBirthday function accepts a value of any type as long as it it conforms to both the 'Named' and 'Aged' protocols
// Structures of type 'Robot' conform to both protocols, so they can be used with that function
let myRobot = Robot(name: "T-12", age: 27)
wishHappyBirthday(to: myRobot)

// ** You can also add a superclass requirement to a protocol composition (only one)
// or a typealias that refers to a single protocol, a single class, or another protocol composition


// CHECKING FOR PROTOCOL CONFORMANCE
// ------------------------------
// To check if a value of unknown type conforms to a given protocol, you can use type casting with the 'is', 'as', 'as?' and 'as!' keywords
// in exactly the same way as described in the 'Type Casting' section


// OPTIONAL PROTOCOL REQUIREMENTS
// ------------------------------
// You can define protocol requirements that are optional, so not actually required
// they exist only so you can write code that interoperates with Objective-C

// To mark protocol requirements as optional:
// - the 'Foundation' module must be imported
// - prefix the protocol with the '@objc' attribute
// - prefix the optional requirements with '@objc optional'

// '@objc' protocols can only be adopted by classes, not enums or structs
// optional properties and methods will always return optional types, even if the implementations don't define them as optional
// you can then use optional chaining to access them in a clean way


// SYNTAX:
import Foundation
@objc protocol CounterIncrement {
    @objc optional var fixed: Int { get }
    @objc optional func calculate(_ number: Int) -> Int
}

// SAMPLE CLASSES:
class EmptyIncrement: CounterIncrement {
}
class TripleIncrement: CounterIncrement {
    let fixed = 3
}
class IncrementTowardsZero: CounterIncrement {
    func calculate(_ number: Int) -> Int {
        if number < 0 {
            return +1
        } else if number > 0 {
            return -1
        } else {
            return 0
        }
    }
}
class DuplicateIncrement: CounterIncrement {
    let fixed = 2
    func calculate(_ number: Int) -> Int {
        return number
    }
}

// EXAMPLE OF IMPLEMENTATION:
class Counter {
    var count = 0
    var dataSource: CounterIncrement?
    func increment() {
        // Optional requirements always return optional types, even if they were not marked as optional on the classes:
        if let amount = dataSource?.calculate?(count) {
            count += amount
        } else if let amount = dataSource?.fixed {
            count += amount
        }
    }
}
var counter = Counter()

// triple increments
counter.dataSource = TripleIncrement()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

// towards zero
counter.dataSource = IncrementTowardsZero()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}


// PROTOCOL EXTENSIONS
// ------------------------------

// Protocols can be extended to provide method and property implementations to conforming types
// This allows you to define behavior on protocols themselves, rather than in each type’s individual conformance

// In this example we extend the 'CounterIncrement' with a generic 'get' method,
// which will be immediately available in all types that implement this protocol
extension CounterIncrement {
    func get(_ number: Int) -> Int {
        var number = number
        if let increment = self.calculate?(number) {
            number += increment
        } else if let increment = fixed {
            number += increment
        }
        return number
    }
}
let emptyInc = EmptyIncrement()
let tripleInc = TripleIncrement()
let towardsZero = IncrementTowardsZero()
let duplicateInc = DuplicateIncrement()
emptyInc.get( 10 )
tripleInc.get( 10 )
towardsZero.get( 10 )
duplicateInc.get( 10 )


// PROVIDING DEFAULT IMPLEMENTATIONS
// -----
// The implementation of properties and methods in a procol extension will become default implementations available on all adopting types
// But each type has the option to override that default implementation with their own:

extension DuplicateIncrement {
    // We are using a class extension here to override the default implementation,
    // but it would work the same if the override were on the original class definition, even if the protocol extension comes later
    func get(_ number: Int) -> Int {
        return number + 500
    }
}

// Conforming types don't have to provide an implementation of either optional requirements nor default implementation
// The difference is that default implementations will always be there, while optional requirements could be absent and will always return optional types


// ADDING CONSTRAINTS TO PROTOCOL EXTENSIONS
// -----
// You can extend a protocol but have the changes apply only to some of the types that conform to the protocol
// To set the criteria you need to add a conditional statement using the 'where' operator after the name of the protocol

// In this example we extend the 'Collection' protocol, but the changes will only be made available
// to collections that contain types that conform to the 'TextRepresentable' protocol

extension Collection where Iterator.Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let murrayTheHamster = Hamster(name: "Murray")
let morganTheHamster = Hamster(name: "Morgan")
let mauriceTheHamster = Hamster(name: "Maurice")
let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]
print(hamsters.textualDescription)

// If there are multiple protocol extensions that provide implementations of the same properties and methods but using different criterias
// and there are types that meet two or more of those criterias, the protocol extensio with the most specialized constraints will be used for those types

// The 'Iterator.Element' property used in this example is a 'Generic', which are explained in the next section
