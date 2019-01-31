


// CLASSES AND STRUCTURES
// ==================================================

// can have properties (variables and constants)
// and methods (functions)

/*
 
 In Swift, classes and structures have a lot in common, both can:
 - Have properties
 - Have methods
 - Define subscripts to be used with subscript syntax
 - Have initializer methods
 - Be extended
 - Conform to protocols
 
 Classes have additional capabilities that structures do not:
 - Inheritance
 - Type casting
 - Deinitializers
 - Reference counting
    - Classes can have more than one reference to the same instance
    - So class instances can be copied or referenced
    - Structs on the other hand are always copied
 
 Structs can:
 - have a default initializer function where you can set the values for all its properties
 
 */


// SYNTAX
struct Resolution {
    var width = 0
    var height = 0
}
class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}
let someResolution = Resolution()
let someVideoMode = VideoMode()
someResolution.width
someVideoMode.resolution.height
someVideoMode.resolution.height = 768
someVideoMode.resolution.height

// Memberwise initializers
// Structs automatically create an initializer function you can use to set all its properties
let vga = Resolution(width: 640, height: 480)
// Error:
// let vgaMode = VideoMode(resolution: vga, interlaced: true, frameRate: 24.0);


// STRUCTS AND ENUMS ARE 'VALUE TYPES'
// This means that when passing them to another variable, constant or function,
// new independent instances are created
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
hd.width
cinema.width

// CLASSES ARE 'REFERENCE TYPES'
// This means that when passed to another variable, constant or function, they all refer back to the same instance
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

tenEighty.frameRate
alsoTenEighty.frameRate


// IDENTITY OPERATOR
// To check if two variables or constants refer to the exact same instance
// Use the identity operator ===
// Note that the equality operator == only checks if the two values are equivalent, even if they come from different instances
if tenEighty === alsoTenEighty {
    "Same instance"
}

// CHOOSING BETWEEN CLASS AND STRUCT
/*
 
 As a general guideline, choose a struct if one or more of these are true:
 - Needs only a few simple data values.
 - They can be expected to be copied around rather than referenced
 - The properties are also expected to be value types (i.e. copied, not referenced)
 - It does not need to inherit properties or behavior from another existing type
 
 Otherwise create a class
 
 */
