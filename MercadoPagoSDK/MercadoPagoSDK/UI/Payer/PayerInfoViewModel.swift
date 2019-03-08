//
//  PayerInfoViewModel.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 9/29/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

internal enum PayerInfoFlowStep: String {

    case CANCEL
    case SCREEN_IDENTIFICATION
    case SCREEN_LEGAL_NAME
    case SCREEN_NAME
    case SCREEN_LAST_NAME
    case FINISH

}

internal class PayerInfoViewModel {
    var identificationTypes: [PXIdentificationType]!
    var masks: [TextMaskFormater]!
    var currentMask: TextMaskFormater?

    var name: String = ""
    var lastName: String = ""
    var legalName: String = ""
    var identificationNumber: String = ""
    
    let payer: PXPayer!
    let amountHelper: PXAmountHelper

    var identificationType: PXIdentificationType!

    var currentStep: PayerInfoFlowStep = PayerInfoFlowStep.SCREEN_IDENTIFICATION

    init(identificationTypes: [PXIdentificationType], payer: PXPayer, amountHelper: PXAmountHelper) {
        self.payer = payer
        self.amountHelper = amountHelper
        self.identificationTypes = filterSupported(identificationTypes: identificationTypes)

        if identificationTypes.isEmpty {
            fatalError("No valid identification types for PayerInfo View Controller")
        }
        self.identificationType = identificationTypes[0]
        self.masks = Utils.getMasks(forId: self.identificationType)
        self.currentMask = masks[0]
    }

    func filterSupported(identificationTypes: [PXIdentificationType]) -> [PXIdentificationType] {
        let supportedIdentificationTypes = identificationTypes.filter {$0.id == BoletoType.cpf.rawValue || $0.id == BoletoType.cnpj.rawValue}
        return supportedIdentificationTypes
    }

    func getDropdownOptions() -> [String] {
        var options: [String] = []
        for identificationType in self.identificationTypes {
            options.append(identificationType.id!)
        }
        return options
    }

     func getNextStep() -> PayerInfoFlowStep {
        guard let type = getBoletoType() else {
            return .FINISH
        }
        
        switch type {
        case BoletoType.cpf:
            return getCPFNextStep()
        case BoletoType.cnpj:
            return getCNPJNextStep()
        }
    }
    
    func getCPFNextStep() -> PayerInfoFlowStep {
        switch currentStep {
        case .SCREEN_IDENTIFICATION:
            currentStep = .SCREEN_NAME
        case .SCREEN_NAME:
            currentStep = .SCREEN_LAST_NAME
        case .SCREEN_LAST_NAME:
            return .FINISH
        default:
            return .CANCEL
        }
        return currentStep
    }
    
    func getCNPJNextStep() -> PayerInfoFlowStep {
        switch currentStep {
        case .SCREEN_IDENTIFICATION:
            currentStep = .SCREEN_LEGAL_NAME
        case .SCREEN_LEGAL_NAME:
            return .FINISH
        default:
            return .CANCEL
        }
        return currentStep
    }

     func getPreviousStep() -> PayerInfoFlowStep {
        switch currentStep {
        case .SCREEN_IDENTIFICATION:
            return .CANCEL
        case .SCREEN_NAME:
            currentStep = .SCREEN_IDENTIFICATION
        case .SCREEN_LAST_NAME:
            currentStep = .SCREEN_NAME
        case .SCREEN_LEGAL_NAME:
            currentStep = .SCREEN_IDENTIFICATION
        default:
            return .CANCEL
        }
        return currentStep
    }

     func validateCurrentStep() -> Bool {
        switch currentStep {
        case .SCREEN_IDENTIFICATION:
            return validateIdentificationNumber()
        case .SCREEN_NAME:
            return validateName()
        case .SCREEN_LAST_NAME:
            return validateLastName()
        case .SCREEN_LEGAL_NAME:
            return validateLegalName()
        default:
            return true
        }
    }

    private func validateName() -> Bool {
        return !String.isNullOrEmpty(name)
    }

    private func validateLastName() -> Bool {
        return !String.isNullOrEmpty(lastName)
    }
    
    private func validateLegalName() -> Bool {
        return !String.isNullOrEmpty(legalName)
    }

    private func validateIdentificationNumber() -> Bool {
        let length = currentMask?.textUnmasked(identificationNumber).count
        return identificationType.minLength <= length! &&  length! <= identificationType.maxLength
    }

    func update(name: String) {
        self.name = name
    }

    func update(lastName: String) {
        self.lastName = lastName
    }
    
    func update(legalName: String) {
        self.legalName = legalName
    }

    func update(identificationNumber: String) {
        let maskedText = currentMask?.textMasked(identificationNumber, remasked: true)
        self.identificationNumber = (currentMask?.textUnmasked(maskedText))!
    }
    
    func update(identificationType: String) {
        for identificationElement in identificationTypes {
            if (identificationElement.name == identificationType) {
                self.identificationType = identificationElement
            }
        }
    }
    
    func getBoletoType() -> BoletoType? {
        return BoletoType(rawValue: identificationType.id)
    }

    func getFullName() -> String {
        if String.isNullOrEmpty(name) && String.isNullOrEmpty(lastName) {
            return ""
        } else {
            return self.name.uppercased() + " " + self.lastName.uppercased()
        }
    }

    func getMaskedNumber(completeEmptySpaces: Bool = false) -> String {
        guard let mask = self.currentMask else {
            return ""
        }
        if completeEmptySpaces {
            let maskComplete = TextMaskFormater(mask: mask.mask, completeEmptySpaces: true, leftToRight: true, completeEmptySpacesWith: "*")
            return maskComplete.textMasked(self.identificationNumber, remasked: true)
        } else {
            return mask.textMasked(self.identificationNumber, remasked: true)
        }
    }

    func getFinalPayer() -> PXPayer {
        let identification = PXIdentification(identificationType: identificationType, identificationNumber: identificationNumber)
        self.payer.identification = identification
        if let type = getBoletoType() {
            switch type {
            case .cpf:
                self.payer.firstName = name
                self.payer.lastName = lastName
                break
            case .cnpj:
                self.payer.legalName = legalName
                break
            }
        }
        return payer
    }
}
