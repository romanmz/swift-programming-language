


// CONTROL FLOW
// ==================================================


// for-in loops
// ------------------------------
// Variable names used on a loop are set as constants, only available within each iteration of the loop

// arrays
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

// dictionaries
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

// numeric ranges
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

// Use an underscore as variable name to ignore the values when you don't need them
let base = 3
let power = 5
var answer = 1
for _ in 1...power {
    answer *= base
}

// Use 'strides' when you need to loop through an interval skipping a set amount of steps each time
let minutes = 60
let minuteInterval = 5

// The 'to' argument is non-inclusive
var result = ""
for tickMark in stride(from: 0, to: minutes, by: minuteInterval) {
    result += " \( tickMark )"
}
result

// To make it inclusive, use 'through' instead
result = ""
for tickMark in stride(from: 0, through: minutes, by: minuteInterval) {
    result += " \( tickMark )"
}
result


// while and repeat-while loops
// ------------------------------
// Same as while and do-while loops on other languages


// if-else statements
// ------------------------------
// Same as on other languages
var temperatureInFahrenheit = 90
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen.")
} else {
    print("It's not that cold. Wear a t-shirt.")
}


// switch statements
// ------------------------------
// Works the same as other languages, except that:
// Cases always break out of the switch statement, so using the 'break' keyword is not necessary
let someCharacter: Character = "z"
switch someCharacter {
    case "a":
        print("The first letter of the alphabet")
    case "z":
        print("The last letter of the alphabet")
    default:
        print("Some other character")
}

// To make a single case match different conditions, separate them by commas
// (instead of writing separate 'cases' like in other languages)
let anotherCharacter: Character = "a"
switch anotherCharacter {
    case "a", "A":
        print("The letter A")
    default:
        print("Not the letter A")
}

// Interval matching
let approximateCount = 62
let naturalCount: String
switch approximateCount {
    case 0:
        naturalCount = "no"
    case 1..<5:
        naturalCount = "a few"
    case 5..<12:
        naturalCount = "several"
    case 12..<100:
        naturalCount = "dozens of"
    case 100..<1000:
        naturalCount = "hundreds of"
    default:
        naturalCount = "many"
}

// Tuple matching
let somePoint = (1, 1)
switch somePoint {
    case (0, 0):
        print("\(somePoint) is at the origin")
    case (_, 0):
        print("\(somePoint) is on the x-axis")
    case (0, _):
        print("\(somePoint) is on the y-axis")
    case (-2...2, -2...2):
        print("\(somePoint) is inside the box")
    default:
        print("\(somePoint) is outside of the box")
}

// You can create temporary variables and constants for each case
let anotherPoint = (2, 0)
switch anotherPoint {
    case (let x, 0):
        print("on the x-axis with an x value of \(x)")
    case (0, let y):
        print("on the y-axis with a y value of \(y)")
    case let (x, y):
        print("somewhere else at (\(x), \(y))")
}

// Use the 'where' keyword to check for additional conditions
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
    case let (x, y) where x == y:
        print("(\(x), \(y)) is on the line x == y")
    case let (x, y) where x == -y:
        print("(\(x), \(y)) is on the line x == -y")
    case let (x, y):
        print("(\(x), \(y)) is just some arbitrary point")
}


// continue and break
// ------------------------------
// Work the same as in other languages


// fallthrough
// ------------------------------
// Allows cases within a switch statement to fall through the next cases
// the same way they do on other languages when there is no 'break' statement
// Note that this causes the next case to always execute even if it doesn't match the tested variable
let testInt = 5
switch testInt {
    case 0...3:
        print( "3 or less" )
    case 4...6:
        print( "between 4 and 6" )
        fallthrough
    case 7...9:
        print( "between 7 and 9" )
    default:
        print( "7 or more" )
}


// statement labels
// ------------------------------
// You can name a conditional or loop, which is useful for when you have nested statements
// and need to use 'continue' or 'break'
let colors1 = ["red","green","blue"]
let colors2 = ["yellow","magenta","green"]
colorLoop1: for color1 in colors1 {
    colorLoop2: for color2 in colors2 {
        if color1 == color2 {
            break colorLoop1
        }
        color2
    }
    color1
}


// guard conditional
// ------------------------------
// similar to an if statement, but any variables or constants created within it are available on the following lines of code
// this is used for checking conditions that are necessary for the function to keep running, and exiting if they are not met
func greet(person: [String: String]) -> String {
    var result = ""
    
    // check name
    guard let name = person["name"] else {
        return result
    }
    result += "Hello \(name)!"
    
    // check location
    guard let location = person["location"] else {
        result += " I hope the weather is nice near you."
        return result
    }
    
    // return
    result += " I hope the weather is nice in \(location)."
    return result
}
greet(person: [:])
greet(person: ["name": "John"])
greet(person: ["name": "Jane", "location": "Cupertino"])


// #available condition
// ------------------------------
// Checks for API availability
if #available(iOS 10, macOS 10.12, *) {
    // Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
    // Fall back to earlier iOS and macOS APIs
}
