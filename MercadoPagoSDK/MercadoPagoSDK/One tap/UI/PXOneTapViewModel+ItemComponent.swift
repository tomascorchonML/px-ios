//
//  PXOneTapViewModel+ItemComponent.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 16/05/2018.
//  Copyright © 2018 MercadoPago. All rights reserved.
//

import Foundation
extension PXOneTapViewModel {

    func getItemComponent() -> PXOneTapItemComponent? {
        let amountWithoutDiscount: Double? = isNoPayerCostAndDiscount() ? self.amountHelper.preferenceAmount : nil
        let props = PXOneTapItemComponentProps(title: getIconTitle(), collectorImage: getCollectorIcon(), numberOfInstallments: getNumberOfInstallmentsForItem(), installmentAmount: getInstallmentAmountForItem(), totalWithoutDiscount: amountWithoutDiscount, discountDescription: getDiscountDescription(), discountLimit: getDiscountLimit(), shouldShowArrow: shouldShowSummaryModal())
        return PXOneTapItemComponent(props: props)
    }

    private func getInstallmentAmountForItem() -> Double {
        // Returns intallment amount, if there isn't installments returns total amount
        if let payerCost = self.amountHelper.paymentData.payerCost {
            return payerCost.installmentAmount
        }
        return getTotalAmount()
    }

    private func getNumberOfInstallmentsForItem() -> Int? {
        if let payerCost = self.amountHelper.paymentData.payerCost {
            return payerCost.installments
        }
        return nil
    }

    private func isNoPayerCostAndDiscount() -> Bool {
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable(), self.amountHelper.discount != nil {
            // If there is more than one installment, don't show total amount without discount
            if let payerCost = self.amountHelper.paymentData.payerCost {
                return payerCost.installments == 1
            } else {
                return true
            }
        }
        return false
    }

    private func getDiscountDescription() -> String? {
        if MercadoPagoCheckoutViewModel.flowPreference.isDiscountEnable(), let discount = self.amountHelper.discount {
            return discount.getDiscountDescription()
        }
        return nil
    }

    private func getDiscountLimit() -> String? {
        // TODO: Añadir tope de descuento
        return nil
    }

    private func getCollectorIcon() -> UIImage? {
        return reviewScreenPreference.getCollectorIcon()
    }

    private func getIconTitle() -> String {
        if self.amountHelper.preference.hasMultipleItems() {
            return "Productos".localized
        } else if let firstItemTitle = self.amountHelper.preference.items.first?.title {
            return firstItemTitle
        } else {
            return "Producto".localized
        }
    }
}
