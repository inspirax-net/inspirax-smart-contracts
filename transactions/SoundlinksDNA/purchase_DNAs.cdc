import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SoundlinksDNA from "../../contracts/SoundlinksDNA.cdc"
import FungibleToken from "../../contracts/FungibleToken.cdc"
import FlowToken from "../../contracts/FlowToken.cdc"

transaction(purchaseAmount: UInt32, hashs: [String], purchaseUnitPrice: UFix64) {

    let dnaAdmin: &SoundlinksDNA.Admin
    let dnaReceiver: &{NonFungibleToken.CollectionPublic}
    let flowPayer: &FlowToken.Vault
    let flowReceiver: &{FungibleToken.Receiver}

    prepare(soundlinksAdmin: AuthAccount, signer: AuthAccount) {

        if signer.borrow<&SoundlinksDNA.Collection>(from: SoundlinksDNA.CollectionStoragePath) == nil {

            signer.save(
                <-SoundlinksDNA.createEmptyCollection(),
                to: SoundlinksDNA.CollectionStoragePath
            )

            signer.link<&SoundlinksDNA.Collection{NonFungibleToken.CollectionPublic, SoundlinksDNA.SoundlinksDNACollectionPublic}>(
                SoundlinksDNA.CollectionPublicPath,
                target: SoundlinksDNA.CollectionStoragePath
            )
        }

        self.dnaAdmin = soundlinksAdmin
            .borrow<&SoundlinksDNA.Admin>(from: SoundlinksDNA.AdminStoragePath)
            ?? panic("soundlinksAdmin is not the Soundlinks DNA admin.")

        self.dnaReceiver = signer
            .getCapability(SoundlinksDNA.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()
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

        self.dnaAdmin.mintDNAs(recipient: self.dnaReceiver, hashs: hashs)
    }
}