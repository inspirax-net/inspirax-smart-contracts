import Inspirax from "../../../contracts/Inspirax.cdc"

// This script reads the next Set ID from the Inspirax contract and
// returns that number to the caller

// Returns: UInt32
// Value of nextSetID field in Inspirax contract

pub fun main(): UInt32 {

    log(Inspirax.nextSetID)

    return Inspirax.nextSetID
}