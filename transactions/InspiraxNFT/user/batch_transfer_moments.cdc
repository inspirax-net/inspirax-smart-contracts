import NonFungibleToken from "./contracts/NonFungibleToken.cdc"
import Inspirax from "./contracts/Inspirax.cdc"
import InspiraxMarket from "./contracts/InspiraxMarket.cdc"

// This transaction transfers a number of moments to a recipient

// Parameters
//
// recipientAddress: the Flow address who will receive the NFTs
// momentIDs: an array of moment IDs of NFTs that recipient will receive

transaction(recipient: Address, momentIDs: [UInt64]) {

    let transferTokens: @NonFungibleToken.Collection
    
    prepare(acct: AuthAccount) {

        self.transferTokens <- acct.borrow<&Inspirax.Collection>(from: Inspirax.CollectionStoragePath)!.batchWithdraw(ids: momentIDs)

        if let saleRef = acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath) {

            for withdrawID in momentIDs {

                if let price = saleRef.getPrice(tokenID: withdrawID) {
                    saleRef.cancelSale(tokenID: withdrawID)
                }
            }
        }
    }

    execute {

        // Get the recipient's public account object
        let recipient = getAccount(recipient)

        // Get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(Inspirax.CollectionPublicPath).borrow<&{Inspirax.MomentCollectionPublic}>()
            ?? panic("Could not borrow a reference to the recipients moment receiver")

        // Deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-self.transferTokens)
    }
}