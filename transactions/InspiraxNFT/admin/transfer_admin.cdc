import Inspirax from "../../../contracts/Inspirax.cdc"
import InspiraxAdminReceiver from "../../../contracts/InspiraxAdminReceiver.cdc"

// This transaction takes a Inspirax Admin resource and
// saves it to the account storage of the account
// where the contract is deployed

transaction {

    // Local variable for the Inspirax Admin object
    let adminRef: @Inspirax.Admin

    prepare(acct: AuthAccount) {

        self.adminRef <- acct.load<@Inspirax.Admin>(from: Inspirax.AdminStoragePath)
            ?? panic("No Inspirax admin in storage")

    }

    execute {

        InspiraxAdminReceiver.storeAdmin(newAdmin: <-self.adminRef)

    }
}