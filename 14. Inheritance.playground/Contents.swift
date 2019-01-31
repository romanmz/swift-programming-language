

// INHERITANCE
// ==================================================

// When one class inherits from another, the inheriting class is known as a subclass, and the class it inherits from is known as its superclass.

// Subclasses can call, access and override the methods, properties and subscripts of the superclass

// A class that does not inherit from another is called a 'base class'

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do nothing - an arbitrary vehicle doesn't necessarily make a noise
    }
}
let someVehicle = Vehicle()
someVehicle.description

// Subclassing
class Bicycle: Vehicle {
    var hasBasket = false
}
let bicycle = Bicycle()
bicycle.hasBasket = true

// Subclasses can themselves be subclassed
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0

tandem.currentNumberOfPassengers
tandem.hasBasket
tandem.description


// OVERRIDING
// ------------------------------
// To override a property, method or subscript on a subclass, add the 'override' keyword
// The new properties and methods still need to match the type of the original ones
// To access the original implementation on the super class, use the 'super' prefix

// Overriding methods
// ---
class Train: Vehicle {
    override func makeNoise() {
        "Choo Choo"
    }
}
let train = Train()
train.makeNoise()

// Overriding property getters and setters
// ---
// You can provide getters and setters for any inherited property
// Regardless of whether the original is a stored or computed property

// On a subclass you can turn a read-only property into read-write
// but you can't do the opposite

// If you override the setter, you must also override the getter
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
car.description

// Overriding property observers
// ---
// You can add property observers to any inherited property, regardless of how the original was implemented,
// Except when the originals are constants or read-only (as the observers would then be pointless)

// You also can't add property observers if you're already overriding the setter
// since you can observe the changes yourself from within that function
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
automatic.description

// Preventing overrides
// ---
// Use the 'final' modifier to prevent properties, methods and subscripts from being modified by subclasses
// This can also be used when you are extending the definition of an existing class

// You can also mark the entire class as final by adding the modifier before the 'class' keyword
// this will prevent this class from being used to create any subclasses
