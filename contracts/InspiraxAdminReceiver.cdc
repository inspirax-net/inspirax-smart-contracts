/**
    Description: Central Smart Contract for Inspirax Admin Receiver
    This contract defines a function that takes a Inspirax Admin
    object and stores it in the storage of the contract account
    so it can be used.
**/

import Inspirax from "./Inspirax.cdc"
import InspiraxShardedCollection from "./InspiraxShardedCollection"

pub contract InspiraxAdminReceiver {

    /// storeAdmin takes a Inspirax Admin resource and 
    /// saves it to the account storage of the account
    /// where the contract is deployed
    pub fun storeAdmin(newAdmin: @Inspirax.Admin) {
        self.account.save(<-newAdmin, to: Inspirax.AdminStoragePath)
    }

    init() {
        // Save a copy of the sharded Moment Collection to the account storage
        if self.account.borrow<&InspiraxShardedCollection.ShardedCollection>(from: InspiraxShardedCollection.ShardedCollectionStoragePath) == nil {
            let collection <- InspiraxShardedCollection.createEmptyCollection(numBuckets: 32)
            // Put a new Collection in storage
            self.account.save(<-collection, to: InspiraxShardedCollection.ShardedCollectionStoragePath)

            self.account.link<&{Inspirax.MomentCollectionPublic}>(Inspirax.CollectionPublicPath, target: InspiraxShardedCollection.ShardedCollectionStoragePath)
        }
    }
}