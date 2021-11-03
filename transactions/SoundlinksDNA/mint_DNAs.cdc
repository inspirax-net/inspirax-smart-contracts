import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SoundlinksDNA from "../../contracts/SoundlinksDNA.cdc"

transaction(recipient: Address, hashs: [String]) {

    let dnaAdmin: &SoundlinksDNA.Admin

    prepare(signer: AuthAccount) {

        self.dnaAdmin = signer
            .borrow<&SoundlinksDNA.Admin>(from: SoundlinksDNA.AdminStoragePath)
            ?? panic("Signer is not the Soundlinks DNA admin")
    }

    execute {

        let dnaReceiver = getAccount(recipient)
            .getCapability(SoundlinksDNA.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Unable to borrow receiver reference")

        self.dnaAdmin.mintDNAs(recipient: dnaReceiver, hashs: hashs)
    }
}