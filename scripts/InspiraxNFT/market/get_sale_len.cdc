import InspiraxMarket from "./contracts/InspiraxMarket.cdc"

pub fun main(sellerAddress: Address): Int {

    let acct = getAccount(sellerAddress)
    let collectionRef = acct.getCapability(InspiraxMarket.marketPublicPath)
        .borrow<&{InspiraxMarket.SalePublic}>()
        ?? panic("Could not borrow capability from public collection")

    return collectionRef.getIDs().length
}