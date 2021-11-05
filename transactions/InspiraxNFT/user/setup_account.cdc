import Inspirax from "../../../contracts/Inspirax.cdc"

// This transaction sets up an account to use Inspirax
// by storing an empty moment collection and creating
// a public capability for it

transaction {

    prepare(acct: AuthAccount) {

        // First, check to see if a moment collection already exists
        if acct.borrow<&Inspirax.Collection>(from: Inspirax.CollectionStoragePath) == nil {

            // Create a new Inspirax Collection
            let collection <- Inspirax.createEmptyCollection() as! @Inspirax.Collection

            // Put the new Collection in storage
            acct.save(<-collection, to: Inspirax.CollectionStoragePath)

            // create a public capability for the collection
            acct.link<&{Inspirax.MomentCollectionPublic}>(Inspirax.CollectionPublicPath, target: Inspirax.CollectionStoragePath)
        }
    }
}