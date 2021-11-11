import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(): Int {

    return InspiraxBeneficiaryCut.getSaleIDsInStoreCutPercentages().length

}