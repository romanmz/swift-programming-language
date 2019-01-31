


// SUBSCRIPTS
// ==================================================

// Subscripts are shortcuts for accessing particular values from a class, struct or enum instance
// This is the same concept to how you can access an array or dict by a key: myArray[0]  myDict["AU"]
// You can define your own subscript methods on your own custom types

// SYNTAX
struct Matrix {
    let rows: Int
    let columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    // Use the 'subscript' keyword
    // It needs to have one or more arguments and a return value
    // You can make it read-write or read-only the same way as with computed properties
    subscript(row: Int, column: Int) -> Double {
        
        // The getter needs to return a value matching the return type of the subscript
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        
        // The 'newValue' argument of the setter will be the same type as the return type of the subscript
        set(newValue) {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
matrix[1, 0]
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
matrix[1, 0]

// trying to access an item out of its defined range will trigger an error
// matrix[2, 2]
