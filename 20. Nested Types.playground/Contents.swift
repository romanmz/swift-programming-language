

// NESTED TYPES
// ==================================================

// Sometimes it is helpful to create utility enumerations, structures and classes meant to be used only within the context of another type (class or structure)
// To avoid polluting the global scope, you can define nested types within the braces of the main type they support
// You can have as many levels of nested types as you require

struct BlackjackCard {
    
    // nested Suit enumeration
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }
    
    // nested Rank enumeration
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
                case .ace:
                    return Values(first: 1, second: 11)
                case .jack, .queen, .king:
                    return Values(first: 10, second: nil)
                default:
                    return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    // BlackjackCard properties and methods
    let rank: Rank, suit: Suit
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

// you can pass just the values for Rank and Suit since their type can be inferred from context
let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("theAceOfSpades: \(theAceOfSpades.description)")


// REFERRING TO NESTED TYPES

// To use a nested type outside of its definition context, prefix its name with the name of the type it is nested within:
let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
