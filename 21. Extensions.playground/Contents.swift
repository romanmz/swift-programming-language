

// EXTENSIONS
// ==================================================

// Extensions add new functionality to any existing class, structure, enumeration, or protocol type

/*
 
 With extensions you can:
 - Add computed properties (instance and type)
 - Add methods (instance and type)
 - Add initializers (convenience)
 - Add subscripts
 - Add nested types (class, structure, enumeration)
 - Make an existing type conform to a protocol
 
 ~ you can only add new functionality, but you can't override anything
 
 You can't add:
 - Stored properties
 - Property observers
 - Designated initializers
 - Deinitializers
 - Protocol declarations
 - Other extension declarations
 - you can't make any declaration 'final' (it's up to the class declarations to decide that)
*/

/*
 SYNTAX:
 
 extension ExistingType: NewProtocol, AnotherNewProtocol {
    // new properties, methods and nested types
    // and implementation of the new protocol(s)
 }
 
 */


// EXAMPLE
// ------------------------------
extension Double {
    
    // Computed instance property:
    var x1000: Double { return self * 1_000.0 }
    
    // New initializer
    init(metersFromFeet feet:Double) {
        let newValue = feet / 3.28084
        self.init()
        self = newValue
        // the rules for two-phase initialization still apply on extensions
    }
    
    // New method
    func returnSquare() -> Double {
        return self * self
    }
    
    // Methods that modify a struct or enum, or its properties, need to be 'mutating'
    mutating func makeSquare() {
        self = self * self
    }
    
    // Subscripts
    subscript(i: Int) -> Double {
        get {
            return Double(i) * self
        }
        set {
            self = Double(i) * newValue
        }
    }
    
    // Nested types
    enum Kind: Int {
        case negative = -1, zero, positive
    }
    var kind: Kind {
        switch self {
            case let number where number > 0:
                return .positive
            case let number where number < 0:
                return .negative
            default:
                return .zero
        }
    }
}
var someFloat = Double(metersFromFeet: 5.7)
someFloat.x1000
someFloat.returnSquare()
someFloat.makeSquare()

someFloat[0]
someFloat[1]
someFloat[2]
someFloat[2] = 3
someFloat

someFloat.kind
someFloat.kind.rawValue
Double.Kind.negative.rawValue


// CONDITIONAL CONFORMANCE
// ------------------------------

// When extending generic types, you can apply protocols conditionally depending on whether or not the type of values it uses meets a certain criteria
/*
 extension GenericType: Protocol1 where T: Requirement1 {
 }
 extension GenericType: Protocol2 where T: Requirement2 {
 }
 */
