

// ADVANCED OPERATORS
// ==================================================

// Arithmetic operators in Swift do not overflow by default, they throw an error instead
// To opt-in to overflow behaviour, prefix an ampersand to the operators (e.g. '&+')

// When you define your own structures, classes, and enumerations, it can be useful to provide your own implementations of the standard Swift operators for use with these custom types
/*
 
 You can also create your own operators by adding custom:
 - prefix   (-a)
 - infix    (a-b)
 - postfix  (a-)
 
 - assignment operators (a+=b)
 
 - custom precedence
 - associativity values
 
 */


// BITWISE OPERATORS
// ------------------------------

// NOT: ~
// inverts all bits in a number
let initialBits: UInt8 = 0b00001111             // 00001111
let invertedBits = ~initialBits                 // 11110000
// (UInt8 stores up to 255 values)

// AND: &
// combines the bits of two numbers (intersection)
let firstSixBits: UInt8 = 0b11111100            // 11111100
let lastSixBits: UInt8  = 0b00111111            // 00111111
let middleFourBits = firstSixBits & lastSixBits // 00111100

// OR: |
// Combines the bits of two numbers (addition)
let someBits: UInt8 = 0b10110010                // 10110010
let moreBits: UInt8 = 0b01011110                // 01011110
let combinedbits = someBits | moreBits          // 11111110

// XOR: ^
// Adds the bits included only on either of the values
let firstBits: UInt8 = 0b00010100               // 00010100
let otherBits: UInt8 = 0b00000101               // 00000101
let outputBits = firstBits ^ otherBits          // 00010001

// Left Shift and Right Shift: << >>
// Move all bits in a number to the left or right
let shiftBits: UInt8 = 4                        // 00000100
shiftBits >> 1                                  // 00000010
shiftBits >> 2                                  // 00000001
shiftBits >> 3                                  // 00000000


// OVERFLOW OPERATORS
// ------------------------------

// By default Swift throws an error when a value overflows its limits:
var testInt = Int8.max
// ERROR:
// testInt += 1


// VALUE OVERFLOW:
// Manually opt-in to overflow by adding an ampersand before the + - and * operators
testInt
testInt = testInt &+ 1
testInt = testInt &- 1
testInt = testInt &* 10


// PRECEDENCE AND ASSOCIATIVITY
// ------------------------------
// Operator 'precedence' gives some operators higher priority than others (they are applied first)
// Operator 'associativity' defines how operators of the same precedence are grouped together (they associate with the expression to the left, or to the right)

2 + 3 % 4 * 5
// in this example % and * have higher precedence than +
// they also both have the same precedence
// and their associativity is to the left
// so the same expression can be written like this:
2 + ((3 % 4) * 5)


// OPERATOR METHODS
// ------------------------------

// Classes and structures can provide their own implementations of existing operators (this is called 'overloading')
// you can't overload the default assignment operator (=) or the ternary operator (a ? b : c)


// EXAMPLE OF BINARY OPERATOR (a+b)
// binary operator: operates on two targets
// infix: appears in between them

struct Vector2D {
    var x = 0.0, y = 0.0
}

// by default you can't add two of these structs, so we use an extension to implement the + operator
// (it needs to be a type method instead of an instance method)
extension Vector2D {
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }
}

// result:
let vector = Vector2D(x: 3.0, y: 1.0)
let anotherVector = Vector2D(x: 2.0, y: 7.5)
var combinedVector = vector + anotherVector
combinedVector.x
combinedVector.y


// EXAMPLE OF UNARY OPERATOR (-a)
// When implementing unary operators, you'll need to add a 'prefix' keyword to indicate that the operator will come before the value it affects, or 'postfix' to indicate that it will come after
extension Vector2D {
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }
}
combinedVector.x
combinedVector.y
-combinedVector.x
-combinedVector.y


// EXAMPLE OF COMPOUND ASSIGNMENT OPERATOR (+=)
// This is also a binary, infix operator, so it's implemented the same was as the + operator
// except that you also need to mark the first element as 'inout' since the operator acts directly on it
extension Vector2D {
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right
    }
}
combinedVector.x
combinedVector.y
combinedVector += Vector2D(x: 1.0, y: 2.0)
combinedVector.x
combinedVector.y


// EQUIVALENCE OPERATORS
// Also binary and infix, so similar implementation as +
// it always needs to return a Bool
extension Vector2D {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
    static func != (left: Vector2D, right: Vector2D) -> Bool {
        return !(left == right)
    }
}
let twoThree = Vector2D(x: 2.0, y: 3.0)
let anotherTwoThree = Vector2D(x: 2.0, y: 3.0)
twoThree == anotherTwoThree
twoThree == combinedVector

// you can get swift to implement this automatically by making the type conform to the 'Equatable' protocol
// this works only on these cases:
// - Structures that have only stored properties that conform to the Equatable protocol
// - Enumerations that have only associated types that conform to the Equatable protocol
// - Enumerations that have no associated types


// CUSTOM OPERATORS
// ------------------------------
// You can declare and implement your own custom operators
// they need to be declared at a global level using the 'operator' keyword
// and marking it as a 'prefix', 'infix', or 'postfix'
// you can use the following characters:   / = - + ! * % < > & | ^ ? ~
// they can also begin with a dot, and if they do they can contain other dots .+.
// however an operator that doesn't begin with a dot, can't have other dots elsewhere
prefix operator +++

