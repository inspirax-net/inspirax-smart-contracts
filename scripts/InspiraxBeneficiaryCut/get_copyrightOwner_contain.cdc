import InspiraxBeneficiaryCut from "../../contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(name: String): Bool {

    return InspiraxBeneficiaryCut.getAllCopyrightOwnerNames().contains(name)

}