


// COLLECTION TYPES
// ==================================================



// ARRAYS
// ------------------------------
// Stores values of the same type
// in an ordered list
// the same value can appear multiple times at different positions

// Initializing
var arrayInit1: Array<Int>
var arrayInit2: [Int]

// Settings values
arrayInit2 = Array()
arrayInit2 = Array(repeating:10, count:3)
arrayInit2 = []
arrayInit2 = [1,2,3]

// Initializing an empty array
let arrayEmpty1: Array<Int> = Array()
let arrayEmpty2: Array<Int> = []
let arrayEmpty3: [Int] = Array()
let arrayEmpty4: [Int] = []
let arrayEmpty5 = Array<Int>()
let arrayEmpty6 = [Int]()

// Initializing an array with data (explicit type)
let arrayExplicit1: Array<Int> = Array(repeating: 10, count: 3)
let arrayExplicit2: Array<Int> = [1,2,3]
let arrayExplicit3: [Int] = Array(repeating: 10, count: 3)
let arrayExplicit4: [Int] = [1,2,3]
let arrayExplicit5 = Array<Int>(repeating:10, count:3)
let arrayExplicit6 = [Int](repeating:10, count:3)

// Initializing an array with data (implicit type)
let arrayImplicit1 = Array(repeating: 10, count: 3)
let arrayImplicit2 = [1,2,3]

// Using the assignment "+" operator
// only works if both arrays contain data of the same type
var mergedArray = arrayImplicit1 + arrayImplicit2
mergedArray += [4]

// Properties and methods
mergedArray.count
mergedArray.isEmpty
mergedArray.append(20)
mergedArray.insert(99, at: 0)
mergedArray.remove(at: 0)
mergedArray.removeLast()
mergedArray

// Using subscript syntax
mergedArray[2]
mergedArray[2] = 0
mergedArray
mergedArray[0...2] = [10,9,8]
mergedArray

// Iterating over an array
for value in mergedArray {
    print( value )
}

// Use the enumerated() function to get a tuple that includes the indexes of each item
for (index, value) in mergedArray.enumerated() {
    print( index )
    value
}



// SETS
// ------------------------------
// Stores values of the same type
// in an unordered list
// only contains unique values

// A type must be 'hashable' to be able to be stored on a set
// This means that the type should be able to compute a hash integer for their values
// These hashes are used to compare values, identical values should always generate identical hashes

// String, Int, Double and Bool are hashable by default
// Also Enumeration cases without associated values

// You can use your own types if you make them conform to the 'Hashable' protocol

// Initializing
var setInit: Set<String>

// Setting values
setInit = Set()
setInit = []
setInit = ["Rock", "Pop", "Classical"]

// Initializing an empty set
let setEmpty1: Set<String> = Set()
let setEmpty2: Set<String> = []
let setEmpty3 = Set<String>()

// Initializing a set with data
let setExplicit: Set<String> = ["Rock", "Pop", "Classical"]
var setImplicit: Set = ["Rock", "Pop", "Classical"] // Still use 'Set' to avoid getting an Array

// Methods and properties
setImplicit.count
setImplicit.isEmpty
setImplicit.insert("Jazz")
setImplicit
setImplicit.remove("Jazz")
setImplicit
setImplicit.contains("Rock")
setImplicit.sorted()
// setImplicit.removeAll()

// Iterating over a set
for genre in setImplicit {
    print( genre )
}

// SET OPERATIONS
let oddDigits: Set =   [1, 3, 5, 7, 9]
let primeDigits: Set = [2, 3, 5, 7]

// union() returns all items of both sets
oddDigits.union(primeDigits).sorted()
// intersection() returns only items shared by both sets
oddDigits.intersection(primeDigits).sorted()
// symmetricDifference() returns only items NOT shared between sets (opposite of intersection)
oddDigits.symmetricDifference(primeDigits).sorted()
// subtracting() returns unique items of the first set only
oddDigits.subtracting(primeDigits).sorted()

