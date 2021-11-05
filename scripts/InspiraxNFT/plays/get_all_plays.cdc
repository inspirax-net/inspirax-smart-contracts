import Inspirax from "../../../contracts/Inspirax.cdc"

// This script returns an array of all the plays
// that have ever been created for Inspirax

// Returns: [Inspirax.Play]
// array of all plays created for Inspirax

pub fun main(): [Inspirax.Play] {

    return Inspirax.getAllPlays()
}