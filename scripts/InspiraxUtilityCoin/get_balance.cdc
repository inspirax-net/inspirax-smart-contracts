import FungibleToken from "../../contracts/FungibleToken.cdc"
import InspiraxUtilityCoin from "../../contracts/InspiraxUtilityCoin.cdc"

pub fun main(address: Address): UFix64 {

    let account = getAccount(address)
    
    let vaultRef = account.getCapability(InspiraxUtilityCoin.BalancePublicPath)!
        .borrow<&InspiraxUtilityCoin.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}