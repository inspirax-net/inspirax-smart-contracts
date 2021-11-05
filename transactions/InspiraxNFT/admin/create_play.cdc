import Inspirax from "../../../contracts/Inspirax.cdc"

// This transaction creates a new play struct
// and stores it in the Inspirax smart contract
// We currently stringify the metadata and insert it into the
// transaction string

// Parameters:
//
// metadata: A dictionary of all the play metadata associated

transaction(metadata: {String: String}) {

    // Local variable for the Inspirax Admin object
    let adminRef: &Inspirax.Admin
    let currPlayID: UInt32

    prepare(acct: AuthAccount) {

        // Borrow a reference to the admin resource
        self.currPlayID = Inspirax.nextPlayID
        self.adminRef = acct.borrow<&Inspirax.Admin>(from: Inspirax.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {

        // Create a play with the specified metadata
        self.adminRef.createPlay(metadata: metadata)
    }

    post {

        Inspirax.getPlayMetaData(playID: self.currPlayID) != nil:
            "playID doesnt exist"
    }
}