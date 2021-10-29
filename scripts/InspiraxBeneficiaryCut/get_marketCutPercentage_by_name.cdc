import InspiraxBeneficiaryCut from "./contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(playID: UInt32, name: String): UFix64? {

    return InspiraxBeneficiaryCut.getMarketCutPercentage(playID: playID, name: name)

}