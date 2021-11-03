import SoundlinksDNA from "../../contracts/SoundlinksDNA.cdc"

pub fun main(address: Address): UInt32 {

    let account = getAccount(address)

    let collectionRef = account.getCapability(SoundlinksDNA.CollectionPublicPath)!
        .borrow<&SoundlinksDNA.Collection{SoundlinksDNA.SoundlinksDNACollectionPublic}>()
        ?? panic("Could not borrow the reference to the Collection")

    return UInt32(collectionRef.getIDs().length)
}