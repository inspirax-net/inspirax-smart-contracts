import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"
import Inspirax from "./contracts/Inspirax.cdc"
import InspiraxMarket from "./contracts/InspiraxMarket.cdc"
import FlowStorageFees from "./contracts/FlowStorageFees.cdc"
import FlowToken from "./contracts/FlowToken.cdc"

// This transaction is for a user to purchase a moment that another user
// has for sale in their sale collection
//
// Parameters: sellerAddress: the Flow address of the account issuing the sale of a moment
//             tokenID: the ID of the moment being purchased
//             purchaseAmount: the amount for which the user is paying for the moment

transaction(sellerAddress: Address, tokenID: UInt64, purchaseAmount: UFix64) {

    // Local variable for the purchaser
    let payVault: &InspiraxUtilityCoin.Vault
    let payCollection: &Inspirax.Collection
    let vaultRef: &FlowToken.Vault
    let recipient: PublicAccount

    prepare(acct: AuthAccount, admin: AuthAccount) {
        self.payVault = acct.borrow<&InspiraxUtilityCoin.Vault>(from: InspiraxUtilityCoin.VaultStoragePath)
            ?? panic("Could not borrow reference to the purchaser's Vault!")

        self.payCollection = acct.borrow<&Inspirax.Collection>(from: Inspirax.CollectionStoragePath)
            ?? panic("Could not borrow reference to the Moment Collection")

        // Borrow a reference to the admin flow token vault
        self.vaultRef = admin.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
            ?? panic("Failed to borrow reference to admin vault")

        self.recipient = getAccount(acct.address)
    }

    execute {
        if (self.payVault.balance >= purchaseAmount) {

            let tokens <- self.payVault.withdraw(amount: purchaseAmount) as! @InspiraxUtilityCoin.Vault

            // Get the seller's public account object
            let seller = getAccount(sellerAddress)

            // Borrow a public reference to the seller's sale collection
            let inspiraxSaleCollection = seller.getCapability(InspiraxMarket.marketPublicPath)
                .borrow<&{InspiraxMarket.SalePublic}>()
                ?? panic("Could not borrow public sale reference")

            // Purchase the moment
            let boughtToken <- inspiraxSaleCollection.purchase(tokenID: tokenID, buyTokens: <-tokens)

            // Deposit the purchased moment into the purchaser's collection
            self.payCollection.deposit(token: <-boughtToken)

            // Used to determine whether recipient needs more storage
            fun returnFlowFromStorage(_ storage: UInt64): UFix64 {
                // Safe convert UInt64 to UFix64 (without overflow)
                let f = UFix64(storage % 100000000 as UInt64) * 0.00000001 as UFix64 + UFix64(storage / 100000000 as UInt64)
                // Decimal point correction. Megabytes to bytes have a conversion of 10^-6 while UFix64 minimum value is 10^-8
                let storageMb = f * 100.0 as UFix64
                let storage = FlowStorageFees.storageCapacityToFlow(storageMb)
                return storage
            }

            // Determine Storage Used by user and Total Capacity in their account
            var storageUsed = returnFlowFromStorage(self.recipient.storageUsed)
            var storageTotal = returnFlowFromStorage(self.recipient.storageCapacity)

            // If user has used more than their total capacity, increase total capacity
            if (storageUsed > storageTotal) {
                let difference = storageUsed - storageTotal
                // Withdraw storage fee
                let sentVault <- self.vaultRef.withdraw(amount: difference)

                // Deposit storage fee to recipient
                let receiver = self.recipient.getCapability(/public/flowTokenReceiver)
                    .borrow<&{FungibleToken.Receiver}>()
                        ?? panic("failed to borrow reference to recipient vault")
                receiver.deposit(from: <-sentVault)
            }
        } else{
            panic("There's not enough InspiraxUtilityCoin in the account")
        }
    }
}