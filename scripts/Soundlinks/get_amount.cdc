import Soundlinks from "./contracts/Soundlinks.cdc"

pub fun main(address: Address): UInt32 {

    let account = getAccount(address)

    let CollectionRef = account.getCapability(Soundlinks.CollectionPublicPath)!
        .borrow<&Soundlinks.Collection{Soundlinks.CollectionPublic}>()
        ?? panic("Could not borrow getAmount reference to the Collection")

    return CollectionRef.getAmount()
}