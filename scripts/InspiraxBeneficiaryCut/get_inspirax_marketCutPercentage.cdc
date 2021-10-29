import InspiraxBeneficiaryCut from "./contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(): UFix64 {

    return InspiraxBeneficiaryCut.getInspiraxMarketCutPercentage()

}