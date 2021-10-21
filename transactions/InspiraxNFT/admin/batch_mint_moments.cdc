import Inspirax from "./contracts/Inspirax.cdc"
import Soundlinks from "./contracts/Soundlinks.cdc"

// This transaction mints multiple moments
// from a single set/play combination (otherwise known as edition)

// Parameters:
//
// setID: the ID of the set to be minted from
// playID: the ID of the Play from which the Moments are minted
// quantity: the quantity of Moments to be minted
// recipientAddr: the Flow address of the account receiving the collection of minted moments

transaction(setID: UInt32, playID: UInt32, quantity: UInt32, recipientAddr: Address) {

    // Local variable for the Inspirax Admin object
    let adminRef: &Inspirax.Admin
    let soundlinksDNACollection: &Soundlinks.Collection

    prepare(acct: AuthAccount) {

        // Borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&Inspirax.Admin>(from: Inspirax.AdminStoragePath)!
        self.soundlinksDNACollection = acct.borrow<&Soundlinks.Collection>(from: Soundlinks.CollectionStoragePath)!
    }

    execute {

        // borrow a reference to the set to be minted from
        let setRef = self.adminRef.borrowSet(setID: setID)

        // Get SOUNDLINKS DNAs
        let transferDNACollection <- self.soundlinksDNACollection.batchWithdraw(quantity: quantity)

        // Mint all the new NFTs
        let collection <- setRef.batchMintMoment(playID: playID, quantity: quantity, soundlinksDNACollection: <-transferDNACollection)

        // Get the account object for the recipient of the minted tokens
        let recipient = getAccount(recipientAddr)

        // Get the Collection reference for the receiver
        let receiverRef = recipient.getCapability(Inspirax.CollectionPublicPath).borrow<&{Inspirax.MomentCollectionPublic}>()
            ?? panic("Cannot borrow a reference to the recipient's collection")

        // Deposit the NFT in the receivers collection
        receiverRef.batchDeposit(tokens: <-collection)
    }
}