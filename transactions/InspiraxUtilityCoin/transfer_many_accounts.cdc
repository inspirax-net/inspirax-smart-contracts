import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"

transaction(addressAmountMap: {Address: UFix64}) {

    let vaultRef: &InspiraxUtilityCoin.Vault

    prepare(signer: AuthAccount) {

        self.vaultRef = signer.borrow<&InspiraxUtilityCoin.Vault>(from: InspiraxUtilityCoin.VaultStoragePath)
			?? panic("Could not borrow reference to the owner's Vault!")
    }

    execute {

        for address in addressAmountMap.keys {

            let sentVault <- self.vaultRef.withdraw(amount: addressAmountMap[address]!)

            let recipient = getAccount(address)

            let receiverRef = recipient.getCapability(InspiraxUtilityCoin.ReceiverPublicPath)!
                .borrow<&{FungibleToken.Receiver}>()
                ?? panic("Could not borrow receiver reference to the recipient's Vault")

            receiverRef.deposit(from: <-sentVault)
        }
    }
}