//
//  MercadoPagoESCImplementation.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 7/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

#if PX_PRIVATE_POD
    import MLESCManager
#endif

@objcMembers
internal class PXESCManager: NSObject, MercadoPagoESC {

    private var isESCEnabled: Bool = false

    init(enabled: Bool) {
        isESCEnabled = enabled
    }

    func hasESCEnable() -> Bool {
        #if PX_PRIVATE_POD
            return isESCEnabled
         #else
            return false
         #endif
    }

    func getESC(cardId: String, firstSixDigits: String, lastFourDigits: String) -> String? {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
            let esc = MLESCManager.getESC(cardId: cardId, firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits)
            return esc
            #endif
        }
        return nil
    }

    @discardableResult
    func saveESC(cardId: String, esc: String) -> Bool {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
               return MLESCManager.saveESC(cardId: cardId, esc: esc)
            #endif
        }
        return false
    }

    @discardableResult
    func saveESC(firstSixDigits: String, lastFourDigits: String, esc: String) -> Bool {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
            return MLESCManager.saveESC(esc: esc, firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits)
            #endif
        }
        return false
    }

    func deleteESC(cardId: String) {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
                MLESCManager.deleteESC(cardId: cardId)
            #endif
        }
    }

    func deleteESC(firstSixDigits: String, lastFourDigits: String) {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
            MLESCManager.deleteESC(firstSixDigits: firstSixDigits, lastFourDigits: lastFourDigits)
            #endif
        }
    }

    func deleteAllESC() {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
                MLESCManager.deleteAllESC()
            #endif
        }
    }

    func getSavedCardIds() -> [String] {
        if hasESCEnable() {
            #if PX_PRIVATE_POD
               return MLESCManager.getSavedCardIds()
            #endif
        }
        return []
    }
}