// you'll get an error if you try to declare an operator that already exists:
// prefix operator -

// You can implement the new operator in any existing types straight away
extension Vector2D {
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector
        return vector
    }
}
combinedVector.x
combinedVector.y
+++combinedVector
combinedVector.x
combinedVector.y

// If you apply both a prefix and a postfix operator to the same unary operand, the postfix operator is applied first


// SPECIFIYING PRECEDENCE FOR CUSTOM INFIX OPERATORS
// ---
// The precedence and associativity rules described before apply only to binary infix operators


// ASSIGNING AN OPERATOR TO A PRECEDENCE GROUP
// if you created your own custom infix operator you also need to consider defining its rules for precedence and associativity
// You do this with 'precedence groups'
// To add a new operator to an existing precedence group, add a colon after defining it, followed by the precedence group name
// otherwise its precedence group will be set to 'DefaultPrecedence'
// the standard available precedence groups are (in order of decreasing precedence):
// - BitwiseShiftPrecedence         << >>
// - MultiplicationPrecedence       * / % &* &
// - AdditionPrecedence             + - &+ &- | ^
// - RangeFormationPrecedence       ..< ...
// - CastingPrecedence              is as as? as!
// - NilCoalescingPrecedence        ??
// - ComparisonPrecedence           < <= > >= == != === !== ~=
// - LogicalConjunctionPrecedence   &&
// - LogicalDisjunctionPrecedence   ||
// - DefaultPrecedence
// - TernaryPrecedence              ?:
// - AssignmentPrecedence           = *= /= %= += -= <<= >>= &= |= ^=


// CREATING A PRECEDENCE GROUP
// To create your own custom group, begin with the keyword 'precedencegroup' followed by the name of the new group and its properties inside braces:
precedencegroup MyPrecedenceGroup {
    
    // operators with higher precedence run first, e.g. 1 + 2 * 3 equals 7 because * has higher precedence than +
    
    // if you want to use the operators that belong to this group with operators from other groups without having to group them with parentheses
    // you'll need to define the precedence of this group relative to the other groups you want to interact with
    // use 'higherThan' to list the precedence groups that will have a lower precedence than this one
    // and 'lowerThan' to do the opposite ('lowerThan' should only include precedence groups defined outside the current module)
    
    // for each group that you add to these properties, Swift will automatically infer the precedence of as many other groups as it can
    // for example if you make this group 'higherThan: MultiplicationPrecedence', Swift will infer that this group is also higher than than the 'AdditionPrecedence' group (since that one has lower precedence than 'MultiplicationPrecedence')
    // If you add rules that are contradictory (e.g. higherThan: MultiplicationPrecedence and lowerThan: AdditionPrecedence) you'll get an error
    // Operators belonging to groups that are not listed here (and can't be inferred) can't be used next to operators from this new group without grouping them with parentheses, as their relationships with each other are not clear enough
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
    
    // 'associativity' defines how operators within this group will behave when they are next to each other without parentheses
    // values can be 'left', 'right', or 'none'
    // A statement with operators from the same precedence group like this one: 4 - 5 + 6
    // will be processed differently according to their associativity
    // left associativity:  (4 - 5) + 6 = +5
    // right associativity: 4 - (5 + 6) = -7
    // none:                ERROR: they can't be next to each other without being explicitely grouped with parentheses
    // default value is 'none'
    associativity: left
    
    // 'assignment' defines the precedence of operators when used in an operation that includes optional chaining
    // if set to true, operators will use the same grouping rules as the assignment operators from the standard library
    // if set to false, they will follow the same rules as operators that don't perform assignment
    // (???) don't understand this lol
    // defaults to 'false'
    assignment: false
}

// New custom operators using a custom precedence group:
infix operator +*: MyPrecedenceGroup
infix operator +-: MyPrecedenceGroup
extension Vector2D {
    static func * (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x * right.x, y: left.y * right.y)
    }
    static func +* (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y * right.y)
    }
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
    func description() -> String {
        return "X: \(x)   Y: \(y)"
    }
}
var testVector = Vector2D(x: 2.0, y: 3.0)
testVector.description()

// testing new operators:
// X: 2+2=4   Y: 3*3=9
( testVector +* testVector ).description()
// X: 2+2=4   Y: 3-3=0
( testVector +- testVector ).description()

// testing precedence relative to AdditionPrecedence and MultiplicationPrecedence:
// higher than + higher than *:     X: 2+((2+2)*2)=+10   Y: 3+((3*3)*3)= +30
// higher than + lower  than *:     X: 2+(2+(2*2))=+08   Y: 3+(3*(3*3))= +30
// lower  than + lower  than *:     X: (2+2)+(2*2)=+08   Y: (3+3)*(3*3)= +54
( testVector + testVector +* testVector * testVector ).description()

// testing associativity:
// left:  X: (2+2)+2=+6   Y: (3*3)-3=+6
// right: X: 2+(2+2)=+6   Y: 3*(3-3)=+0
// none:  ERROR
( testVector +* testVector +- testVector ).description()
