import InspiraxMarket from "./contracts/InspiraxMarket.cdc"

// This transaction is for a user to stop a moment sale in their account

// Parameters
//
// tokenID: the ID of the moment whose sale is to be delisted

transaction(tokenID: UInt64) {

    prepare(acct: AuthAccount) {

        // borrow a reference to the owner's sale collection
        let inspiraxSaleCollection = acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        // cancel the moment from the sale
        inspiraxSaleCollection.cancelSale(tokenID: tokenID)
    }
}