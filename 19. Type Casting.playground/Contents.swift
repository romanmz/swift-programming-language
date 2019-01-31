

// TYPE CASTING
// ==================================================

// Type casting is implemented with the 'is' and 'as' operators to check the type of a value or cast a value to a different type

// You can also check if a value conforms to a particular protocol

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}
class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}
class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]

// Swift doesn't allow arrays with values of different types
// but in this case it detects that all the included types have a common superclass,
// so the type of "library" is inferred to be [MediaItem]


// CHECKING TYPES WITHIN A CLASS HIERARCHY
// ------------------------------

// The items inside the 'library' array will all be treated as 'MediaItem' types,
// so the specific properties and methods of the subclasses won't be available

// e.g. trying to read the 'director' property of the first item will throw an error
// library[0].director

// Use the 'is' keyword followed by the subclass type to check if a particular item matches it:
var movieCount = 0
var songCount = 0
for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
movieCount
songCount


// DOWNCASTING
// ------------------------------

// If a value is being treated as a superclass, but you need to use it as its original subclass
// You can use 'as?' and 'as!' to downcast them to the subclass you need
// Since this operation can fail you need to decide which of the two options to use:
// 'as?' if you are unsure if the downcasting will succeed, returns an optional
// 'as!' if you are 100% sure the downcasting will succeed, otherwise you'll get a runtime error, returns a plain non-optional value
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// casting doesn't change the instance in any way, it only changes the way it is treated


// TYPE CASTING FOR 'ANY' AND 'ANYOBJECT'
// ------------------------------

// Swift provides two special types for working with nonspecific types:
// - 'Any' can represent an instance of any type at all, including function types
// - 'AnyObject' can represent an instance of any class type
// Use them only when you explicitly need the behavior and capabilities they provide

var things = [Any]()
things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })

print("--- Detecting Int values ---")
for thing in things {
    
    // Using 'is':
    if thing is Int {
        print("is Int: \( thing )")
    }
    
    // Using 'as?':
    if let intValue = thing as? Int {
        print("as? Int: \( intValue )")
    }
    
    // Using 'is' in a 'switch' statement:
    switch thing {
        case is Int:
            print("switch is Int: \( thing )")
        default:
            break
    }
    
    // Using 'as' in a 'switch' statement (matching any value):
    switch thing {
        case let intValue as Int:
            print("switch as Int: \( intValue )")
        default:
            break
    }
    
    // Using 'as' in a 'switch' statement (matching a specific value):
    switch thing {
        case 0 as Int:
            print("switch as Int == 0: \(thing)")
        default:
            break
    }
    
    // Using 'as' in a 'switch' statement (matching a 'where' conditional):
    switch thing {
        case let intValue as Int where intValue > 0:
            print("switch as Int where int > 0: \( intValue ) ")
        default:
            break
    }
}


// USING OPTIONALS AS 'ANY'
// -----
// 'Any' values can hold any type of values, including optionals
// However if you try adding an optional where an 'Any' is expected, you'll get a warning
// It is better to make your intent clear on what you expect to happen with that optional

let optionalNumber: Int? = 3
// things.append(optionalNumber)        // Warning: intent not clear
things.append(optionalNumber!)          // OK: force unwrap the optional and pass the plain value (could cause runtime errors)
things.append(optionalNumber ?? 10)     // OK: provide a default value to be used when the optional is nil, plain value passed
things.append(optionalNumber as Any)    // OK: instruct to pass the optional as is
