import Inspirax from "../../../contracts/Inspirax.cdc"

// This script returns all the metadata about the specified set

// Parameters:
//
// setID: The unique ID for the set whose data needs to be read

// Returns: Inspirax.QuerySetData

pub fun main(setID: UInt32): Inspirax.QuerySetData {

    let data = Inspirax.getSetData(setID: setID)
        ?? panic("Could not get data for the specified set ID")

    return data
}