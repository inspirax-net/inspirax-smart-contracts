/**
    Description: Central Smart Contract for Inspirax Beneficiary Cut
    This smart contract stores the mappings from the names of Copyright Owners
    to the vaults in which they'd like to receive tokens,
    as well as the cut they'd like to take from store and pack sales revenue
    and marketplace transactions.
**/

import FungibleToken from "./FungibleToken.cdc"

pub contract InspiraxBeneficiaryCut {

    /// Emitted when the contract is created
    pub event ContractInitialized()

    /// Emitted when a FT-receiving capability for a copyright owner has been updated
    /// If address is nil, that means the capability has been removed
    pub event CopyrightOwnerCapabilityUpdated(name: String, address: Address?)

    /// Emitted when a copyright owner's store sale cutpercentage has been updated
    /// If the copyrightOwnerAndCutPercentage is nil, that means it has been removed.
    pub event StoreCutPercentagesUpdated(saleID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}?)

    /// Emitted when a copyright owner's pack sale cutpercentage has been updated
    /// If the copyrightOwnerAndCutPercentage is nil, that means it has been removed.
    pub event PackCutPercentagesUpdated(packID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}?)

    /// Emitted when a copyright owner's market cutpercentage has been updated
    /// If the copyrightOwnerAndCutPercentage is nil, that means it has been removed.
    pub event MarketCutPercentagesUpdated(playID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}?)

    /// Emitted when the capability of Inspirax service has been updated
    pub event InspiraxCapabilityUpdated(address: Address)

    /// Emitted when the market cutPercentage of Inspirax service has been updated
    pub event InspiraxMarketCutPercentageUpdated(cutPercentage: UFix64)

    /// Emitted when the commonweal organization has been updated
    pub event CommonwealUpdated(name: String, address: Address?, cutPercentage: UFix64)

    /// InspiraxBeneficiaryCut named path
    pub let AdminStoragePath: StoragePath

    /// Copyright Owners Capabilities
    access(self) var copyrightOwnerCapabilities: {String: Capability<&{FungibleToken.Receiver}>}

    /// Beneficiary Cut from store sales
    ///
    /// storeCutPercentages is a mapping from saleID, to copyright owner's name, to
    /// the cut percentage that they are supposed to receive.
    access(self) var storeCutPercentages: {UInt32: {String: UFix64}}

    /// Beneficiary Cut from pack sales
    ///
    /// packCutPercentages is a mapping from packID, to copyright owner's name, to
    /// the cut percentage that they are supposed to receive.
    access(self) var packCutPercentages: {UInt32: {String: UFix64}}

    /// Beneficiary Cut from marketplace transactions
    ///
    /// marketCutPercentages is a mapping from playID, to copyright owner's name, to
    /// the cut percentage that they are supposed to receive.
    access(self) var marketCutPercentages: {UInt32: {String: UFix64}}

    /// The capability of Inspirax service
    pub var inspiraxCapability: Capability<&{FungibleToken.Receiver}>
    /// The market cutPercentage of Inspirax service
    pub var inspiraxMarketCutPercentage: UFix64

    /// Commonweal organization capabilities
    access(self) var commonwealCapabilities: {String: Capability<&{FungibleToken.Receiver}>}
    /// Commonweal organization cutPercentages
    access(self) var commonwealCutPercentages: {String: UFix64}

    /// Get the boolean indicating if the Copyright Owner's name is existed or not
    pub fun isCopyrightOwnerExisted(name: String): Bool {
        return self.copyrightOwnerCapabilities.keys.contains(name)
    }

    /// Get all copyright owner names
    pub fun getAllCopyrightOwnerNames(): [String] {
        return self.copyrightOwnerCapabilities.keys
    }

    /// Get all commonweal names
    pub fun getAllCommonwealNames(): [String] {
        return self.commonwealCapabilities.keys
    }

    /// Get the amount of storeCutPercentages
    pub fun getAmountOfstoreCutPercentages(): Int {
        return self.storeCutPercentages.length
    }

    /// Get the amount of packCutPercentages
    pub fun getAmountOfpackCutPercentages(): Int {
        return self.packCutPercentages.length
    }

    /// Get the amount of marketCutPercentages
    pub fun getAmountOfmarketCutPercentages(): Int {
        return self.marketCutPercentages.length
    }

    /// Get the capability for depositing accounting tokens to the copyright owner
    pub fun getCopyrightOwnerCapability(name: String): Capability? {

        if let cap = self.copyrightOwnerCapabilities[name] {
            return cap
        } else {
            return nil
        }
    }

    /// Get the copyright owners' sale cutPercentage of the store with saleID
    pub fun getStoreCutPercentage(saleID: UInt32, name: String): UFix64? {

        if let cutPercentages = self.storeCutPercentages[saleID] {
            return cutPercentages[name]
        } else {
            return nil
        }
    }

    /// Get the copyright owners' pack cutPercentage of the pack with packID
    pub fun getPackCutPercentage(packID: UInt32, name: String): UFix64? {

        if let cutPercentages = self.packCutPercentages[packID] {
            return cutPercentages[name]
        } else {
            return nil
        }
    }

    /// Get the copyright owners' market cutPercentage of the NFT with playID
    pub fun getMarketCutPercentage(playID: UInt32, name: String): UFix64? {

        if let cutPercentages = self.marketCutPercentages[playID] {
            return cutPercentages[name]
        } else {
            return nil
        }
    }

    /// Get the copyright owners' names with saleID
    pub fun getStoreCopyrightOwnerNames(saleID: UInt32): [String] {

        return (self.storeCutPercentages[saleID] ?? panic("Cannot find saleID.")).keys

    }

    /// Get the copyright owners' names with packID
    pub fun getPackCopyrightOwnerNames(packID: UInt32): [String] {

        return (self.packCutPercentages[packID] ?? panic("Cannot find packID.")).keys

    }

    /// Get the copyright owners' names with playID
    pub fun getMarketCopyrightOwnerNames(playID: UInt32): [String] {

        return (self.marketCutPercentages[playID] ?? panic("Cannot find playID.")).keys

    }

    /// Get the capability of Inspirax service
    pub fun getInspiraxCapability(): Capability {
        return self.inspiraxCapability
    }

    /// Get the market cutPercentage of Inspirax service
    pub fun getInspiraxMarketCutPercentage(): UFix64 {
        return self.inspiraxMarketCutPercentage
    }

    /// Get the capability for depositing accounting tokens to the commonweal organization
    pub fun getCommonwealCapability(name: String): Capability? {

        if let cap = self.commonwealCapabilities[name] {
            return cap
        } else {
            return nil
        }
    }

    /// Get the cutPercentage of commonweal organization
    pub fun getCommonwealCutPercentage(name: String): UFix64? {

        if let cutPercentage = self.commonwealCutPercentages[name] {
            return cutPercentage
        } else {
            return nil
        }
    }

    pub resource Admin {

        /// Update the FT-receiving capability for a copyright owner
        pub fun setCopyrightOwnerCapability(name: String, capability: Capability<&{FungibleToken.Receiver}>?) {

            if let cap = capability {
                InspiraxBeneficiaryCut.copyrightOwnerCapabilities[name] = cap

                // Get the address behind a capability
                let addr = ((cap.borrow() ?? panic("Capability is empty."))
                    .owner ?? panic("Capability owner is empty."))
                    .address

                emit CopyrightOwnerCapabilityUpdated(name: name, address: addr)
            } else {
                InspiraxBeneficiaryCut.copyrightOwnerCapabilities.remove(key: name)

                emit CopyrightOwnerCapabilityUpdated(name: name, address: nil)
            }
        }

        /// Update the store cutpercentage for the copyright owner
        pub fun setStoreCutPercentages(saleID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}?) {

            if let cac = copyrightOwnerAndCutPercentage {

                for name in cac.keys {
                    assert(InspiraxBeneficiaryCut.isCopyrightOwnerExisted(name: name), message: "Not found Copyright Owner's name in registered.")
                }

                var total: UFix64 = 0.0
                for cutPercentage in cac.values {
                    total = total + cutPercentage
                }
                assert(total == 1.0, message: "The sum of cutPercentage must be 1.0.")

                InspiraxBeneficiaryCut.storeCutPercentages[saleID] = cac

                emit StoreCutPercentagesUpdated(saleID: saleID, copyrightOwnerAndCutPercentage: copyrightOwnerAndCutPercentage)
            } else {
                InspiraxBeneficiaryCut.storeCutPercentages.remove(key: saleID)

                emit StoreCutPercentagesUpdated(saleID: saleID, copyrightOwnerAndCutPercentage: nil)
            }
        }

        /// Update the pack cutpercentage for the copyright owner
        pub fun setPackCutPercentages(packID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}?) {

            if let cac = copyrightOwnerAndCutPercentage {

                for name in cac.keys {
                    assert(InspiraxBeneficiaryCut.isCopyrightOwnerExisted(name: name), message: "Not found Copyright Owner's name in registered.")
                }

                var total: UFix64 = 0.0
                for cutPercentage in cac.values {
                    total = total + cutPercentage
                }
                assert(total == 1.0, message: "The sum of cutPercentage must be 1.0.")

                InspiraxBeneficiaryCut.packCutPercentages[packID] = cac

                emit PackCutPercentagesUpdated(packID: packID, copyrightOwnerAndCutPercentage: copyrightOwnerAndCutPercentage)
            } else {
                InspiraxBeneficiaryCut.packCutPercentages.remove(key: packID)

                emit PackCutPercentagesUpdated(packID: packID, copyrightOwnerAndCutPercentage: nil)
            }
        }

        /// Update the market cutpercentage for the copyright owner
        pub fun setMarketCutPercentages(playID: UInt32, copyrightOwnerAndCutPercentage: {String: UFix64}?) {

            if let cac = copyrightOwnerAndCutPercentage {

                for name in cac.keys {
                    assert(InspiraxBeneficiaryCut.isCopyrightOwnerExisted(name: name), message: "Not found Copyright Owner's name in registered.")
                }

                var total: UFix64 = 0.0
                for cutPercentage in cac.values {
                    total = total + cutPercentage
                }
                total = total + InspiraxBeneficiaryCut.inspiraxMarketCutPercentage
                assert(total < 1.0, message: "The sum of cutPercentage must be less than 1.0.")

                InspiraxBeneficiaryCut.marketCutPercentages[playID] = cac

                emit MarketCutPercentagesUpdated(playID: playID, copyrightOwnerAndCutPercentage: copyrightOwnerAndCutPercentage)
            } else {
                InspiraxBeneficiaryCut.marketCutPercentages.remove(key: playID)

                emit MarketCutPercentagesUpdated(playID: playID, copyrightOwnerAndCutPercentage: nil)
            }
        }

        /// Update the capability of Inspirax service
        pub fun setInspiraxCapability(capability: Capability<&{FungibleToken.Receiver}>) {
            InspiraxBeneficiaryCut.inspiraxCapability = capability

            // Get the address behind a capability
            let addr = ((capability.borrow() ?? panic("Capability is empty."))
                .owner ?? panic("Capability owner is empty."))
                .address
            
            emit InspiraxCapabilityUpdated(address: addr)
        }

        /// Update the market cutPercentage of Inspirax service
        pub fun setInspiraxMarketCutPercentage(cutPercentage: UFix64) {

            pre{
                cutPercentage < 1.0: "The cutPercentage must be less than 1.0."
            }

            InspiraxBeneficiaryCut.inspiraxMarketCutPercentage = cutPercentage
            emit InspiraxMarketCutPercentageUpdated(cutPercentage: cutPercentage)
        }

        /// Update the capability and cutPercentage of commonweal organization
        pub fun setCommonweal(name: String, capability: Capability<&{FungibleToken.Receiver}>?, cutPercentage: UFix64) {

            pre{
                cutPercentage < 1.0: "The cutPercentage must be less than 1.0."
            }

            if let cap = capability {

                InspiraxBeneficiaryCut.commonwealCapabilities[name] = cap
                InspiraxBeneficiaryCut.commonwealCutPercentages[name] = cutPercentage

                // Get the address behind a capability
                let addr = ((cap.borrow() ?? panic("Capability is empty."))
                    .owner ?? panic("Capability owner is empty."))
                    .address

                emit CommonwealUpdated(name: name, address: addr, cutPercentage: cutPercentage)
            } else {
                InspiraxBeneficiaryCut.commonwealCapabilities.remove(key: name)
                InspiraxBeneficiaryCut.commonwealCutPercentages.remove(key: name)

                emit CommonwealUpdated(name: name, address: nil, cutPercentage: 0.0)
            }
        }
    }

    init() {
        // Set named paths
        self.AdminStoragePath = /storage/InspiraxBeneficiaryCutAdmin

        // Initialize contract fields
        self.copyrightOwnerCapabilities = {}
        self.storeCutPercentages = {}
        self.packCutPercentages = {}
        self.marketCutPercentages = {}
        self.inspiraxCapability = self.account.getCapability<&{FungibleToken.Receiver}>(/public/InspiraxUtilityCoinReceiver)
        self.inspiraxMarketCutPercentage = 0.03
        self.commonwealCapabilities = {}
        self.commonwealCutPercentages = {}

        self.account.save<@Admin>(<- create Admin(), to: self.AdminStoragePath)

        emit ContractInitialized()
    }
}