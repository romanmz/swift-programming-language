

// Metatypes
// ------------------------------

// A metatype refers to the underlaying types of all other types
// for example:
// the meta type of classes, structs and enums is TypeName.Type
// the meta type of protocols is ProtocolName.Protocol

// You can get meta types as values by writing the name of the type followed by '.self'
var intInstance = Int( 15 )
var intMetatype = Int.self

var arrayInstance = Array<Int>( [1,2,3] )
var arrayMetatype = Array<Int>.self

protocol TestProtocol {}
var protocolMetatype = TestProtocol.self

// Or you can also get the metatype used on a particular instance using the 'type(of:)' function
var intMetatypeFromInstance = type(of: intInstance)
intMetatype == Int.self
intMetatype == intMetatypeFromInstance

// When passing the metatypes as values to a variable or constant, the type will be automatically inferred
// but you can also make it explicit as with any other types
// Note that even if the new values are of type .Type, you need to pass the value of '.self' instead of '.Type'

// VALID:
var newType1 = Int.self
var newType2: Int.Type = Int.self

// ERROR:
// var newType3 = Int.Type

// You can use the obtained metatypes just like the original type, for example to initialize instances of that type
// Note that when using initializers you need to call them explicitely as if they were regular methods
var newIntInstance = newType1.init( 123.5 )
switch newIntInstance {
    case is Int:
        "int"
    default:
        "not int"
}


// LITERAL EXPRESSIONS (???)
// ------------------------------

