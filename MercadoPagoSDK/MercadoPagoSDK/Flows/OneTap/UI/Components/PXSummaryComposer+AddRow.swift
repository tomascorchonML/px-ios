//
//  PXSummaryComposer+AddRow.swift
//  MercadoPagoSDK
//
//  Created by Federico Bustos Fierro on 14/05/2019.
//

import Foundation

extension PXSummaryComposer {
    func addChargesRow(){
        let amount = getChargesAmount()
        let helperImage: UIImage? = isDefaultStatusBarStyle ? ResourceManager.shared.getImage("helper_ico_gray") : ResourceManager.shared.getImage("helper_ico_light")

        let amountToShow = Utils.getAmountFormated(amount: amount, forCurrency: currency)
        let chargeText = "onetap_purchase_summary_charges".localized_beta
        let row = OneTapHeaderSummaryData(chargeText, amountToShow, summaryColor(), 1, false, helperImage)
        internalSummary.append(row)
    }

    func addConsumedDiscountRow() {
        let helperImage: UIImage? = isDefaultStatusBarStyle ? ResourceManager.shared.getImage("helper_ico_gray") : ResourceManager.shared.getImage("helper_ico_light")
        let row = OneTapHeaderSummaryData("total_row_consumed_discount".localized_beta, "", summaryColor(), discountDisclaimerAlpha(), false, helperImage)
        internalSummary.append(row)
    }

    func addDiscountRow() {
        guard let discount = getDiscount() else {
            printError("Discount is required to add the discount row")
            return
        }

        let discountToShow = Utils.getAmountFormated(amount: discount.couponAmount, forCurrency: currency)
        let helperImage: UIImage? = isDefaultStatusBarStyle ? ResourceManager.shared.getImage("helper_ico") : ResourceManager.shared.getImage("helper_ico_light")
        let row = OneTapHeaderSummaryData(discount.getDiscountDescription(),
                                          "- \(discountToShow)",
            discountColor(),
            discountAlpha,
            false,
            helperImage)
        internalSummary.append(row)
    }

    func addPurchaseRow(){
        let isTransparent = shouldDisplayDiscount() && !shouldDisplayCharges()
        let alpha = isTransparent ? summaryAlpha : 1
        let oneTapHeader = OneTapHeaderSummaryData(yourPurchaseSummaryTitle(),
                                                   yourPurchaseToShow(),
                                                   summaryColor(),
                                                   alpha,
                                                   false,
                                                   nil)
        internalSummary.append(oneTapHeader)
    }

    func addTotalToPayRow(){
        let totalAmountToShow = Utils.getAmountFormated(amount: amountHelper.getAmountToPayWithoutPayerCost(selectedCard?.cardId), forCurrency: currency)
        let totalAlpha: CGFloat = 1
        let totalColor = isDefaultStatusBarStyle ? UIColor.black : ThemeManager.shared.whiteColor()
        let text = "onetap_purchase_summary_total".localized_beta
        let oneTapHeaderSummaryData = OneTapHeaderSummaryData(text,
                                                              totalAmountToShow,
                                                              totalColor,
                                                              totalAlpha,
                                                              true,
                                                              nil)
        internalSummary.append(oneTapHeaderSummaryData)
    }

}
