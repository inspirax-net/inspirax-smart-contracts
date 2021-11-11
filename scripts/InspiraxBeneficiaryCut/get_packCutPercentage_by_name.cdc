import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(packID: UInt32, name: String): UFix64? {

    return InspiraxBeneficiaryCut.getPackCutPercentage(packID: packID, name: name)

}