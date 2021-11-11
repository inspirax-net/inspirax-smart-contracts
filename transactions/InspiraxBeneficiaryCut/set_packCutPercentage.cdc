import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(packID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}) {

    let adminRef: &InspiraxBeneficiaryCut.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&InspiraxBeneficiaryCut.Admin>(from: InspiraxBeneficiaryCut.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {
        self.adminRef.setPackCutPercentages(packID: packID, copyrightOwnerAndCutPercentage: copyrightOwnerAndCutPercentage)
    }
}