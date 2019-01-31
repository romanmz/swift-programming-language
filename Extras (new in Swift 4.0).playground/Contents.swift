
import Foundation


// SMART KEY PATHS
// ------------------------------

// All types automatically generate 'key paths', which is a way to walk through their nested properties and types by referencing the same structure in which they were defined

// To get a keypath simply add a backslash followed by the path to the property you want to access, e.g:
struct Person {
	var name: String
}
struct Book {
	var title: String
	var authors: [Person]
	var primaryAuthor: Person {
		return authors.first!
	}
}
let abelson = Person(name: "Harold Abelson")
let sussman = Person(name: "Gerald Jay Sussman")
let book = Book(title: "Structure and Interpretation of Computer Programs", authors: [abelson, sussman])

// Key Path:
\Book.title

// All types also get an automatic subscript that can be used with key paths
book[keyPath: \Book.title]
book[keyPath: \Book.primaryAuthor.name]

// Keypaths can be assigned and modified as constants and variables, which then can be passed as the argument for the subscript
let authorKeyPath = \Book.primaryAuthor
let nameKeyPath = authorKeyPath.appending(path: \.name)
book[keyPath: nameKeyPath]

// This is the equivalent of just directly accessing the nested properties separeted by dots, but keypaths can be useful when you need to make the used properties dynamic
book.primaryAuthor.name

// You can also use subscripts within keypaths, e.g:
let hello = ["hello", "hola", "bonjour"]
let secondItem = \[String][1]
hello[keyPath: secondItem]

// keypaths can also use optional chaining and forced unwrapping


// 'CODABLE' PROTOCOL
// ------------------------------

// By making your types conform to the new 'Codable' protocol, you can easily encode your types into different types of data, and decode them back into their types
// All basic types (Int, String, Bool, Double, etc…) already conform to that protocol, so if your type includes only those, you can declare conformance straight away, otherwise for the other types you need to make them conforming as well first

struct Card: Codable, Equatable {
	enum Suit: String, Codable {
		case clubs, spades, hearts, diamonds
	}
	enum Rank: Int, Codable {
		case two = 2, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
	}
	var suit: Suit
	var rank: Rank
	static func ==(lhs: Card, rhs: Card) -> Bool {
		return lhs.suit == rhs.suit && lhs.rank == rhs.rank
	}
}
let hand = [Card(suit: .clubs, rank: .ace), Card(suit: .hearts, rank: .queen)]


// Encoding Example: JSON
var encoder = JSONEncoder()
let jsonData = try encoder.encode(hand)
jsonData
String(data: jsonData, encoding: .utf8)

// Decoding Example: JSON
let decoder = JSONDecoder()
let decodedHand = try decoder.decode([Card].self, from: jsonData)
decodedHand
decodedHand == hand


// DICTIONARY AND SET ENHANCEMENTS
// ------------------------------

// you can define a default value to be used when a subscript fails (making the returned type a non-optional)
let dict = [1:"one", 2:"two", 3:"three"]
let dictSubscript1 = dict[1]
type(of: dictSubscript1)
let dictSubscript2 = dict[5]
type(of: dictSubscript2)
let dictSubscript3 = dict[5, default: "more than three"]
type(of: dictSubscript3)

// New initializer: passing a sequence
let names = ["Cagney", "Lacey", "Bensen"]
let dict2 = Dictionary(uniqueKeysWithValues: zip(1..., names))
dict2[2]

// New initializer: passing a sequence, defining how to handle duplicate keys
let duplicates = [("a", 1), ("b", 2), ("a", 3), ("b", 4)]
let letters = Dictionary(duplicates, uniquingKeysWith: { (first, _) in first })
letters

// New initializer: creating nested sequeneces grouped by a parameter you define
let contacts = ["Julia", "Susan", "John", "Alice", "Alex"]
let grouped = Dictionary(grouping: contacts, by: { $0.first! })
grouped
