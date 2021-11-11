import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(saleID: UInt32, name: String): UFix64? {

    return InspiraxBeneficiaryCut.getStoreCutPercentage(saleID: saleID, name: name)

}