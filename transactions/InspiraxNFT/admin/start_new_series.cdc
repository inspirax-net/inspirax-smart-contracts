import Inspirax from "../../../contracts/Inspirax.cdc"

// This transaction is for an Admin to start a new Inspirax series

transaction {

    // Local variable for the Inspirax Admin object
    let adminRef: &Inspirax.Admin
    let currentSeries: UInt32

    prepare(acct: AuthAccount) {

        // Borrow a reference to the Admin resource in storage
        self.adminRef = acct.borrow<&Inspirax.Admin>(from: Inspirax.AdminStoragePath)
            ?? panic("No admin resource in storage")

        self.currentSeries = Inspirax.currentSeries
    }

    execute {

        // Increment the series number
        self.adminRef.startNewSeries()
    }

    post {

        Inspirax.currentSeries == self.currentSeries + 1 as UInt32:
            "new series not started"
    }
}