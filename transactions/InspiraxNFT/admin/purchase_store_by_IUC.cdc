import FungibleToken from "./contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "./contracts/InspiraxUtilityCoin.cdc"
import InspiraxBeneficiaryCut from "./contracts/InspiraxBeneficiaryCut.cdc"

transaction(saleID: UInt32, purchaseAmount: UFix64, commonwealName: String) {

    // Local variable for the purchaser
    let payRef: &InspiraxUtilityCoin.Vault

    prepare(acct: AuthAccount) {
        self.payRef = acct.borrow<&InspiraxUtilityCoin.Vault>(from: InspiraxUtilityCoin.VaultStoragePath)
            ?? panic("Could not borrow reference to the owner's Vault!")
    }

    execute {
        if (self.payRef.balance >= purchaseAmount) {

            let purchaseVault <- self.payRef.withdraw(amount: purchaseAmount) as! @InspiraxUtilityCoin.Vault

            if (commonwealName != "\"null\"") {
                // Commonweal Cut
                let commonwealCutPercentage = InspiraxBeneficiaryCut.getCommonwealCutPercentage(name: commonwealName)
                    ?? panic("Cannot find the commonweal cutPercentage by the name")
                let commonwealCutAmount = purchaseAmount * commonwealCutPercentage
                let commonwealCut <- purchaseVault.withdraw(amount: commonwealCutAmount)

                let commonwealCap = InspiraxBeneficiaryCut.getCommonwealCapability(name: commonwealName)
                    ?? panic("Cannot find the commonweal by the name")
                let commonwealReceiverRef = commonwealCap.borrow<&{FungibleToken.Receiver}>()
                    ?? panic("Cannot find commonweal token receiver")
                commonwealReceiverRef.deposit(from: <-commonwealCut)
            }

            // Copyright owners Cut
            let tokenAmount = purchaseVault.balance
            for name in InspiraxBeneficiaryCut.getStoreCopyrightOwnerNames(saleID: saleID) {
                let copyrightOwnerCutPercentage = InspiraxBeneficiaryCut.getStoreCutPercentage(saleID: saleID, name: name)
                    ?? panic("Cannot find the copyright owner cutPercentage by the name")
                let copyrightOwnerCutAmount = tokenAmount * copyrightOwnerCutPercentage
                let copyrightOwnerCut <- purchaseVault.withdraw(amount: copyrightOwnerCutAmount)

                let copyrightOwnerCap = InspiraxBeneficiaryCut.getCopyrightOwnerCapability(name: name)
                    ?? panic("Cannot find the copyright owner by the name")
                let copyrightOwnerReceiverRef = copyrightOwnerCap.borrow<&{FungibleToken.Receiver}>()
                    ?? panic("Cannot find copyright owner token receiver")
                copyrightOwnerReceiverRef.deposit(from: <-copyrightOwnerCut)
            }
            destroy purchaseVault
        } else{
            panic("There's not enough InspiraxUtilityCoin in the account")
        }
    }
}