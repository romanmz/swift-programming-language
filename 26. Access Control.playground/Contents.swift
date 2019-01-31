

// ACCESS CONTROL
// ==================================================

// Access control restricts access to parts of your code from code in other source files and modules
/*
 
 You can assign specific access levels to
 - whole types (classes, structures, and enumerations), or individual:
    - properties
    - methods
    - initializers
    - subscripts
 
 You can restrict based on context:
 - Protocols
 - global constants, variables, and functions
 
 Swift also allows you to specify default access levels for typical scenarios
 
 
 'Module': single unit of code distribution (e.g. frameworks). Can be imported with the 'import' keyword
    Each build target is a module, if you group portions of the code to create a reusable framework, that framework becomes a separate module
 'Source file': An individual source file that is part of a module
 
 
 Access leves are relative to:
    - the source file in which an entity is defined
    - the module the source file belongs to
 
 Access levels:
    1. Open access: Available everywhere, can be modified by other modules (available only on classes)
        - open classes can be subclassed everywhere, including other modules
        - open class members can be overriden by subclasses everywhere, including other modules
    1. Public access: Available everywhere (not editable by other modules)
        - public classes can be subclassed anywhere within its module, but not outside of it
        - public class members can be overriden by subclasses within its module, but not outside of it
    2. Internal access: Available only within the same module
    3. File-private access: Available only within the same source file
    4. Private access: Available only within the enclosing declaration (or in extensions of the same class if they are in the same file)
 
 - public variables can't use types with more restrictive access than the variable itself
 - functions can't have parameters and return values with more restrictive access than the function itself
 - types can't have properties and methods less restrictive than the type itself (doing so won't throw errors, but the type won't be made available in those less restrictive contexts anyway)
 
 - All entities (with only a few exceptions) will have a default 'internal' access
 - If you're developing a framework, you'll need to manually mark the API entities as public
 - Unit test targets will only have access to public entities, but if you want other more restrictive entities to be available as well, mark them with the '@testable' attribute
 
 To set the access level of an entity, mark them with one of these keywords:
 - 'open'
 - 'public'
 - 'internal' (most entitiess default to this one, so it's not necessary to explicitely declare it)
 - 'fileprivate'
 - 'private'
 
 If you mark a type as 'private' or 'fileprivate', its internal properties and methods will get the same access level by default
 if you mark it as 'public' or 'internal', the internal properties and methods will keep the default access of 'internal'
 
 TUPLES:
 - The access level of a tuple can't be explicitely defined, it will always be automatically set to the most restrictive access level of the types it contains
 
 FUNCTIONS:
 - Access level is automatically set to be the most restrictive access level of the types it uses as parameters and return values
 - If the automatically calculated access level doesn't match the default access level of the context the function is in, you'll need to explicitely set the access level of the function (and it needs to be at least as restrictive as the automatically calculated level)
 
 ENUMS:
 - All cases of an enum will always inherit the same access level as the enum itself, you can never give them different access levels
 - The types an enum uses for its raw or associated values can't be more restrictive than the enum itself
 
 SUBCLASSES:
 - You can subclass any classes available on the current context
 - the subclass can only have an access level equally or more restrictive than the original class
 - the subclass can override any properties and methods of the superclass it has access to, and change their access level
 - the new access level of the class members can't be less restrictive than the subclass itself, but IT CAN be less restrictive than what they originaly had
 - class members of a subclass are also allowed to access members of the superclass that are more restrictive than themselves (e.g. an internal subclass method can still call a fileprivate superclass method, as long as the context of the subclass meets the requirement of the superclass member, in this case being on the same file)
 
 VARIABLES, CONSTANTS, PROPERTIES AND SUBSCRIPTS
 - They should always be at least as restrictive as the value types they use
 - Getter and setters can have different access level, but it needs to be at least as restrictive as the variable/subscript itself
 - You can also give setters a different access level than getters, and it needs to be more restrictive
    - to do this add an additional keyword with a '(get)' suffix,
        e.g. 'internal private(set) var name: String'
        e.g. 'private(set) var name: String'  // this example leaves the access level of the getter as the default access level depending on the context
    - you can do this on both stored and computed properties, even if you don't actually create setters for stored properties
 
 INITIALIZERS
 - Custom initializers can have any access level as long as it is at least as restrictive as the type they belong to
    - Except for required initializers, those always need to have the same access level as its class
    - The rest of the rules for functions and methods also apply to custom initializers
 - Default initializers get the same access level as its containing type by default
    - Except when the access level of the type is 'public', in that case the initializer defaults to 'internal'
    - If you want it to become public you'll need to explicitely declare it
    - You can change the access level of the default initializer to have any access level (but less restrictive access levels than the type would be pointless)
 - Memberwise initializers have the same access level as the most restrictive stored property the struct contains
    - except when all properties are public, in which case the memberwise initializer will still be internal by default
    - in that case if you want to make it public you'll need to do it explicitely
    - other than that, you can change its access level but only to make it even more restrictive than its default, it can never be less restrictive than it's more restrictive property
 
 PROTOCOLS
 - The access level of each requirement within a protocol is automatically set to the same access level as the protocol
 - this includes making all requirements public when the protocol itself is public (unlike other types where they still need to be marked public manually)
 - The access level of the requirements cannot be changed, they always match the protocol
 - A protocol that inherits from another protocol can have a different access level, but only if it is equally or more restrictive
 - A type can conform to any protocol, regardless if the access control of the protocol is more or less restrictive
 - When a type conforms to a protocol, the properties and methods need to be as restrictive as the protocol, or more permissive (never more restrictive)
 
 EXTENSIONS
 - You can extend a class, structure, or enumeration in any access context in which they are available
 - Any type members added will get a default access level following the standard rules (same as parent type, except when type is public in which case it defaults to internal)
 - or you can define a new default access level for the extension by prepending the access level keyword before the extension ('private extension...')
 - in any case, you can always override the access level of individual type members manually
 
 - When using an extension to add protocol conformance, you cannot define any access level on the extension, the access level requirements will be defined by the protocol itself
 
 GENERICS
 - If a generic type or function implements type constraints, the access level of the generic can only be equally or more restrictive than the classes and protocols it references on the type constraints
 
 TYPE ALIASES
 - A type alias can have a different access level than the type it aliases, as long as it is equally or more restrictive
 
 
 (if you use 'private' in a global context, it will behave as 'fileprivate' instead)
 
 */
