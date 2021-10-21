import NonFungibleToken from "./contracts/NonFungibleToken.cdc"
import Inspirax from "./contracts/Inspirax.cdc"
import InspiraxShardedCollection from "./contracts/InspiraxShardedCollection.cdc"

// This transaction deposits an NFT to a recipient

// Parameters
//
// recipient: the Flow address who will receive the NFT
// momentID: moment ID of NFT that recipient will receive

transaction(recipient: Address, momentID: UInt64) {

    let transferToken: @NonFungibleToken.NFT

    prepare(acct: AuthAccount) {

        self.transferToken <- acct.borrow<&InspiraxShardedCollection.ShardedCollection>(from: InspiraxShardedCollection.ShardedCollectionStoragePath)!.withdraw(withdrawID: momentID)
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