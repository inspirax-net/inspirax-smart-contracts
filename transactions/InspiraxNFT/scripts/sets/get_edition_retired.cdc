import Inspirax from "./contracts/Inspirax.cdc"

// This transaction reads if a specified edition is retired

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read
// playID: The unique ID for the play whose data needs to be read

// Returns: Bool
// Whether specified set is retired

pub fun main(setID: UInt32, playID: UInt32): Bool {

    let isRetired = Inspirax.isEditionRetired(setID: setID, playID: playID)
        ?? panic("Could not find the specified edition")
    
    return isRetired
}