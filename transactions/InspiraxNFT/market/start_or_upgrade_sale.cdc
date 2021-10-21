import InspiraxMarket from "./contracts/InspiraxMarket.cdc"

// This transaction is for a user to put a new moment up for sale
// They must have Inspirax Collection and a InspiraxMarket Sale Collection already
// stored in their account

// Parameters
//
// momentId: the ID of the moment to be listed for sale
// price: the sell price of the moment

transaction(momentID: UInt64, price: UFix64) {

    prepare(acct: AuthAccount) {

        // Borrow a reference to the Inspirax Sale Collection
        let inspiraxSaleCollection = acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        // List the specified moment for sale
        inspiraxSaleCollection.listForSale(tokenID: momentID, price: price)
    }
}