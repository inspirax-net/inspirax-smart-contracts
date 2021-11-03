import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import SoundlinksDNA from "../../contracts/SoundlinksDNA.cdc"

transaction {

    prepare(signer: AuthAccount) {

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
    }
}