// Special literals:
func literalExpressions() {
    print( #file )
    print( #line )
    print( #column )
    print( #function )
    // print( #dsohandle )
}
literalExpressions()

// plus others…


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


// COMPILER CONTROL STATEMENTS
// ------------------------------


// CONDITIONAL COMPILATION BLOCK
// A conditional compilation block adds conditional statements that are evaluated at compile time (not runtime)
// They must begin with #if, end with #endif, and you can add #elseif in between

let value1 = 1
let value2 = 10
#if value1 || value2
    // you can use regular boolean values and expressions
#elseif ( os( tvOS ) && os( iOS ) )
    // Check the target OS for the current app being compiled
    // valid values are: macOS, iOS, watchOS, tvOS and Linux
#elseif swift( >=3.1.2 )
    // Check the version of swift being used
#elseif arch( i386 )
    // Or check the processor
    // valid values are: i386, x86_64, arm, arm64
#elseif compiler( >=3.1.2 )
    // Check the version of the compiler being used
#elseif canImport( modulename )
    // Checks whether or not a particular module is currently available
#elseif targetEnvironment( simulator )
    // Returns true if the code is running on the simulator, false otherwise
#endif


// LINE CONTROL STATEMENT (???)
// Use a line control statement to change the source code location used by Swift for diagnostic and debugging purposes
// #sourceLocation(file: "string literal", line: +12) // changes the source location of the file
// #sourceLocation()    // resets the source location


// COMPILE-TIME DIAGNOSTIC STATEMENTS
// throwing errors (stops the compilation)
// #error("this is a fatal error")
// throwing warnings (continues the compilation)
// #warning("this is a warning")


// AVAILABILITY CONDITION
// You can check if a particular API is available at runtime and execute different code accordingly
// you use it within 'if', 'while' and 'guard' statements

// it takes a list with the required platforms and their version numbers
// and you always add a star at the end to support possible future platforms:
if #available( iOS 9, tvOS 2, *) {
    // code to be executed when the required API's are available
} else {
    // fallback code
}


// DECLARATION MODIFIERS
// ------------------------------
// Other modifiers not covered before:

// 'dynamic' (???)
// Apply this modifier to any member of a class that can be represented by Objective-C

// 'unowned(safe)'
// Same as 'unowned', used to explicitely differentiate it from the 'unowned(unsafe)' modifier

// 'unowned(unsafe)'
// Safe unowned properties will throw an error when you try to read them after the instance they used to hold has been dealloacted
// Unsafe unowned properties instead of throwing an error will try to access the memory at the location where the instance used to be, which is a memory-unsafe operation


// EXPRESSION PATTERNS
// ------------------------------
// An expression pattern represents the value of an expression inside a 'switch' case statement
// They use the standard '~=' operator to determine if two values have a matching pattern

// You can overload this operator just like any others, in this example we extend the operator to support comparing strings and ints:

let point = (1, 2)
switch point {
    case (0, 0):
        "The point is at the origin"
    // ERROR: Can't compare ints to strings:
    // case("1", "2"):
    //    "exact match (using strings instead of ints)"
    //
    case (-2...2, -2...2):
        "The point is near the origin"
    default:
        "The point is at (\(point.0), \(point.1))"
}

// Overloading ~=
func ~= (pattern: String, value: Int) -> Bool {
    return pattern == "\(value)"
}

// Previous switch pattern now working:
switch point {
    case (0, 0):
        "The point is at the origin"
    case("1", "2"):
        "exact match (using Strings)"
    case (-2...2, -2...2):
        "The point is near the origin"
    default:
        "The point is at (\(point.0), \(point.1))"
}
( "1" ~= 1 )


// ATTRIBUTES
// ------------------------------

// Attributes are used to provide extra information about a declaration
// There's 2 types of attributes: 'declaration' attributes and 'type' attributes
// Attributes begin with the '@' symbol, followed by the attribute name, and any arguments the attribute accepts inside parentheses


// DECLARATION ATTRIBUTES
// These attributes can be used on any declaration

// 'available' (???)
// Use this attribute to indicate the lifecycle of the declaration relative to the version of the OS, platform, or Swift language
/*
 
 The examples on the book are not compiling here ¯\_(ツ)_/¯
 so i'll just copy the list of arguments this attribute supports:
 
 - platform / version number:
    - iOS
    - iOSApplicationExtension
    - macOS
    - macOSApplicationExtension
    - watchOS
    - watchOSApplicationExtension
    - tvOS
    - tvOSApplicationExtension
    - swift
    - * (used to indicate support for all the platforms, can't be used when declaring support for a specific version of Swift)
 - unavailable
 - introduced: 1.0.0
 - deprecated: 1.0.0
 - obsoleted: 1.0.0
 - message: "message"
 - renamed: "newName"
 
 */

// 'discardableResult'
// Apply this to functions or methods to suppress compiler warnings when the value they return is not used anywhere

// 'dynamicMemberLookup' (???)
// Apply this attribute to a class, structure, enumeration, or protocol to enable members to be looked up by name at runtime. The type must implement a subscript(dynamicMemberLookup:) subscript.

// 'GKInspectable' (???)
// Apply this attribute to expose a custom GameplayKit component property to the SpriteKit editor UI

// 'inlinable' (???)
// Apply this attribute to a function, method, computed property, subscript, convenience initializer, or deinitializer declaration to expose that declaration’s implementation as part of the module’s public interface

// 'usableFromInline' (???)
// Apply this attribute to a function, method, computed property, subscript, initializer, or deinitializer declaration to allow that symbol to be used in inlinable code that’s defined in the same module as the declaration. The declaration must have the internal access level modifier

// 'objc'
// Apply this attribute to any declaration that can be used in Objective-C
// Classes marked with this attribute need to inherit from Objective-C classes
// The compiler implicitely adds this to classes that inherit from other classes with the attribute, or from Objective-C classes
// Enumeration cases are renamed with the name of the enumeration as a prefix, e.g. 'enum Planet case venus' becomes 'case PlanetVenus'
import Foundation
class ExampleClass: NSObject {
	// You can pass an argument to the attribute to make the declaration available in Objective-C with a different name, example:
	// the 'enabled' getter is renamed as 'isEnabled' in Objective-c
	@objc(isEnabled) var enabled: Bool {
		return true
    }
}

// 'objcMembers' and 'nonobjc'
// Apply @objcMembers to a class to make all its members available in Objective-C
// And use @nonobjc to exclude individual members
// 	- methods marked as 'objc' in a superclass or protocol cannot be implemented as 'nonobjc',
//  - but methods originally defined as 'nonobjc' can be implemented as 'objc'
@objcMembers
class ExampleClass2: NSObject {
	var name: String = ""				// implicitely @objc
	var age: Int = 0					// implicitely @objc
	@nonobjc var district: String = ""	// explicitely @nonobjc
}

// @nonobjc can also be used on an extension to prevent its members to be implicitely added as @objc
@nonobjc extension ExampleClass2 {
	var country: String { return "" }	// implicitely @nonobjc
	@objc var size: Int { return 0 }	// explicitely @objc
}

// 'NSApplicationMain' (???)
// Apply this attribute to a class to indicate that it is the application delegate
// Using this attribute is equivalent to calling the NSApplicationMain(_:_:) function

// 'NSCopying' (???)
// This attribute can only be applied to stored variable properties of a class
// it makes the property’s setter to be synthesized with a copy of the property’s value, instead of the value itself
// The type of the property must conform to the NSCopying protocol

// 'NSManaged' (???)
// Applies to instance methods, or stored variable property of classes that inherit from 'NSManagedObject'
// This attribute indicates that Core Data dynamically provides its implementation at runtime

// 'requires_stored_property_inits' (???)
// Apply this attribute to a class declaration to require all stored properties within the class to provide default values as part of their definitions. This attribute is inferred for any class that inherits from NSManagedObject

// 'testable'
// This attribute can be applied to 'import' declarations to load modules compiled with testing enabled
// it makes all 'internal' entities available as if they had been marked as 'public'
// it also makes all 'internal' and 'public' classes and class members available as if they had been marked as 'open'

// 'UIApplicationMain' (???)
// Apply this attribute to a class to indicate that it is the application delegate
// Using this attribute is equivalent to calling the UIApplicationMain function

// 'warn_unqualified_access' (???)
// Apply this attribute to a top-level function, instance method, or class or static method to trigger warnings when that function or method is used without a preceding qualifier, such as a module name, type name, or instance variable or constant


// DECLARATION ATTRIBUTES USED BY INTERFACE BUILDER (???)
// These attributes can be used on any declaration used by 'Interface Builder'
// IBAction
// IBOutlet
// IBDesignable
// IBInspectable


// TYPE ATTRIBUTES
// These attributes can only be used on types

// 'autoclosure'
// Explained on the 'Closures' chapter

// 'convention' (???)
// Apply this attribute to the type of a function to indicate its calling conventions, the attribute takes one value, which can be:
//  - swift:    standard calling convention for functions in Swift
//  - block:    indicates that the function is an Objective-C compatible block reference
//  - c:        indicates that the function should use the C calling convention

// 'escaping'
// Explained on the 'Closures' chapter
