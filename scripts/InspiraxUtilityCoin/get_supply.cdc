import InspiraxUtilityCoin from "../../contracts/InspiraxUtilityCoin.cdc"

pub fun main(): UFix64 {

    let supply = InspiraxUtilityCoin.totalSupply

    log(supply)

    return supply
}