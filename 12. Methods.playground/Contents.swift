


// METHODS
// ==================================================

// Classes, structures and enumerations can have both instance and type methods
// methods have exactly the same syntax as functions


// SYNTAX
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
    func increment(by amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }
}
let counter = Counter()
counter.count
counter.increment()
counter.count
counter.increment(by: 5)
counter.count
counter.reset()
counter.count


// 'self' keyword
// Normally not required, unless there's a clash between an argument name and an instance property name, in which case you need to use 'self' to refer to the correct property
struct Point {
    var x = 0.0
    var y = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOf(x: 1.0) {
    print("This point is to the right of the line where x == 1.0")
}


// 'mutating' keyword
// Modifying properties of structs and enums from within their methods
// Structs and enums are value types, and value types are not allowed to change their properties from within their own methods
// If you do need to do this you'll have to add a 'mutating' keyword before the method definition

struct PointAlt {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}
var anotherPoint = PointAlt(x: 1.0, y: 1.0)
anotherPoint.moveBy(x: 2.0, y: 3.0)
anotherPoint.x
anotherPoint.y

// note that you cannot call a mutating method when the struct instance was assigned to a constant

// With mutating methods you can even replace the entire struct or enum by assigning a new value to their implicit 'self' property

struct Point3 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point3(x: x + deltaX, y: y + deltaY)
    }
}

enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}
var ovenLight = TriStateSwitch.low
ovenLight.next()
ovenLight.next()
ovenLight.next()


// TYPE METHODS
// type methods work the same as type properties:
// use the 'static' keyword to define them
// and on class types you can use the 'class' keyword to allow them to be overriden by subclasses

// Type methods don't need to use the 'self' keyword to access other type methods and properties
struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.complete(level: 1)
LevelTracker.highestUnlockedLevel

player = Player(name: "Beto")
player.tracker.advance(to: 6)

// '@discardableResult'
// ?????

