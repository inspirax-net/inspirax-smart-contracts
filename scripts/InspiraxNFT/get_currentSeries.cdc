import Inspirax from "./contracts/Inspirax.cdc"

// This script reads the current series from the Inspirax contract and
// returns that number to the caller

// Returns: UInt32
// currentSeries field in Inspirax contract

pub fun main(): UInt32 {

    return Inspirax.currentSeries
}