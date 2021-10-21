import InspiraxMarket from "./contracts/InspiraxMarket.cdc"
import FungibleToken from "./contracts/FungibleToken.cdc"

transaction(receiverPath: PublicPath) {

    prepare(acct: AuthAccount) {

        let inspiraxSaleCollection = acct.borrow<&InspiraxMarket.SaleCollection>(from: InspiraxMarket.marketStoragePath)
            ?? panic("Could not borrow from sale in storage")

        inspiraxSaleCollection.changeOwnerReceiver(acct.getCapability<&{FungibleToken.Receiver}>(receiverPath))
    }
}