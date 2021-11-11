import FungibleToken from "../../../contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "../../../contracts/InspiraxUtilityCoin.cdc"
import InspiraxBeneficiaryCut from "../../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(packID: UInt32, purchaseAmount: UFix64, commonwealName: String) {

    // Local variable for the coin admin
    let ducRef: &InspiraxUtilityCoin.Administrator

    prepare(tokenAdmin: AuthAccount) {
        self.ducRef = tokenAdmin
            .borrow<&InspiraxUtilityCoin.Administrator>(from: InspiraxUtilityCoin.AdminStoragePath)
            ?? panic("Signer is not the token admin")
    }

    execute {
        let minter <- self.ducRef.createNewMinter(allowedAmount: purchaseAmount)
        let mintedVault <- minter.mintTokens(amount: purchaseAmount) as! @InspiraxUtilityCoin.Vault
        destroy minter

        if (commonwealName != "null") {
            // Commonweal Cut
            let commonwealCutPercentage = InspiraxBeneficiaryCut.getCommonwealCutPercentage(name: commonwealName)
                ?? panic("Cannot find the commonweal cutPercentage by the name")
            let commonwealCutAmount = purchaseAmount * commonwealCutPercentage
            let commonwealCut <- mintedVault.withdraw(amount: commonwealCutAmount)

            let commonwealCap = InspiraxBeneficiaryCut.getCommonwealCapability(name: commonwealName)
                ?? panic("Cannot find the commonweal by the name")
            let commonwealReceiverRef = commonwealCap.borrow()
                ?? panic("Cannot find commonweal token receiver")
            commonwealReceiverRef.deposit(from: <-commonwealCut)
        }

        // Copyright owners Cut
        let tokenAmount = mintedVault.balance
        for name in InspiraxBeneficiaryCut.getPackCopyrightOwnerNames(packID: packID)! {
            let copyrightOwnerCutPercentage = InspiraxBeneficiaryCut.getPackCutPercentage(packID: packID, name: name)
                ?? panic("Cannot find the copyright owner cutPercentage by the name")
            let copyrightOwnerCutAmount = tokenAmount * copyrightOwnerCutPercentage
            let copyrightOwnerCut <- mintedVault.withdraw(amount: copyrightOwnerCutAmount)

            let copyrightOwnerCap = InspiraxBeneficiaryCut.getCopyrightOwnerCapability(name: name)
                ?? panic("Cannot find the copyright owner by the name")
            let copyrightOwnerReceiverRef = copyrightOwnerCap.borrow()
                ?? panic("Cannot find copyright owner token receiver")
            copyrightOwnerReceiverRef.deposit(from: <-copyrightOwnerCut)
        }
        destroy mintedVault
    }
}