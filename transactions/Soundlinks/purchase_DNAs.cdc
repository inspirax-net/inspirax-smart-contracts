import Soundlinks from "./contracts/Soundlinks.cdc"
import FungibleToken from "./contracts/FungibleToken.cdc"
import FlowToken from "./contracts/FlowToken.cdc"

transaction(purchaseAmount: UInt32, hashs: [String], purchaseUnitPrice: UFix64) {

    let dnaAdmin: &Soundlinks.Admin
    let dnaReceiver: &Soundlinks.Collection{Soundlinks.CollectionPublic}
    let flowPayer: &FlowToken.Vault
    let flowReceiver: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount, soundlinksAdmin: AuthAccount) {

        if signer.borrow<&Soundlinks.Collection>(from: Soundlinks.CollectionStoragePath) == nil {
            signer.save(
                <-Soundlinks.createEmptyCollection(),
                to: Soundlinks.CollectionStoragePath
            )

            signer.link<&Soundlinks.Collection{Soundlinks.CollectionPublic}>(
                Soundlinks.CollectionPublicPath,
                target: Soundlinks.CollectionStoragePath
            )
        }

        self.dnaAdmin = soundlinksAdmin
            .borrow<&Soundlinks.Admin>(from: Soundlinks.AdminStoragePath)
            ?? panic("soundlinksAdmin is not the Soundlinks DNA admin.")

        self.dnaReceiver = signer
            .getCapability(Soundlinks.CollectionPublicPath)!
            .borrow<&Soundlinks.Collection{Soundlinks.CollectionPublic}>()
            ?? panic("Could not borrow receiver reference to the recipient's DNA Collection.")

        self.flowPayer = signer
            .borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Failed to borrow reference to signer's Flow Vault.")

        self.flowReceiver = soundlinksAdmin
            .getCapability(/public/flowTokenReceiver)!
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Could not borrow receiver reference to the recipient's Flow Vault.")
    }

    pre {

        UInt32(hashs.length) == purchaseAmount: "The amount of hashs should be the same as the purchaseAmount."

    }

    execute {

        let amount = UFix64(purchaseAmount) * purchaseUnitPrice
        let sentVault <- self.flowPayer.withdraw(amount: amount)
        self.flowReceiver.deposit(from: <- sentVault)

        let minter <- self.dnaAdmin.createNewMinter(hashs: hashs)
        let mintedCollection <- minter.mintDNAs(quantity: purchaseAmount)
        self.dnaReceiver.batchDeposit(dnas: <-mintedCollection)

        destroy minter
    }
}