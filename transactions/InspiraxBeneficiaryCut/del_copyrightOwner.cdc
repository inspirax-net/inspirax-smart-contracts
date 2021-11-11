import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(name: String) {

    let adminRef: &InspiraxBeneficiaryCut.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&InspiraxBeneficiaryCut.Admin>(from: InspiraxBeneficiaryCut.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {
        self.adminRef.setCopyrightOwnerCapability(name: name, capability: nil)
    }
}