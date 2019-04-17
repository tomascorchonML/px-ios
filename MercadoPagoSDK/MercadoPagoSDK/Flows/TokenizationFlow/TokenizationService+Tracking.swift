//
//  TokenizationService+Tracking.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 12/04/2019.
//

import Foundation

extension TokenizationService {
    internal func trackInvalidESC(error: MPSDKError, cardId: String, esc_length: Int?) {
        var properties: [String: Any] = [:]
        properties["path"] = TrackingPaths.Events.getCreateTokenPath()
        properties["style"] = Tracking.Style.noScreen
        properties["id"] = Tracking.Error.Id.invalidESC
        properties["attributable_to"] = Tracking.Error.Atrributable.mercadopago

        var extraDic: [String: Any] = [:]

        extraDic["api_error"] = error.getErrorForTracking()
        extraDic["card_id"] = cardId
        extraDic["esc_length"] = esc_length
        properties["extra_info"] = extraDic
        MPXTracker.sharedInstance.trackEvent(path: TrackingPaths.Events.getErrorPath(), properties: properties)
    }
}
