import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"

transaction(recipient: Address, amount: UFix64) {

    let tokenAdmin: &InspiraxUtilityCoin.Administrator
    let tokenReceiver: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {

        self.tokenAdmin = signer.borrow<&InspiraxUtilityCoin.Administrator>(from: InspiraxUtilityCoin.AdminStoragePath)
            ?? panic("Signer is not the UtilityCoin admin")

        self.tokenReceiver = getAccount(recipient)
            .getCapability(InspiraxUtilityCoin.ReceiverPublicPath)!
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Unable to borrow receiver reference")
    }

    execute {

        let minter <- self.tokenAdmin.createNewMinter(allowedAmount: amount)
        let mintedVault <- minter.mintTokens(amount: amount)

        self.tokenReceiver.deposit(from: <-mintedVault)

        destroy minter
    }
}