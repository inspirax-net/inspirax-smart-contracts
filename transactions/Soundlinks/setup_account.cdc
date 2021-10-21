import Soundlinks from "./contracts/Soundlinks.cdc"

transaction {

    prepare(signer: AuthAccount) {

        if signer.borrow<&Soundlinks.Collection>(from: Soundlinks.CollectionStoragePath) != nil {
            return
        }

        signer.save(
            <-Soundlinks.createEmptyCollection(),
            to: Soundlinks.CollectionStoragePath
        )

        signer.link<&Soundlinks.Collection{Soundlinks.CollectionPublic}>(
            Soundlinks.CollectionPublicPath,
            target: Soundlinks.CollectionStoragePath
        )
    }
}