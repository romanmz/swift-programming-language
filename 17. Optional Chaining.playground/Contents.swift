

// OPTIONAL CHAINING
// ==================================================

// When you have a variable or constant with an optional type
// You can use the exclamation mark '!' to force read its value without unwrapping it first,
// but only if you're 100% sure the variable has an actual set value

var staticString: String = ""
var optionalString: String?
optionalString                      // has 'nil' value
optionalString = "hello"            // has string value
// staticString = optionalString    // ERROR: types and optional types are not interoperable

// Option 1: optional unwrapping
if let theOptionalValue = optionalString {
    staticString = theOptionalValue
}

// Option 2: compare with nil, extract with !
if optionalString != nil {
    staticString = optionalString!
}


// READING PROPERTIES WITH OPTIONAL CHAINING
// ------------------------------
// When dealing with optionals that can potentially have properties, methods or subscripts you can use '?' to attempt to read them without unwrapping the optional first
// This is similar to using ! except that ! always assumes that the optional has a set value and throws an error if it's nil
// By using '?' instead, the declaration fails gracefully if the variable is nil and returns a value of nil for that line
// Because of this, adding '?' to a variable will always return an optional, even if the called property, method or subscript were not optionals

class Person {
    var residence: Residence?
}
class Residence {
    var name = ""
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}
class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
    func roomName() -> String {
        return "The name of the room is: \( name )"
    }
}
class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}


let john = Person()

// ERROR: You can't force unwrap 'residence' with '!' because its value is nil
// let roomCount = john.residence!.numberOfRooms

// Instead you can use optional chaining with '?', in this case it will return an optional Int set to nil because 'residence' is not set
var roomCount = john.residence?.numberOfRooms

// If you add a proper value to the 'residence' property, and try the previous declaration again, you'll now get an optional Int instead of nil
john.residence = Residence()
roomCount = john.residence?.numberOfRooms

// ERROR: Combines Int with an optional Int
// let allRooms = 20 + roomCount

// Since the returned value is an optional, you need to unwrap it
if let roomCount = john.residence?.numberOfRooms {
    roomCount
} else {
    "Error"
}


// CALLING METHODS WITH OPTIONAL CHAINING
// ------------------------------

let room1: Room? = Room(name: "kitchen")

// Fails:
// room1.roomName()

// Succeeds:
let myRoomName = room1?.roomName()

// Just like properties, methods will also return an optional type which you'll need to unwrap before using
if myRoomName != nil {
    let result = "result "+myRoomName!
    result
}


// SETTING PROPERTIES WITH OPTIONAL CHAINING
// ------------------------------

// If you use optional chaining to attempt to set a property of an optional property
// The operation will return an optional Void (Void?)
// So you can unwrap it to check if the property was successfully defined:

if (john.residence?.name = "Home") != nil {
    john.residence?.name
}


// USING SUBSCRIPTS WITH OPTIONAL CHAINING
// ------------------------------

john.residence?.rooms.append( Room(name: "garage") )
john.residence?[0].name

// For subscripts that return optionals you can also add a question mark to make invalid keys fail silently:
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72 // key doesn't exist, '?' makes it fail silently and the declaration returns nil


// MULTIPLE LEVELS OF CHAINING
// ------------------------------
// You can use optional chaining on properties that have multiple nesting levels

// With properties:
if let johnsStreet = john.residence?.address?.street {
    "John's street name is \(johnsStreet)."
} else {
    "Unable to retrieve the address."
}

let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
john.residence?.address = johnsAddress
if let johnsStreet = john.residence?.address?.street {
    "John's street name is \(johnsStreet)."
} else {
    "Unable to retrieve the address."
}

// And methods:
if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    "John's building identifier is \(buildingIdentifier)."
}
if let beginsWithThe = john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
    if beginsWithThe {
        "John's building identifier begins with \"The\"."
    } else {
        "John's building identifier does not begin with \"The\"."
    }
}
