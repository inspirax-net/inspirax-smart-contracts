import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(cutPercentage: UFix64) {

    let adminRef: &InspiraxBeneficiaryCut.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&InspiraxBeneficiaryCut.Admin>(from: InspiraxBeneficiaryCut.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {
        self.adminRef.setInspiraxMarketCutPercentage(cutPercentage: cutPercentage)
    }
}