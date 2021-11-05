import Inspirax from "../../../contracts/Inspirax.cdc"
import InspiraxShardedCollection from "../../../contracts/InspiraxShardedCollection.cdc"

// This transaction creates and stores an empty moment collection
// and creates a public capability for it.
// Moments are split into a number of buckets
// This makes storage more efficient and performant

// Parameters
//
// numBuckets: The number of buckets to split Moments into

transaction(numBuckets: UInt64) {

    prepare(acct: AuthAccount) {

        if acct.borrow<&InspiraxShardedCollection.ShardedCollection>(from: InspiraxShardedCollection.ShardedCollectionStoragePath) == nil {

            let collection <- InspiraxShardedCollection.createEmptyCollection(numBuckets: numBuckets)

            // Put a new Collection in storage
            acct.save(<-collection, to: InspiraxShardedCollection.ShardedCollectionStoragePath)

            // Create a public capability for the collection
            if acct.link<&{Inspirax.MomentCollectionPublic}>(Inspirax.CollectionPublicPath, target: InspiraxShardedCollection.ShardedCollectionStoragePath) == nil {
                acct.unlink(Inspirax.CollectionPublicPath)
            }

            acct.link<&{Inspirax.MomentCollectionPublic}>(Inspirax.CollectionPublicPath, target: InspiraxShardedCollection.ShardedCollectionStoragePath)
        } else {

            panic("Sharded Collection already exists!")
        }
    }
}