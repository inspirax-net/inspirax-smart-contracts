import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "../../contracts/InspiraxUtilityCoin.cdc"

transaction(name: String, addr: Address) {

    let adminRef: &InspiraxBeneficiaryCut.Admin

    prepare(acct: AuthAccount) {
        self.adminRef = acct.borrow<&InspiraxBeneficiaryCut.Admin>(from: InspiraxBeneficiaryCut.AdminStoragePath)
            ?? panic("No admin resource in storage")
    }

    execute {
        let account = getAccount(addr)
        let cap = account.getCapability<&{FungibleToken.Receiver}>(InspiraxUtilityCoin.ReceiverPublicPath)

        self.adminRef.setCopyrightOwnerCapability(name: name, capability: cap)
    }
}