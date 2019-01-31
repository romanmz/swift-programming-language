
// Assignment
// = (does not return a value)

// Arithmetic
// + - * / %
// + also works for strings concatenation

// Unary
// -myvar // multiplies by -1
// +myvar // multiplies by 1

// Compound assignments
// += -= *= /=

// Comparisons (returns boolean)
// == != > < >= <=

// Tuples can be compared if they all share the same structure
// Values are compared left to right
// This is supported on tuples with up to 6 items, for more you need to implement a custom operator
(1, "zebra") < (2, "apple")   // true because 1 is less than 2; "zebra" and "apple" are not compared
(3, "apple") < (3, "bird")    // true because 3 is equal to 3, and "apple" is less than "bird"
(4, "dog") == (4, "dog")      // true because 4 is equal to 4, and "dog" is equal to "dog

// Identity operators (returns boolean)
// === !==
// Tests whether two object references point to the same object instance

// Ternary operator
// a ? b : c

// Nil-coalescing operator
// a ?? b
// If "a" is an optional with a set value, it unwraps and returns that value, if it's nil it defaults to "b"

// Range operators
// a...b a..<b

// Infinite sequences
// ...b  ..<b
// a...

// Can be used on subscripts:
let items = [1,2,3,4,5]
items[...2]
items[..<2]
items[2...]

// or on conditionals
let myInt = 2
switch myInt {
case ..<4:
	"less than 4"
default:
	"4 or more"
}


// Logical
// !a
// a && b
// a || b

// When combining multiple operators, they are evaluated left to right: a && b || c || d
// You can use parentheses to change the order of evaluation, or simply to add clarity: (a && b) || c || d
