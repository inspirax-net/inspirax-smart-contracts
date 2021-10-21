import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"
import Inspirax from "./contracts/Inspirax.cdc"
import InspiraxMarket from "./contracts/InspiraxMarket.cdc"
import FlowStorageFees from "./contracts/FlowStorageFees.cdc"
import FlowToken from "./contracts/FlowToken.cdc"

// This transaction mints InspiraxUtilityCoin (a Fungible Token) to self,
// then purchases a moment for sale from a seller
// then deposits bought moment to a recipient
//
// Parameters: sellerAddress: the Flow address of the account issuing the sale of a moment
//             recipient: the Flow address who will receive the moment
//             tokenID: the ID of the moment being purchased
//             purchaseAmount: the amount for which the user is paying for the moment

transaction(sellerAddress: Address, recipient: Address, tokenID: UInt64, purchaseAmount: UFix64) {

    // Local variable for the coin admin
    let ducRef: &InspiraxUtilityCoin.Administrator
    let vaultRef: &FlowToken.Vault

    prepare(admin: AuthAccount) {
        self.ducRef = admin
            .borrow<&InspiraxUtilityCoin.Administrator>(from: InspiraxUtilityCoin.AdminStoragePath)
            ?? panic("TokenAdmin is not the token admin")

        // Borrow a reference to the admin flow token vault
        self.vaultRef = admin.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
                ?? panic("Failed to borrow reference to admin vault")
    }

    execute {

        let minter <- self.ducRef.createNewMinter(allowedAmount: purchaseAmount)
        let mintedVault <- minter.mintTokens(amount: purchaseAmount) as! @InspiraxUtilityCoin.Vault
        destroy minter

        let seller = getAccount(sellerAddress)
        let inspiraxSaleCollection = seller.getCapability(InspiraxMarket.marketPublicPath)
            .borrow<&{InspiraxMarket.SalePublic}>()
            ?? panic("Could not borrow public sale reference")

        let boughtToken <- inspiraxSaleCollection.purchase(tokenID: tokenID, buyTokens: <-mintedVault)

        // Get the recipient's public account object and borrow a reference to their moment receiver
        let recipient = getAccount(recipient)
        let receiverRef = recipient.getCapability(Inspirax.CollectionPublicPath).borrow<&{Inspirax.MomentCollectionPublic}>()
            ?? panic("Could not borrow a reference to the moment collection")

        // Deposit the NFT in the receiver's collection
        receiverRef.deposit(token: <-boughtToken)

        // Used to determine whether recipient needs more storage
        fun returnFlowFromStorage(_ storage: UInt64): UFix64 {
            // safe convert UInt64 to UFix64 (without overflow)
            let f = UFix64(storage % 100000000 as UInt64) * 0.00000001 as UFix64 + UFix64(storage / 100000000 as UInt64)
            // decimal point correction. Megabytes to bytes have a conversion of 10^-6 while UFix64 minimum value is 10^-8
            let storageMb = f * 100.0 as UFix64
            let storage = FlowStorageFees.storageCapacityToFlow(storageMb)
            return storage
        }

        // Determine Storage Used by user and Total Capacity in their account
        var storageUsed = returnFlowFromStorage(recipient.storageUsed)
        var storageTotal = returnFlowFromStorage(recipient.storageCapacity)

        // If user has used more than their total capacity, increase total capacity
        if (storageUsed > storageTotal) {
            let difference = storageUsed - storageTotal
            // Withdraw storage fee
            let sentVault <- self.vaultRef.withdraw(amount: difference)

            // Deposit storage fee to recipient
            let receiver = recipient.getCapability(/public/flowTokenReceiver)
                .borrow<&{FungibleToken.Receiver}>()
                    ?? panic("failed to borrow reference to recipient vault")
            receiver.deposit(from: <-sentVault)
        }
    }
}