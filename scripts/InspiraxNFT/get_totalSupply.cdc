import Inspirax from "../../contracts/Inspirax.cdc"

// This script reads the current number of moments that have been minted
// from the Inspirax contract and returns that number to the caller

// Returns: UInt64
// Number of moments minted from Inspirax contract

pub fun main(): UInt64 {

    return Inspirax.totalSupply
}