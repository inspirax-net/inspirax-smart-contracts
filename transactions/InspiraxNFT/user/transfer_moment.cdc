import NonFungibleToken from "./contracts/NonFungibleToken.cdc"
import Inspirax from "./contracts/Inspirax.cdc"
import InspiraxMarket from "./contracts/InspiraxMarket.cdc"

// This transaction transfers a moment to a recipient
// and cancels the sale in the collection if it exists

// Parameters:
//
// recipient: The Flow address of the account to receive the moment.
// withdrawID: The id of the moment to be transferred

transaction(recipient: Address, withdrawID: UInt64) {

    // Local variable for storing the transferred token
    let transferToken: @NonFungibleToken.NFT

    prepare(acct: AuthAccount) {

        // Borrow a reference to the owner's collection
        let collectionRef = acct.borrow<&Inspirax.Collection>(from: Inspirax.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the stored Moment collection")

        // Withdraw the NFT
        self.transferToken <- collectionRef.withdraw(withdrawID: withdrawID)

        if let saleRef = acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath) {
            if let price = saleRef.getPrice(tokenID: withdrawID) {
                saleRef.cancelSale(tokenID: withdrawID)
            }
        }
    }

    execute {

        // Get the recipient's public account object
        let recipient = getAccount(recipient)

        // Get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(Inspirax.CollectionPublicPath).borrow<&{Inspirax.MomentCollectionPublic}>()!

        // Deposit the NFT in the receivers collection
        receiverRef.deposit(token: <-self.transferToken)
    }
}