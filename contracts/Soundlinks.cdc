/**
    Description: Central Smart Contract for Soundlinks
    This smart contract contains the core functionality for Soundlinks.
**/

pub contract Soundlinks {

    // -----------------------------------------------------------------------
    // Soundlinks Contract Events
    // -----------------------------------------------------------------------

    /// Emitted when the Soundlinks contract is created
    pub event ContractInitialized()

    /// Events for DNA-Related actions
    ///
    /// Emitted when a new DNA is created
    pub event DNACreated(id: UInt64, hash: String)
    /// Emitted when DNAs are destroyed
    pub event DNABurned(amount: UInt32)

    /// Events for Admin-Related actions
    ///
    /// Emitted when a new minter resource is created
    pub event MinterCreated(amount: UInt32)
    /// Emitted when a new burner resource is created
    pub event BurnerCreated()

    /// Events for Collection-Related actions
    ///
    /// Emitted when a DNA is withdrawn from a Collection
    pub event Withdraw(id: UInt64, from: Address?)
    /// Emitted when a DNA is deposited into a Collection
    pub event Deposit(id: UInt64, to: Address?)

    // -----------------------------------------------------------------------
    // Soundlinks Named Paths
    // -----------------------------------------------------------------------

    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let AdminStoragePath: StoragePath

    // -----------------------------------------------------------------------
    // Soundlinks Contract-Level Fields
    // -----------------------------------------------------------------------

    /// Total supply of Soundlinks DNAs in existence
    pub var totalSupply: UInt64

    // -----------------------------------------------------------------------
    // Soundlinks Contract-Level Composite Type Definitions
    // -----------------------------------------------------------------------

    /// The resource that represents the Soundlinks DNAs
    ///
    pub resource DNA {

        /// The unique ID for the DNA
        pub let id: UInt64

        /// The hash for the DNA
        pub let hash: String

        init(hash: String) {
            pre {
                hash.length > 0: "New DNA hash cannot be empty."
            }

            // Increment the global Soundlinks DNA IDs
            Soundlinks.totalSupply = Soundlinks.totalSupply + (1 as UInt64)

            self.id = Soundlinks.totalSupply

            self.hash = hash

            emit DNACreated(id: self.id, hash: hash)
        }
    }

    /// This is the interface that users can cast their Soundlinks DNA Collection
    ///
    pub resource interface CollectionPublic {
        pub fun deposit(dna: @DNA)
        pub fun batchDeposit(dnas: @Collection)
        pub fun getAmount(): UInt32
    }

    /// Collection is a resource that every user who owns Soundlinks DNAs
    ///
    pub resource Collection: CollectionPublic {

        /// ownedDNAs Array store DNAs
        access(self) var ownedDNAs: @[DNA]

        init() {
            self.ownedDNAs <- []
        }

        /// withdraw removes a Soundlinks DNA from the Collection and moves it to the caller
        ///
        /// Returns: @DNA the resource that was withdrawn
        ///
        pub fun withdraw(): @DNA {

            pre {
                self.getAmount() > 0: "Cannot withdraw: Not enough DNAs in the Collection."
            }

            let dna <- self.ownedDNAs.removeFirst()

            emit Withdraw(id: dna.id, from: self.owner?.address)

            // Return the withdrawn dna
            return <- dna
        }

        /// batchWithdraw withdraws multiple DNAs and returns them as a Collection
        ///
        /// Parameters: quantity: the quantity for withdraw
        ///
        /// Returns: @Collection: A Collection that contains the withdrawn DNAs
        ///
        pub fun batchWithdraw(quantity: UInt32): @Collection {

            // Create a new empty Collection
            var batchCollection <- create Collection()

            var i: UInt32 = 0
            // Withdraw DNAs by quantity from the Collection
            while i < quantity {
                batchCollection.deposit(dna: <-self.withdraw())
                i = i + (1 as UInt32)
            }

            // Return the withdrawn DNAs
            return <-batchCollection
        }

        /// deposit takes a Soundlinks DNA and adds it to the Collection Array
        ///
        /// Paramters: dna: the DNA to be deposited in the Collection
        ///
        pub fun deposit(dna: @DNA) {

            // Get the DNA's ID
            let id = dna.id

            // Add the new DNA to the Array
            self.ownedDNAs.append(<- dna)

            // Only emit a deposit event if the Collection
            // is in an account's storage
            if self.owner?.address != nil {
                emit Deposit(id: id, to: self.owner?.address)
            }
        }

        /// batchDeposit takes a Collection object as an argument
        /// and deposits each contained DNA into this Collection
        ///
        /// Paramters: dnas: the DNAs Collection
        ///
        pub fun batchDeposit(dnas: @Collection) {

            // Get the length of the ownedDNAs Array to be deposited
            let amount = dnas.getAmount()

            var i: UInt32 = 0
            // Withdraw DNAs from the Collection and deposit each one
            while i < amount {
                self.deposit(dna: <-dnas.withdraw())
                i = i + (1 as UInt32)
            }

            // Destroy the empty Collection
            destroy dnas
        }

        /// getAmount returns the amount of the DNAs that are in the Collection
        ///
        pub fun getAmount(): UInt32 {
            return UInt32(self.ownedDNAs.length)
        }

        /// If a transaction destroys the Collection object,
        /// All the DNAs contained within are also destroyed!
        ///
        destroy() {
            let amount = self.getAmount()
            destroy self.ownedDNAs
            emit DNABurned(amount: amount)
       }
    }

    /// Admin is a special authorization resource that
    /// allows the owner to perform important functions about DNA
    ///
    pub resource Admin {

        /// createNewMinter
        ///
        /// Function that creates and returns a new minter resource
        ///
        pub fun createNewMinter(hashs: [String]): @Minter {
            let amount = UInt32(hashs.length)
            emit MinterCreated(amount: amount)
            return <-create Minter(hashs: hashs)
        }

        /// createNewBurner
        ///
        /// Function that creates and returns a new burner resource
        ///
        pub fun createNewBurner(): @Burner {
            emit BurnerCreated()
            return <-create Burner()
        }

        /// createNewAdmin
        ///
        /// Function that creates a new Admin resource
        ///
        pub fun createNewAdmin(): @Admin {
            return <-create Admin()
        }
    }

    /// Minter
    ///
    /// Resource object that Soundlinks DNA admin accounts can hold to mint new DNAs.
    ///
    pub resource Minter {

        /// The hash of DNAs that the minter is allowed to mint
        access(self) var hashs: [String]

        /// mintDNAs mints an arbitrary quantity of DNAs
        /// and returns them as a Collection
        ///
        /// Parameters: quantity: the quantity of DNAs to be minted
        ///
        /// Returns: Collection object that contains all the DNAs that were minted
        ///
        pub fun mintDNAs(quantity: UInt32): @Collection {

            pre {
                quantity > 0: "Quantity minted must be greater than zero."
                quantity <= UInt32(self.hashs.length): "Quantity minted must be less than the amount of DNA's hashs."
            }

            // Create a new empty Collection
            var batchCollection <- create Collection()

            var i: UInt32 = 0
            while i < quantity {
                batchCollection.deposit(dna: <- create DNA(hash: self.hashs.removeFirst()))
                i = i + (1 as UInt32)
            }

            return <-batchCollection
        }

        init(hashs: [String]) {
            self.hashs = hashs
        }
    }

    /// Burner
    ///
    /// Resource object that Soundlinks DNA admin accounts can hold to burn DNAs.
    ///
    pub resource Burner {

        /// burnDNAs
        ///
        /// Function that destroys a Collection instance, effectively burning the DNAs.
        ///
        pub fun burnDNAs(from: @Collection) {
            let collection <- from
            let amount = collection.getAmount()
            destroy collection
            emit DNABurned(amount: amount)
        }
    }

    // -----------------------------------------------------------------------
    // Soundlinks Contract-Level Function Definitions
    // -----------------------------------------------------------------------

    /// createEmptyCollection creates a new, empty Collection object so that
    /// a user can store it in their account storage.
    /// Once they have a Collection in their storage, they are able to receive
    /// Soundlinks DNA in transactions.
    ///
    pub fun createEmptyCollection(): @Collection {

        post {
            result.getAmount() == 0: "The created collection must be empty!"
        }

        return <-create Soundlinks.Collection()
    }

    // -----------------------------------------------------------------------
    // Soundlinks Initialization Function
    // -----------------------------------------------------------------------

    init() {
        // Set named paths
        self.CollectionStoragePath = /storage/SoundlinksCollection
        self.CollectionPublicPath = /public/SoundlinksCollection
        self.AdminStoragePath = /storage/SoundlinksAdmin

        // Initialize contract fields
        self.totalSupply = 0

        self.account.save<@Admin>(<- create Admin(), to: self.AdminStoragePath)

        emit ContractInitialized()
    }
}