import Inspirax from "../../../contracts/Inspirax.cdc"

// This script returns an array of the play IDs that are
// in the specified set

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read

// Returns: [UInt32]
// Array of play IDs in specified set

pub fun main(setID: UInt32): [UInt32] {

    let plays = Inspirax.getPlaysInSet(setID: setID)!

    return plays
}