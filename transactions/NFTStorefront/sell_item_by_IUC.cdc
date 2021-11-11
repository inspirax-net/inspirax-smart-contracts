import FungibleToken from "../../contracts/FungibleToken.cdc"
import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import InspiraxUtilityCoin from "../../contracts/InspiraxUtilityCoin.cdc"
import Inspirax from "../../contracts/Inspirax.cdc"
import NFTStorefront from "../../contracts/NFTStorefront.cdc"
import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

transaction(saleItemID: UInt64, saleItemPrice: UFix64) {

    let inspiraxUtilityCoinReceiver: Capability<&InspiraxUtilityCoin.Vault{FungibleToken.Receiver}>
    let inspiraxNFTProvider: Capability<&Inspirax.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>
    let inspiraxNFTcollectionRef: &Inspirax.Collection
    let storefront: &NFTStorefront.Storefront

    prepare(acct: AuthAccount) {

        // We need a provider capability, but one is not provided by default so we create one if needed.
        let inspiraxNFTCollectionProviderPrivatePath = /private/inspiraxNFTCollectionProviderForNFTStorefront

        self.inspiraxUtilityCoinReceiver = acct.getCapability<&InspiraxUtilityCoin.Vault{FungibleToken.Receiver}>(InspiraxUtilityCoin.ReceiverPublicPath)!

        assert(self.inspiraxUtilityCoinReceiver.borrow() != nil, message: "Missing or mis-typed InspiraxUtilityCoin receiver")

        if !acct.getCapability<&Inspirax.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(inspiraxNFTCollectionProviderPrivatePath)!.check() {
            acct.link<&Inspirax.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(inspiraxNFTCollectionProviderPrivatePath, target: Inspirax.CollectionStoragePath)
        }

        self.inspiraxNFTProvider = acct.getCapability<&Inspirax.Collection{NonFungibleToken.Provider, NonFungibleToken.CollectionPublic}>(inspiraxNFTCollectionProviderPrivatePath)!
        assert(self.inspiraxNFTProvider.borrow() != nil, message: "Missing or mis-typed Inspirax.Collection provider")

        self.inspiraxNFTcollectionRef = acct.borrow<&Inspirax.Collection>(from: Inspirax.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the stored Moment collection")

        self.storefront = acct.borrow<&NFTStorefront.Storefront>(from: NFTStorefront.StorefrontStoragePath)
            ?? panic("Missing or mis-typed NFTStorefront Storefront")
    }

    execute {

        var saleCuts: [NFTStorefront.SaleCut] = []
        var sellerCutAmount = saleItemPrice

        let nftRef = self.inspiraxNFTcollectionRef.borrowMoment(id: saleItemID)
            ?? panic("Could not borrow a reference to the NFT")
        let playID = nftRef.data.playID

        // Inspirax Market Cut
        let inspiraxMarketCutPercentage = InspiraxBeneficiaryCut.inspiraxMarketCutPercentage
        let inspiraxMarketCutAmount = saleItemPrice * inspiraxMarketCutPercentage
        saleCuts.append(NFTStorefront.SaleCut(
                receiver: InspiraxBeneficiaryCut.inspiraxCapability,
                amount: inspiraxMarketCutAmount
        ))
        sellerCutAmount = sellerCutAmount - inspiraxMarketCutAmount

        // Copyright owners Market Cut
        for name in InspiraxBeneficiaryCut.getMarketCopyrightOwnerNames(playID: playID)! {
            let copyrightOwnerCap = InspiraxBeneficiaryCut.getCopyrightOwnerCapability(name: name)
                ?? panic("Cannot find the copyright owner by the name.")
            let copyrightOwnerCutPercentage = InspiraxBeneficiaryCut.getMarketCutPercentage(playID: playID, name: name)
                ?? panic("Cannot find the copyright owner cutPercentage by the name.")
            let copyrightOwnerCutAmount = saleItemPrice * copyrightOwnerCutPercentage
            saleCuts.append(NFTStorefront.SaleCut(
                receiver: copyrightOwnerCap as Capability<&{FungibleToken.Receiver}>,
                amount: copyrightOwnerCutAmount
            ))
            sellerCutAmount = sellerCutAmount - copyrightOwnerCutAmount
        }

        // Seller Cut
        let sellerCut = NFTStorefront.SaleCut(
            receiver: self.inspiraxUtilityCoinReceiver,
            amount: sellerCutAmount
        )
        saleCuts.insert(at:0 ,sellerCut)

        self.storefront.createListing(
            nftProviderCapability: self.inspiraxNFTProvider,
            nftType: Type<@Inspirax.NFT>(),
            nftID: saleItemID,
            salePaymentVaultType: Type<@InspiraxUtilityCoin.Vault>(),
            saleCuts: saleCuts
        )
    }
}