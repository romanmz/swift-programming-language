


// AUTOMATIC REFERENCE COUNTING
// ==================================================

// Swift uses Automatic Reference Counting (ARC) to track and manage your app’s memory usage.
// So in most cases you don't need to worry about memory management

// It works by keeping track of how many variables, constants and properties are referencing that instance
// and it keeps the instance alive until all references to it are broken (otherwise if it's deallocated earlier and another property still tries to access it, the app will break)
// and once it detects that all references have been broken, then it automatically deinitializes and deallocates the instance to free up space

class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

// These three vars do not currently reference any 'Person' instances
// So reference counting is 0 (hasn't started yet)
var reference1: Person?
var reference2: Person?
var reference3: Person?

// All three variables now reference the same instance
// So the reference counting for that instance is currently '3'
reference1 = Person(name: "John")
reference2 = reference1
reference3 = reference1

// These references are 'strong references' by default
// This means that they won't allow that instance to be deallocated as long as they are still referencing it

// Now two strong references have been broken, but one still remains
reference1 = nil
reference2 = nil

// Now the instance has no remaining strong references, so it is automatically deinitialized
reference3 = nil



// However in some cases ARC needs additional information in order to manage the memory of all the app:


// STRONG REFERENCE CYCLES
// ------------------------------
// This happens for example when two class instances keep a reference to each other, making it impossible for ARC to detect when it's safe to deallocate them
/*
class Person2 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person2?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

// Init empty variables, no references yet
var john: Person2?
var unit4A: Apartment?

// each instance now has 1 strong reference each, all ok so far:
john = Person2(name: "Malcom")
unit4A = Apartment(unit: "4A")

// But now each instance is referencing each other, so the reference count is now 2 for each instance
john!.apartment = unit4A
unit4A!.tenant = john

// And even if you clear both variables, deallocation never happens because reference counting only dropped to 1 for each, not 0:
john = nil
unit4A = nil

// This is causing a memory leak
*/


// SOLUTION: WEAK REFERENCES
// -----
// Use the 'weak' keyword to create weak references instead of strong references
// This tells ARC that if the main instance is deleted, then it is also safe to remove it from the weak reference on the other object by changing its value to 'nil'
// which will allow the main instance to be properly deinitialized and deallocated

// This is used when the lifespan of the instance used as weak reference can be shorter than the other instance
// (so the other instance can keep functioning, with just an empty property where the instance of the weak reference used to be)

// For this you need to add the 'weak' keyword before the property declaration,
// and since it can potentially have its value changed to nil at any point, then it needs to be a variable with an optional type
class Person3 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment3?
    deinit { print("\(name) is being deinitialized") }
}
class Apartment3 {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person3?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var alex: Person3? = Person3(name: "Alex")
var unit12: Apartment3? = Apartment3(unit: "12")
alex!.apartment = unit12
unit12!.tenant = alex

// In this example, the 'tenant' property of Apartment3 is a weak reference
// So if the person is deleted first, the 'tenant' property is also deleted and changed to 'nil'
// Which brings the reference count of the person instance down to 0, triggering deallocation
// This also removes the reference to the Apartment3 instance that was kept on the person instance
// Which brings down the reference count for the unit var down to 0, also allowing it to be properly deinitialized and deallocated
let deallocatePersonFirst = true
if deallocatePersonFirst {
    alex = nil
    alex?.apartment
    unit12?.tenant
    unit12 = nil
} else {
    
    // If the Apartment3 instance is deleted first, it won't trigger any deallocation straight away
    // because the Person3 instance is still keeping a strong reference to it
    unit12 = nil
    alex?.apartment?.unit
    
    // But the weak reference to Person was still broken, so the reference count of 'alex' is down to 1
    // Which means that if you delete it, it will be properly deallocated
    // And since that will break the last remaining reference to the Apartment3 object, then it will also trigger deallocation for 'unit12'
    unit12?.tenant
    alex = nil
}

// NOTE: Property observers aren't triggered when ARC changes a weak reference to 'nil'


// SOLUTION: UNOWNED REFERENCES
// -----

// Similar to weak references except that in this case the instance is expected to have the same or longer lifespan than the instance that is storing a reference to it
// Because of this, unowned references are expected to always have a value, so you need to define them with a non-optional type, which can be variable or constant
// You'll also need to guarantee that everytime you try to act on an unowned reference, the main instance will not have been deallocated yet


// To define a property as an unowned reference, use the 'unowned' keyword before the property declaration

class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}
class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
// In this example for a customer it is optional to have a card or not
// But cards will always belong to a customer, so the lifespan of any customer instances will always be longer
// Which is why the 'customer' property of the Card instance is defined as an unowned constant

