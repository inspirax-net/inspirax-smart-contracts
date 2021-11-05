import FungibleToken from "../../contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "../../contracts/InspiraxUtilityCoin.cdc"

transaction {

    prepare(signer: AuthAccount) {

        if signer.borrow<&InspiraxUtilityCoin.Vault>(from: InspiraxUtilityCoin.VaultStoragePath) != nil {
            return
        }

        signer.save(
            <-InspiraxUtilityCoin.createEmptyVault(),
            to: InspiraxUtilityCoin.VaultStoragePath
        )

        signer.link<&InspiraxUtilityCoin.Vault{FungibleToken.Receiver}>(
            InspiraxUtilityCoin.ReceiverPublicPath,
            target: InspiraxUtilityCoin.VaultStoragePath
        )

        signer.link<&InspiraxUtilityCoin.Vault{FungibleToken.Balance}>(
            InspiraxUtilityCoin.BalancePublicPath,
            target: InspiraxUtilityCoin.VaultStoragePath
        )
    }
}