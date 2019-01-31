
// Use double quotes to create string literals
let someString = "Some string literal value"

// Use three double quotes to create multiline strings
let multilineString = """
	lorem ipsum
	dolor sit amet
	"""
print(multilineString)

// the rows that include the triple quotes are not taken into account
// the same spacing used on the closing line is trimmed from the whole string
// you can split a string into multiple lines for readibility, but if you don't want the string value to actually have those line breaks, add an escaping \ at the end of the line
// With all this, the following two strings are equivalent:
let singlelineString = "lorem ipsum dolor sit amet"
let multilineString2 = """
	lorem ipsum \
	dolor sit amet
	"""
singlelineString == multilineString2

// Initialize an empty string with an empty literal, or with the string constructor
let empty1 = ""
let empty2 = String()

// Use the "isEmpty" property to check if a string is empty
if empty1 == "" {
    "1 is empty"
}
if empty1.isEmpty {
    "1 is empty"
}

// You can use a for-in loop to access each character of a string (type value is 'Character' instead of 'String')
for character in someString {
	character
	type(of: character)
}
// You can also access the full collection of characters directly with the 'characters' property
for character in someString.characters {
    character
	type(of: character)
}

// You can also use string literals to create Character objects
let exclamationMark: Character = "!"

// You can build a string from an array of characters
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"]
let catString = String(catCharacters)

// Concatenation
// you can use + and +=
// or also use the "append" method by passing a string or character
var welcome = "hello there"
welcome.append(exclamationMark)

// You can convert other types into a string by using \()
let multiplier = 3
let message = "The multiplier is \(multiplier)"

// You can add these special characters:
// \0 null
// \\ backslash
// \t horizontal tab
// \n line feed
// \r carriage return
// \" double quote
// \' single quote
// \u{n} unicode character
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
let blackHeart = "\u{2665}" // Unicode scalar U+2665

// inside multiline strings you can freely use double quotes without escaping
// unless you need to have three double quotes next to each other, in that case escape at least one
let multilineEscaping = """
	use triple double quotes to create multi-line strings: \"""
	"""
print(multilineEscaping)


// Extended Unicode grapheme clusters
let enclosedEAcute: Character = "\u{E9}\u{20DD}"
let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"

// String properties and methods:
let stringIndexes = "Lorem ipsum \u{1F1FA}\u{1F1F8}"
stringIndexes.characters.count
stringIndexes.startIndex
stringIndexes.endIndex

let greeting = "Guten Tag!"
greeting[greeting.startIndex]
greeting[greeting.index(before: greeting.endIndex)]
greeting[greeting.index(after: greeting.startIndex)]
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]

welcome = "hello"
welcome.insert("!", at: welcome.endIndex)
welcome.insert(contentsOf: " there".characters, at: welcome.index(before: welcome.endIndex))

welcome.remove(at: welcome.index(before: welcome.endIndex))
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex
welcome.removeSubrange(range)
welcome

/*
 you can use the insert and remove methods on any type that conforms to the RangeReplaceableCollection protocol. This includes String, as shown here, as well as collection types such as Array, Dictionary, and Set.
 */

// String comparisons

// ==
// !=

let sceneName = "Act 1 Scene 2: Capulet's mansion"
sceneName.hasPrefix( "Act 1" )
sceneName.hasSuffix( "mansion" )
// methods are case sensitive

// Getting unicode units and scalars
let dogString = "Dog‼🐶"
for codeUnit in dogString.utf8 {
    print("\(codeUnit) ", terminator: "")
}
print("")
for codeUnit in dogString.utf16 {
    print("\(codeUnit) ", terminator: "")
}
print("")
for scalar in dogString.unicodeScalars {
    print("\(scalar.value) ", terminator: "")
}


// SUBSTRINGS
// Functions that return a substring are of a new 'Substring' type, which work the same as regular String types but contain a reference to their original string
let greeting2 = "Hello, 😜!"
let comma = greeting2.index(of: ",")!
let substring = greeting2[..<comma]
type(of: substring)
// Most String APIs can be called on Substring
print(substring.uppercased())
print("---")


