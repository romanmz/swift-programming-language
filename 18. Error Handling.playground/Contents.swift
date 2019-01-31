

// OPTIONAL CHAINING
// ==================================================

// Errors are represented by values of types that conform to the Error protocol
// Enumerations are well suited to represent a group of possible error conditions

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

/*
 
 There's 4 ways to handle errors:
 1. Propagate
 2. Handle with do-catch
 3. Handle with optional
 4. Assert
 
 Error handlers:
 try
 try?
 try!
 do-catch
 assert
 
 */

// To indicate that a function or method can throw errors, add the 'throws' keyword right before the return type of the function
// These are called 'throwing functions', and they propagate the errors generated inside them up to the scope where the function was called
// Non-throwing functions must handle their errors internally

struct Item {
    var price: Int
    var count: Int
}
class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11),
    ]
    var coinsDeposited = 0
    
    func vend(itemNamed name: String) throws {
        
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}

// In this example the VendingMachine.vend(name:) method is a throwing function
// So any code that calls this method must be able to handle its possible errors

// When calling a throwable function or method, you always need to prepend the 'try' keyword


// 1. PROPAGATE
// ------------------------------

// The first option is to further propagate the error
// In this example the 'buyFavoriteSnack' function is marked as 'throwable', and the 'vend' method is called with just the 'try' keyword and no other way of handling possible errors
// The result is that if 'vend' fails, then 'buyFavoriteSnack' also fails and propagates the error another level up
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws -> Bool {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
    return true
}

var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
// ERROR: Calling the function now will throw an 'insufficientFunds' error
// try buyFavoriteSnack(person: "Alice", vendingMachine: myVending)

// You can also mark init methods to be throwable functions, and you can make them propagate the errors to its caller


// 2. USING DO-CATCH
// ------------------------------

// You can test the function inside a 'do' statement, and add 'catch' statements to handle any possible errors:
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    // statements following the throwable function are only executed if there's no errors
} catch {
    // on the catch statement there will be an 'error' variable available with the error details
    error
}

// Or you can add multiple 'catch' statements to test for different types of errors
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
} catch VendingMachineError.invalidSelection {
    "Invalid Selection."
} catch VendingMachineError.outOfStock {
    "Out of Stock."
} catch let VendingMachineError.insufficientFunds(coinsNeeded) {
    "Insert an additional \(coinsNeeded) coins."
}

// You can mix specific cases with a generic catch-all statement
// Or you can also have only some cases, you don't necessarily need to catch all cases,
// however in that case the error will propagate to the surrounding scope, so this can only happen inside an enclosing do-catch, or inside a throwable function

func testDoCatch1() {
    /*
    INVALID CODE:
    do {
        try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    } catch VendingMachineError.invalidSelection {
        "Invalid Selection."
    }
    */
}
func testDoCatch2() {
    do {
        do {
            try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
        } catch VendingMachineError.invalidSelection {
            "Invalid Selection."
        }
    } catch {
        error
    }
}
func testDoCatch3() throws {
    do {
        try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    } catch VendingMachineError.invalidSelection {
        "Invalid Selection."
    }
}


// 3. CONVERT ERRORS INTO OPTIONALS
// ------------------------------

// If you use 'try?' the function will return an optional with nil if there was an error, or the normal result of the function
var soldSnack = try? buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
vendingMachine.coinsDeposited = 100
soldSnack = try? buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)

// You can use optional unwrapping to immediately test for error or success
if let couldSell = try? buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine) {
    couldSell
    "success: \"couldSell\" variable is ready to use"
} else {
    "error"
}


// 4. DISABLE ERROR PROPAGATION
// ------------------------------

// You can use try! to disable error propagation when calling a throwable function
// but you need to be 100% certain the function won't throw an error when using this, otherwise you'll get a runtime error

// OK:
var couldSell = try! buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)

// ERROR:
vendingMachine.coinsDeposited = 0
// couldSell = try! buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)


// CLEANUP ACTIONS WITH 'DEFER'
// ------------------------------

// Statements inside a 'defer' clause are always executed by the end of the current context
// regardless of how that context ended (with throw, return, break, etc…)
// 'defer' clasuses are executed in reverse order of how they were defined (earlier defers are executed last)
func exists(filename: String) -> Bool {
    return true
}
func open(filename: String) -> String {
    return "file contents"
}
func close(filename: String) -> Bool {
    print("-- closed --")
    return true
}
func processFile(filename: String) {
    if exists(filename: filename) {
        let file = open(filename: filename)
        defer {
            close(filename: file)
        }
        for char in file {
            print(char)
            // Work with the file.
        }
        // close(file) is called here, at the end of the scope.
    }
}
processFile(filename: "test.txt")
