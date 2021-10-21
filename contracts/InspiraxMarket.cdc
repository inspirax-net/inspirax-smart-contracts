/**
    Description: InspiraxMarket Contract definitions for users to sell their NFTs
    Marketplace is where users can create a sale collection that they
    store in their account storage. In the sale collection,
    they can put their NFTs up for sale with a price and publish a
    reference so that others can see the sale.
**/

import FungibleToken from "./FungibleToken.cdc"
import InspiraxUtilityCoin from "./InspiraxUtilityCoin.cdc"
import Inspirax from "./Inspirax.cdc"
import InspiraxBeneficiaryCut from "./InspiraxBeneficiaryCut.cdc"

pub contract InspiraxMarket {

    // -----------------------------------------------------------------------
    // Inspirax Market Contract Event Definitions
    // -----------------------------------------------------------------------

    /// Emitted when a Inspirax moment is listed for sale
    pub event MomentListed(id: UInt64, price: UFix64, seller: Address?)
    /// Emitted when the price of a listed moment has changed
    pub event MomentPriceChanged(id: UInt64, newPrice: UFix64, seller: Address?)
    /// Emitted when a token is purchased from the market
    pub event MomentPurchased(id: UInt64, price: UFix64, seller: Address?)
    /// Emitted when a moment sale has been cancelled
    pub event MomentCancelSale(id: UInt64, owner: Address?)

    /// Named paths
    pub let marketStoragePath: StoragePath
    pub let marketPublicPath: PublicPath

    /// SalePublic
    ///
    /// The interface that a user can publish a capability to their sale
    /// to allow others to access their sale
    pub resource interface SalePublic {
        pub fun purchase(tokenID: UInt64, buyTokens: @InspiraxUtilityCoin.Vault): @Inspirax.NFT {
            post {
                result.id == tokenID: "The ID of the withdrawn token must be the same as the requested ID."
            }
        }
        pub fun getPrice(tokenID: UInt64): UFix64?
        pub fun getIDs(): [UInt64]
        pub fun borrowMoment(id: UInt64): &Inspirax.NFT? {
            // If the result isn't nil, the id of the returned reference
            // should be the same as the argument to the function
            post {
                (result == nil) || (result?.id == id):
                    "Cannot borrow Moment reference: The ID of the returned reference is incorrect."
            }
        }
    }

    /// SaleCollection
    ///
    /// This is the main resource that token sellers will store in their account
    /// to manage the NFTs that they are selling. The SaleCollection
    /// holds a Inspirax Collection reference to store the moments that are for sale.
    /// The SaleCollection also keeps track of the price of each token.
    pub resource SaleCollection: SalePublic {

        /// A collection of the moments that the user has for sale
        access(self) var ownerCollection: Capability<&Inspirax.Collection>

        /// The fungible token vault of the seller
        /// so that when someone buys a token, the tokens are deposited to this Vault
        access(self) var ownerCapability: Capability<&{FungibleToken.Receiver}>

        /// Dictionary of the prices for each NFT by ID
        access(self) var prices: {UInt64: UFix64}

        init (ownerCollection: Capability<&Inspirax.Collection>,
              ownerCapability: Capability<&{FungibleToken.Receiver}>) {
            pre {
                // Check that the owner's moment collection capability is correct
                ownerCollection.check():
                    "Owner's Moment Collection Capability is invalid!"

                // Check that the owner's capability is for fungible token Vault receiver
                ownerCapability.check():
                    "Owner's Receiver Capability is invalid!"
            }

            self.ownerCollection = ownerCollection
            self.ownerCapability = ownerCapability
            // Prices are initially empty because there are no moments for sale
            self.prices = {}
        }

        /// listForSale lists an NFT for sale in this sale collection
        /// at the specified price
        ///
        /// Parameters: tokenID: The id of the NFT to be put up for sale
        ///             price: The price of the NFT
        pub fun listForSale(tokenID: UInt64, price: UFix64) {
            pre {
                self.ownerCollection.borrow()!.borrowMoment(id: tokenID) != nil:
                    "Moment does not exist in the owner's collection."
            }

            if let value = self.prices[tokenID] {
                // Set the token's newprice
                self.prices[tokenID] = price
                emit MomentPriceChanged(id: tokenID, newPrice: price, seller: self.owner?.address)
            } else {
                // Set the token's price
                self.prices[tokenID] = price
                emit MomentListed(id: tokenID, price: price, seller: self.owner?.address)
            }
        }

        /// cancelSale cancels a moment sale and clears its price
        ///
        /// Parameters: tokenID: the ID of the NFT from the sale
        ///
        pub fun cancelSale(tokenID: UInt64) {
            pre {
                self.prices[tokenID] != nil: "Token with the specified ID is not already for sale."
            }

            // Set price to nil for the NFT ID
            self.prices[tokenID] = nil

            // Remove the price from the prices dictionary
            self.prices.remove(key: tokenID)

            // Emit the event for cancel the Sale
            emit MomentCancelSale(id: tokenID, owner: self.owner?.address)
        }

        /// purchase lets a user send tokens to purchase an NFT that is for sale
        /// the purchased NFT is returned to the transaction context that called it
        ///
        /// Parameters: tokenID: the ID of the NFT to purchase
        ///             buyTokens: the fungible tokens that are used to buy the NFT
        ///
        /// Returns: @Inspirax.NFT: the purchased NFT
        pub fun purchase(tokenID: UInt64, buyTokens: @InspiraxUtilityCoin.Vault): @Inspirax.NFT {
            pre {
                self.ownerCollection.borrow()!.borrowMoment(id: tokenID) != nil && self.prices[tokenID] != nil:
                    "No NFT matching this ID for sale!"
                buyTokens.balance == self.prices[tokenID]!:
                    "Not enough tokens to buy the NFT!"
            }

            // Read the price for the token
            let price = self.prices[tokenID]!

            // Set price to nil for the NFT ID
            self.prices[tokenID] = nil

            // Remove the price from the prices dictionary
            self.prices.remove(key: tokenID)

            // Withdraw the purchased token
            let boughtMoment <- self.ownerCollection.borrow()!.withdraw(withdrawID: tokenID) as! @Inspirax.NFT

            let playID = boughtMoment.data.playID

            // Inspirax Market Cut
            let inspiraxMarketCutPercentage = InspiraxBeneficiaryCut.getInspiraxMarketCutPercentage()
            let inspiraxMarketCutAmount = price * inspiraxMarketCutPercentage
            let inspiraxMarketCut <- buyTokens.withdraw(amount: inspiraxMarketCutAmount)

            let inspiraxCap = InspiraxBeneficiaryCut.getInspiraxCapability()
            let inspiraxReceiverRef = inspiraxCap.borrow<&{FungibleToken.Receiver}>()
                ?? panic("Cannot find Inspirax token receiver.")
            inspiraxReceiverRef.deposit(from: <-inspiraxMarketCut)

            // Copyright owners Market Cut
            for name in InspiraxBeneficiaryCut.getMarketCopyrightOwnerNames(playID: playID) {
                let copyrightOwnerCutPercentage = InspiraxBeneficiaryCut.getMarketCutPercentage(playID: playID, name: name)
                    ?? panic("Cannot find the copyright owner cutPercentage by the name.")
                let copyrightOwnerCutAmount = price * copyrightOwnerCutPercentage
                let copyrightOwnerCut <- buyTokens.withdraw(amount: copyrightOwnerCutAmount)

                let copyrightOwnerCap = InspiraxBeneficiaryCut.getCopyrightOwnerCapability(name: name)
                    ?? panic("Cannot find the copyright owner by the name.")
                let copyrightOwnerReceiverRef = copyrightOwnerCap.borrow<&{FungibleToken.Receiver}>()
                    ?? panic("Cannot find copyright owner token receiver.")
                copyrightOwnerReceiverRef.deposit(from: <-copyrightOwnerCut)
            }

            // Deposit the remaining tokens into the owners vault
            self.ownerCapability.borrow()!
                .deposit(from: <-buyTokens)

            emit MomentPurchased(id: tokenID, price: price, seller: self.owner?.address)

            return <-boughtMoment
        }

        /// changeOwnerReceiver updates the capability for the sellers fungible token Vault
        ///
        /// Parameters: newOwnerCapability: The new fungible token capability for the account
        ///                                 who received tokens for purchases
        pub fun changeOwnerReceiver(_ newOwnerCapability: Capability<&{FungibleToken.Receiver}>) {
            pre {
                newOwnerCapability.borrow() != nil:
                    "Owner's Receiver Capability is invalid!"
            }
            self.ownerCapability = newOwnerCapability
        }

        /// getPrice returns the price of a specific token in the sale
        ///
        /// Parameters: tokenID: The ID of the NFT whose price to get
        ///
        /// Returns: UFix64: The price of the token
        pub fun getPrice(tokenID: UInt64): UFix64? {
            return self.prices[tokenID]
        }

        /// getIDs returns an array of token IDs that are for sale
        pub fun getIDs(): [UInt64] {
            return self.prices.keys
        }

        /// borrowMoment Returns a borrowed reference to a Moment for sale
        /// so that the caller can read data from it
        ///
        /// Parameters: id: The ID of the moment to borrow a reference to
        ///
        /// Returns: &Inspirax.NFT? Optional reference to a moment for sale
        ///                        so that the caller can read its data
        ///
        pub fun borrowMoment(id: UInt64): &Inspirax.NFT? {
            // First check this collection
            if self.prices[id] != nil {
                let ref = self.ownerCollection.borrow()!.borrowMoment(id: id)
                return ref
            } else {
                return nil
            }
        }
    }

    /// createSaleCollection returns a new collection resource to the caller
    pub fun createSaleCollection(ownerCollection: Capability<&Inspirax.Collection>,
                                 ownerCapability: Capability<&{FungibleToken.Receiver}>): @SaleCollection {

        return <- create SaleCollection(ownerCollection: ownerCollection,
                                        ownerCapability: ownerCapability)
    }

    init() {
        // Set named paths
        self.marketStoragePath = /storage/InspiraxSaleCollection
        self.marketPublicPath = /public/InspiraxSaleCollection
    }
}