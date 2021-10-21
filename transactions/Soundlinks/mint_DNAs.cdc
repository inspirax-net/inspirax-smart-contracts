import Soundlinks from "./contracts/Soundlinks.cdc"

transaction(recipient: Address, hashs: [String]) {

    let dnaAdmin: &Soundlinks.Admin
    let dnaReceiver: &Soundlinks.Collection{Soundlinks.CollectionPublic}

    prepare(signer: AuthAccount) {

        self.dnaAdmin = signer
            .borrow<&Soundlinks.Admin>(from: Soundlinks.AdminStoragePath)
            ?? panic("Signer is not the Soundlinks DNA admin")

        self.dnaReceiver = getAccount(recipient)
            .getCapability(Soundlinks.CollectionPublicPath)!
            .borrow<&Soundlinks.Collection{Soundlinks.CollectionPublic}>()
            ?? panic("Unable to borrow receiver reference")
    }

    execute {

        let minter <- self.dnaAdmin.createNewMinter(hashs: hashs)
        let mintedCollection <- minter.mintDNAs(quantity: UInt32(hashs.length))
        self.dnaReceiver.batchDeposit(dnas: <-mintedCollection)

        destroy minter
    }
}