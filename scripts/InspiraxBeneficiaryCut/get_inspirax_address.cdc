import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(): Address {

    return InspiraxBeneficiaryCut.inspiraxCapability.address

}