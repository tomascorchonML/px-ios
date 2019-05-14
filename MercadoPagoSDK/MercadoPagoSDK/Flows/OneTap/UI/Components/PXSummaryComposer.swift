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

    //MARK: computed properties
    var summaryColor: UIColor {
        return isDefaultStatusBarStyle ? UIColor.black : ThemeManager.shared.whiteColor()
    }
    var yourPurchaseSummaryTitle: String {
        return additionalInfoSummary?.purpose ?? "onetap_purchase_summary_title".localized_beta
    }
    var yourPurchaseToShow: String {
        return Utils.getAmountFormated(amount: amountHelper.preferenceAmount, forCurrency: currency)
    }
    var discountColor: UIColor {
        return isDefaultStatusBarStyle ? ThemeManager.shared.noTaxAndDiscountLabelTintColor() : ThemeManager.shared.whiteColor()
    }
    var discountDisclaimerAlpha: CGFloat {
        return isDefaultStatusBarStyle ? 0.45 : 1.0
    }

    init(amountHelper: PXAmountHelper,
         additionalInfoSummary: PXAdditionalInfoSummary?,
         selectedCard: PXCardSliderViewModel?) {
        self.amountHelper = amountHelper
        self.additionalInfoSummary = additionalInfoSummary
        self.selectedCard = selectedCard
    }

    func getSummaryItems() -> [OneTapHeaderSummaryData] {
        updatePaymentData()
        let summaryItems = generateSummaryItems()
        return summaryItems
    }

    func generateSummaryItems() -> [OneTapHeaderSummaryData] {
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

    func updatePaymentData() {
        if let discountData = getDiscountData() {
            let discountConfiguration = discountData.discountConfiguration
            let campaign = discountData.campaign
            let discount = discountConfiguration.getDiscountConfiguration().discount
            let consumedDiscount = discountConfiguration.getDiscountConfiguration().isNotAvailable
            amountHelper.getPaymentData().setDiscount(discount, withCampaign: campaign, consumedDiscount: consumedDiscount)
        } else {
            amountHelper.getPaymentData().clearDiscount()
        }
    }
}