var robert: Customer?
robert = Customer(name: "Robert")
robert!.card = CreditCard(number: 1234_5678_9012_3456, customer: robert!)
// After this, the Customer instance has a reference count of 2 (the main instance and the 'customer' property of the Card instance)
// and the Card instance has a reference count of 1 (only the 'card' property of the Customer instance)

// If you delete the main customer instance, normally its reference count would go down to just 1
// but since the reference to it on the Card instance was defined as 'unowned', then it is also automatically deleted from there
// bringing the reference count to 0 and allowing it to be deallocated
// Also, since the only reference to the Card instance was stored against the Customer instance, which now doesn't exist anymore
// Then the reference count for the Card instance also goes down to 0, which makes it be deallocated as well
robert = nil


// SOLUTION: UNOWNED REFERENCES + IMPLICITELY UNWRAPPED OPTIONALS
// -----

// There is a third scenario in which both instances need to always keep a reference to the other in a non-optional way
// To avoid a strong reference cycle in this scenario, you can use an unowned reference in one class, and an implicitely unwrapped optional on the other
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
    deinit {
        print("\( name ) has been deinitialized")
    }
}
class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    deinit {
        print("\( name ) has been deinitialized")
    }
}
var country: Country? = Country(name: "Canada", capitalName: "Ottawa")
if country != nil {
    "\(country!.name)'s capital city is called \(country!.capitalCity.name)"
}
country = nil

// In this example a country will always have a capital, and a city will always have a country
// To prevent a strong reference cycle, the City class defines its 'country' property as an 'unowned' constant

// The problem is that in these classes having a reference to each other is not optional but a requirement
// But then you wouldn't be able to create a Country if the capital City doesn't exist yet, and vice-versa
// To work around this the Country class allows you to create the City instance on the fly during initialization
// But the problem now is that, as we saw on the "Two-phase Initialization" section, you can't use the 'self' property
// until after the instance has been fully initialized, but the Country class can't be fully initialized until it stores a value against its 'capitalCity' property

// So to work around this, the capitalCity property is defined as an implicitely unwrapped optional
// this makes it get a default value of nil, and phase 1 of initialization ends as soon as the 'name' property is set
// This allows it to call the initializer for 'City' and pass 'self' as a variable
// After this 'capitalCity' is set as the newly created city, ensuring that it always gets a proper value after initialization ends
// And since it was set as an implicitely unwrapped optional (as opposed to a regular optional), then you'll be able to read it without having to unwrap it every time



// STRONG REFERENCE CYCLES FOR CLOSURES
// ------------------------------

// Strong reference cycles can also occur when the instance of a class stores a closure, and that closure 'captures' the instance by referencing a property or method of the same instance
// Closures, just like classes, are 'reference types', so when they are assigned to a property they are not copied but referenced
// Which is basically the same reason strong reference cycles happen between class instances

class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

// In this example the 'asHTML' property has been assigned a closure
// This closure property would do the same job if it was an instance method, except that we want to be able to change the functionality in individual instances if required:

let heading = HTMLElement(name: "h1")
heading.asHTML()
heading.asHTML = {
    let defaultText = "some default text"
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
heading.asHTML()

// The closure makes use of the 'self' keyword to refer to the instance it belongs to
// This will cause an initialization error since that keyword is not available until after initialization has finished
// To avoid this error, the property is marked as a 'lazy' property, so the contents of the closure won't run until the property is manually called
// Which can only happen after the instance has actually finished initializing


var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
paragraph!.asHTML()
paragraph!.asHTML
paragraph = nil

// Since the HTMLElement class keeps a strong reference to a closure (asHTML), and the closure keeps a strong reference back to the instance (self)
// then strong reference cycle is created. (the closure only keeps one strong reference to the instance, even if the keyword is used multiple times)
// note that the paragraph variable above didn't trigger the deinitializer method after being deleted


// SOLUTION: CAPTURE LISTS
// -----

// A capture list is a list that instructs a closure what references need to be made weak or unowned instead of strong
// Items in a capture list begin with the 'weak' or 'unowned' keyword, followed by either a reference to an instance, or a variable initialized based on an instance

// These pairings need to be written inside square brackets at the beginning of the closure, before the parameters, return type and 'in' keyword
// e.g: [unowned self, weak delegate = self.delegate]

// Use 'unowned' when the closure and the instance will always refer to each other, and need to be deallocated at the same time
// Use 'weak' when the closure doesn't require the instance to always have a set value to work properly (this will make it an optional type)



// In the previous HTML example, the closure always requires 'self' to have a set value, so we break the strong reference cycle by making it an 'unowned' property:
class HTMLElement2 {
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("<\(name)> is being deinitialized")
    }
}
var paragraph2: HTMLElement2? = HTMLElement2(name: "p", text: "hello, world")
paragraph2!.asHTML()
paragraph2!.asHTML
paragraph2 = nil
