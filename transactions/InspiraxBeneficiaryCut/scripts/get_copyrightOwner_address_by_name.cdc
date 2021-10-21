import InspiraxBeneficiaryCut from "./contracts/InspiraxBeneficiaryCut.cdc"

pub fun main(name: String): Address {

    return InspiraxBeneficiaryCut.getCopyrightOwnerCapability(name: name)!.address

}