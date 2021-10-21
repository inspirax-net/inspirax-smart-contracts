import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"

transaction(amount: UFix64) {

    let vault: @FungibleToken.Vault
    let admin: &InspiraxUtilityCoin.Administrator

    prepare(signer: AuthAccount, tokenAdmin: AuthAccount) {

        self.vault <- signer.borrow<&InspiraxUtilityCoin.Vault>(from: InspiraxUtilityCoin.VaultStoragePath)!
            .withdraw(amount: amount)

        self.admin = tokenAdmin.borrow<&InspiraxUtilityCoin.Administrator>(from: InspiraxUtilityCoin.AdminStoragePath)
            ?? panic("Could not borrow a reference to the admin resource")
    }

    execute {
        
        let burner <- self.admin.createNewBurner()
        burner.burnTokens(from: <-self.vault)

        destroy burner
    }
}