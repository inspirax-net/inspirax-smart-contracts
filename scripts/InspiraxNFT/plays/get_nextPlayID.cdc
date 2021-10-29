import Inspirax from "./contracts/Inspirax.cdc"

// This script reads the public nextPlayID from the Inspirax contract and
// returns that number to the caller

// Returns: UInt32
// the nextPlayID field in Inspirax contract

pub fun main(): UInt32 {

    log(Inspirax.nextPlayID)

    return Inspirax.nextPlayID
}