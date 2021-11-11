import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(playID: UInt32) {

    let adminRef: &InspiraxBeneficiaryCut.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&InspiraxBeneficiaryCut.Admin>(from: InspiraxBeneficiaryCut.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {
        self.adminRef.setMarketCutPercentages(playID: playID, copyrightOwnerAndCutPercentage: nil)
    }
}