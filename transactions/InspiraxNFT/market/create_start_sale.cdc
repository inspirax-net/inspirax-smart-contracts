import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"
import Inspirax from "./contracts/Inspirax.cdc"
import InspiraxMarket from "./contracts/InspiraxMarket.cdc"

transaction(momentID: UInt64, price: UFix64) {

    prepare(acct: AuthAccount) {

        // Check to see if a sale collection already exists
        if acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath) == nil {

            // Get the fungible token capabilities for the owner and beneficiary
            let ownerCapability = acct.getCapability<&{FungibleToken.Receiver}>(InspiraxUtilityCoin.ReceiverPublicPath)

            let ownerCollection = acct.link<&Inspirax.Collection>(/private/InspiraxMomentCollection, target: Inspirax.CollectionStoragePath)!

            // Create a new sale collection
            let inspiraxSaleCollection <- InspiraxMarket.createSaleCollection(ownerCollection: ownerCollection,
                                                                              ownerCapability: ownerCapability)

            // Save it to storage
            acct.save(<-inspiraxSaleCollection, to: InspiraxMarket.marketStoragePath)

            // Create a public link to the sale collection
            acct.link<&InspiraxMarket.SaleCollection{InspiraxMarket.SalePublic}>(InspiraxMarket.marketPublicPath, target: InspiraxMarket.marketStoragePath)
        }

        // Borrow a reference to the sale
        let refSaleCollection = acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        // Put the moment up for sale
        refSaleCollection.listForSale(tokenID: momentID, price: price)
    }
}