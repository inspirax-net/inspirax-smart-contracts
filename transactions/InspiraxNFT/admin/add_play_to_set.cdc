import Inspirax from "./contracts/Inspirax.cdc"

// This transaction is how a Inspirax admin adds a created play to a set

// Parameters:
//
// setID: the ID of the set to which a created play is added
// playID: the ID of the play being added

transaction(setID: UInt32, playID: UInt32) {

    // Local variable for the Inspirax Admin object
    let adminRef: &Inspirax.Admin

    prepare(acct: AuthAccount) {

    // Borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&Inspirax.Admin>(from: Inspirax.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Admin resource")
    }

    execute {

        // Borrow a reference to the set to be added to
        let setRef = self.adminRef.borrowSet(setID: setID)

        // Add the specified play ID
        setRef.addPlay(playID: playID)
    }

    post {
        Inspirax.getPlaysInSet(setID: setID)!.contains(playID): 
            "set does not contain playID"
    }
}