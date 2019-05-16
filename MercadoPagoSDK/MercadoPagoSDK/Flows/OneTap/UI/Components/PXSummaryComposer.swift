//
//  PXSummaryComposer.swift
//  MercadoPagoSDK
//
//  Created by Federico Bustos Fierro on 13/05/2019.
//

import UIKit

class PXSummaryComposer {

    //returns the composed summary items
    var summaryItems: [OneTapHeaderSummaryData] {
        return getSummaryItems()
    }

    //MARK: constants
    let isDefaultStatusBarStyle = ThemeManager.shared.statusBarStyle() == .default
    let currency = SiteManager.shared.getCurrency()
    let summaryAlpha: CGFloat = 0.45
    let discountAlpha: CGFloat = 1

    //MARK: initialization properties
    let amountHelper: PXAmountHelper
    let additionalInfoSummary: PXAdditionalInfoSummary?
    let selectedCard: PXCardSliderViewModel?
    var internalSummary: [OneTapHeaderSummaryData] = []

    init(amountHelper: PXAmountHelper,
         additionalInfoSummary: PXAdditionalInfoSummary?,
         selectedCard: PXCardSliderViewModel?) {
        self.amountHelper = amountHelper
        self.additionalInfoSummary = additionalInfoSummary
        self.selectedCard = selectedCard
    }

    private func getSummaryItems() -> [OneTapHeaderSummaryData] {
        let summaryItems = generateSummaryItems()
        return summaryItems
    }

    private func generateSummaryItems() -> [OneTapHeaderSummaryData] {
        internalSummary = [OneTapHeaderSummaryData]()
        if shouldDisplayCharges() || shouldDisplayDiscount() {
            addPurchaseRow()
        }

        if shouldDisplayCharges() {
            addChargesRow()
        }

        if shouldDisplayDiscount() {
            if isConsumedDiscount() {
                addConsumedDiscountRow()
            } else {
                addDiscountRow()
            }
        }
        addTotalToPayRow()
        return internalSummary
    }
}
