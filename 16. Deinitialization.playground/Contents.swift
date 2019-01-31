

// DEINITIALIZATION
// ==================================================

// A deinitializer is called immediately before a class instance is deallocated
// They are available only on class types

// SYNTAX
// Use the 'deinit' keyword to define the deinitialization methods
// There can only be one per class, and you don't need to write parentheses as they don't take any arguments

// You can't call a deinitializer method manually
// Subclasses inherit the deinitializers of their superclass
// Subclasses can also define their own
// The deinitializers of the subclass are triggered first and then the one from the superclass

// In this example, the 'Bank' class gets back the coins each player had after they leave

class Bank {
    static var coinsInBank = 10_000
    static func distribute(coins numberOfCoinsRequested: Int) -> Int {
        let numberOfCoinsToVend = min(numberOfCoinsRequested, coinsInBank)
        coinsInBank -= numberOfCoinsToVend
        return numberOfCoinsToVend
    }
    static func receive(coins: Int) {
        coinsInBank += coins
    }
}
class Player {
    var coinsInPurse: Int
    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }
    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }
    deinit {
        Bank.receive(coins: coinsInPurse)
    }
}

var playerOne: Player? = Player(coins: 100)
playerOne!.coinsInPurse
Bank.coinsInBank

playerOne!.win(coins: 2_000)
playerOne!.coinsInPurse
Bank.coinsInBank

playerOne = nil
Bank.coinsInBank
