import InspiraxBeneficiaryCut from "./contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(name: String): UFix64? {

    return InspiraxBeneficiaryCut.getCommonwealCutPercentage(name: name)

}