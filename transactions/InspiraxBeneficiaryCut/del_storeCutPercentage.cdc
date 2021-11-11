import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(saleID: UInt32) {

    let adminRef: &InspiraxBeneficiaryCut.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&InspiraxBeneficiaryCut.Admin>(from: InspiraxBeneficiaryCut.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {
        self.adminRef.setStoreCutPercentages(saleID: saleID, copyrightOwnerAndCutPercentage: nil)
    }
}