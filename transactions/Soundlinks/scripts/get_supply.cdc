import Soundlinks from "./contracts/Soundlinks.cdc"

pub fun main(): UInt64 {

    let supply = Soundlinks.totalSupply

    log(supply)

    return supply
}