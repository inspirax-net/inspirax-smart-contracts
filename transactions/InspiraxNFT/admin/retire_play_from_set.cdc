import Inspirax from "./contracts/Inspirax.cdc"

// This transaction is for retiring a play from a set, which
// makes it so that moments can no longer be minted from that edition

// Parameters:
// 
// setID: the ID of the set in which a play is to be retired
// playID: the ID of the play to be retired

transaction(setID: UInt32, playID: UInt32) {

    // Local variable for storing the reference to the admin resource
    let adminRef: &Inspirax.Admin

    prepare(acct: AuthAccount) {

        // Borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&Inspirax.Admin>(from: Inspirax.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {

        // Borrow a reference to the specified set
        let setRef = self.adminRef.borrowSet(setID: setID)

        // retire the play
        setRef.retirePlay(playID: playID)
    }

    post {
        self.adminRef.borrowSet(setID: setID).retired[playID]!: 
            "play is not retired"
    }
}