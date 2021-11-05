import Inspirax from "../../../contracts/Inspirax.cdc"

// This transaction is for the admin to create a new set resource
// and store it in the Inspirax smart contract

// Parameters:
//
// setName: the name of a new Set to be created

transaction(setName: String) {

    // Local variable for the Inspirax Admin object
    let adminRef: &Inspirax.Admin
    let currSetID: UInt32

    prepare(acct: AuthAccount) {

        // Borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&Inspirax.Admin>(from: Inspirax.AdminStoragePath)
            ?? panic("Could not borrow a reference to the Admin resource")
        self.currSetID = Inspirax.nextSetID
    }

    execute {

        // Create a set with the specified name
        self.adminRef.createSet(name: setName)
    }

    post {

        Inspirax.getSetName(setID: self.currSetID) == setName:
          "Could not find the specified set"
    }
}