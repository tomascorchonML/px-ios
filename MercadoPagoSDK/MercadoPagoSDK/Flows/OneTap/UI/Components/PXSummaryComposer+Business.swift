//
//  PXSummaryComposer+Utils.swift
//  Bugsnag
//
//  Created by Federico Bustos Fierro on 14/05/2019.
//

import Foundation

extension PXSummaryComposer {
    func isConsumedDiscount() -> Bool {
        if let discountData = getDiscountData() {
            return discountData.discountConfiguration.getDiscountConfiguration().isNotAvailable
        }
        return false
    }

    func getDiscount() -> PXDiscount? {
        if let discountData = getDiscountData() {
            return discountData.discountConfiguration.getDiscountConfiguration().discount
        }
        return nil
    }

    func shouldDisplayCharges() -> Bool {
        return getChargesAmount() > 0
    }

    func getChargesAmount() -> Double {
        return amountHelper.chargeRuleAmount
    }

    func shouldDisplayDiscount() -> Bool {
        return getDiscountData() != nil
    }

    func getDiscountData() -> (discountConfiguration: PXDiscountConfiguration, campaign: PXCampaign)? {
        if let discountConfiguration = amountHelper.paymentConfigurationService.getDiscountConfigurationForPaymentMethodOrDefault(selectedCard?.cardId),
            let campaign = discountConfiguration.getDiscountConfiguration().campaign {
            return (discountConfiguration, campaign)
        }
        return nil
    }
}
