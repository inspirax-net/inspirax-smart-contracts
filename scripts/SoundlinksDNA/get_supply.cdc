import SoundlinksDNA from "../../contracts/SoundlinksDNA.cdc"

pub fun main(): UInt64 {

    let supply = SoundlinksDNA.totalSupply

    log(supply)

    return supply
}