// SET MEMBERSHIP AND EQUALITY
let houseAnimals: Set = ["🐶", "🐱"]
let favouriteAnimals: Set = ["🐱", "🐶"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

// == checks if two sets have exactly the same items
houseAnimals == favouriteAnimals
houseAnimals == farmAnimals

// isSubset checks if all the items of a set are contained in another
houseAnimals.isSubset(of: favouriteAnimals)
houseAnimals.isSubset(of: farmAnimals)

// isSuperset checks if some items of the set make up the entirety of the 2nd set
favouriteAnimals.isSuperset(of: houseAnimals)
farmAnimals.isSuperset(of: houseAnimals)

// Use the strict versions to also check that both sets are not equal
houseAnimals.isStrictSubset(of: favouriteAnimals)
houseAnimals.isStrictSubset(of: farmAnimals)
favouriteAnimals.isStrictSuperset(of: houseAnimals)
farmAnimals.isStrictSuperset(of: houseAnimals)

// isDisjoint checks if both sets don't have a single item in common
farmAnimals.isDisjoint(with: cityAnimals)



// DICTIONARIES
// ------------------------------
// Stores values of the same type against keys of the same type
// in an unordered list
// can contain duplicate values, but can only contain unique keys

// Types used as keys must conform to the Hashable protocol (just like sets)
// Values can be of any type

// Initializing
var dictInit1: Dictionary<Int, String>
var dictInit2: [Int: String]

// Settings values
dictInit2 = Dictionary()
dictInit2 = [:]
dictInit2 = [1:"one", 2:"two", 3:"three"]

// Initializing an empty dictionary
let dictEmpty1: Dictionary<Int, String> = Dictionary()
let dictEmpty2: Dictionary<Int, String> = [:]
let dictEmpty3: [Int: String] = Dictionary()
let dictEmpty4: [Int: String] = [:]
let dictEmpty5 = Dictionary<Int, String>()
let dictEmpty6 = [Int: String]()

// Initializing a dictionary with data
let dictExplicit1: Dictionary<Int, String> = [1:"one", 2:"two", 3:"three"]
let dictExplicit2: [Int: String] = [1:"one", 2:"two", 3:"three"]
var dictImplicit = [1:"one", 2:"TWO", 3:"three"]

// Initializing a dictionary from a sequence
let simpleSequence = ["Cagney", "Lacey", "Bensen"]
let dictFromSequence = Dictionary(uniqueKeysWithValues: zip(1..., simpleSequence))

// Initializing a dictionary from a sequence, defining how to handle duplicate keys
// the 'uniquingKeysWith' parameter is a function that receives two different values belonging to the same key, you return the one you want to pick
let duplicatesSequence = [("a", 1), ("b", 2), ("a", 3), ("b", 4)]
let dictFromSequenceWithDuplicates = Dictionary(duplicatesSequence, uniquingKeysWith: { (first, _) in first })
dictFromSequenceWithDuplicates

// Initializing a dictionary containing sequences grouped by a dynamically generated key
// the 'by' parameter is a function that receives each individual value, and you return the key name of the collection where the value should be included
let anotherSequence = ["Julia", "Susan", "John", "Alice", "Alex"]
let dictWithGroupedSequences = Dictionary(grouping: anotherSequence, by: { $0.first! })
dictWithGroupedSequences

// Properties and methods
dictImplicit.count
dictImplicit.isEmpty
dictImplicit.updateValue("two", forKey: 2) // returns an optional with the old value if there was any, or nil
dictImplicit.removeValue(forKey: 3) // also returns an optional with the old value
dictImplicit.keys
dictImplicit.values

// Using subscript syntax
dictImplicit[2] // Reading items returns an optional type, this line returns an optional string with a value
dictImplicit[3] // this returns an optional string with nil
dictImplicit[3] = "three" // Sets a value
dictImplicit[3] = nil // Deletes a value

// Using subscript syntax with default values (this makes the returned type a non-optional)
let dict = [1:"one", 2:"two", 3:"three"]
let dictSubscript1 = dict[1]
type(of: dictSubscript1)
let dictSubscript2 = dict[5]
type(of: dictSubscript2)
let dictSubscript3 = dict[5, default: "more than three"]
type(of: dictSubscript3)

// Iterating over a dictionary
for (number, numberString) in dictImplicit {
    number
    print( numberString )
}

// Use the .keys and .values properties to get a list of only the keys or values of a dictionary
// you can call the .sorted() method on these lists, or use them to create array objects
for numberInt in dictImplicit.keys.sorted() {
    print( numberInt )
}
for numberString in dictImplicit.values {
    print( numberString )
}
let newArray = [Int]( dictImplicit.keys.sorted() )
