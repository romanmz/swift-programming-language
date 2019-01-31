//: Playground - noun: a place where people can play

import UIKit

// Understanding conflicting access to memory
// -----

// In Swift, there are ways to modify a value that span several lines of code, making it possible to attempt to access a value in the middle of its own modification.

// If you have conflicting access to memory from within a single thread, Swift guarantees that you’ll get an error at either compile time or runtime
// For multithreaded code, use Thread Sanitizer[https://developer.apple.com/documentation/code_diagnostics/thread_sanitizer] to help detect conflicting access across threads


// There are three characteristics of memory access:
// - whether the access is a read or a write
// - the duration of the access
//		- instantaneous: when it's not possible for other code to run until after the access ends (most cases)
//		- long-term: when other code can run after the access has started and before it has ended
// - the location in memory being accessed

// A conflict occurs when two accesses meet these three conditions:
// - At least one is a write access
// - they access the same location in memory
// - their durations overlap


// Conflicting Access to In-out Parameters
// ------------------------------

// When you pass an in-out parameter, Swift begins a 'write' access on it as soon as the function starts, and it remains open until the function ends
// Same thing happens with operators, as they are also functions

// You can't access the original variables that were passed as in-outs:
// (this should be throwing an error but it's not doing it here lol)
var stepSize = 1
func increment(_ number: inout Int) {
	number += stepSize
}
increment(&stepSize)
increment(&stepSize)
increment(&stepSize)

// One way to solve this is to make a copy of the variable, pass it as the in-out parameter, and then update the original variable with the result of the operation


// Another issue is when you pass the same variable as multiple in-out parameters because the function tries to perform to 'write' accesses to the same location in memory at the same time
func balance(_ x: inout Int, _ y: inout Int) {
	let sum = x + y
	x = sum / 2
	y = sum - x
}
var playerOneScore = 42
var playerTwoScore = 30
// OK:
balance(&playerOneScore, &playerTwoScore)
// Error: Conflicting accesses to playerOneScore
// balance(&playerOneScore, &playerOneScore)


// 'self' in mutating methods of a struct
// ------------------------------

// When calling a mutating method of a struct, the method begins a write access to the whole struct ('self'), so the same possibility for conflict arises as with in-out parameters

struct Player {
	var name: String
	var health: Int
	var energy: Int
	static let maxHealth = 10
	
	mutating func restoreHealth() {
		health = Player.maxHealth
	}
	mutating func shareHealth(with teammate: inout Player) {
		balance(&teammate.health, &self.health)
	}
}
var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
// OK:
oscar.shareHealth(with: &maria)
// Error:
// oscar.shareHealth(with: &oscar)


// Conflicting access to properties
// ------------------------------

// Structures, tuples and enumerations are value types, which means that when an individual property in them is changed, Swift begins a write access to the instance as a whole

// This can cause conflicts when trying to alter the values of two or more properties at the same time, since an individual write access is opened for each property

var playerInformation = (health: 10, energy: 20)
// ERROR:
balance(&playerInformation.health, &playerInformation.energy)
playerInformation


// Memory safety vs exclusive access to memory
// ------------------------------

// Achieving 'exclusive access to memory' means preventing all conflicts of memory access
// but achieving 'memory safety' can be a bit less strict if the compiler can guarantee that the simultaneous accesses don't cause conflicts with each other

// this happens if:
// - you're accessing only stored properties of a structure (no computed/class properties)
// - the struct is the value of a local variable (not global)
// - the struct is not captured by any escaping closures
