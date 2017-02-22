//
//  PaymentResultViewModel.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 2/22/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import Foundation

class PaymentResultViewModel : NSObject, MPPaymentTrackInformer {
    
    var paymentResult: PaymentResult!
    var callback: ( _ status : MPStepBuilder.CongratsState) -> Void
    var checkoutPreference: CheckoutPreference?
    
    init(paymentResult: PaymentResult, checkoutPreference: CheckoutPreference, callback : @escaping ( _ status : MPStepBuilder.CongratsState) -> Void) {
        
        self.paymentResult = paymentResult
        self.callback = callback
        self.checkoutPreference = checkoutPreference
    }
    open func methodId() -> String!{
        return paymentResult.paymentData?.paymentMethod._id ?? ""
    }
    
    open func status() -> String!{
        return paymentResult.status
    }
    
    open func statusDetail() -> String!{
        return paymentResult.statusDetail
    }
    
    open func typeId() -> String!{
        return paymentResult.paymentData?.paymentMethod.paymentTypeId ?? ""
    }
    
    open func installments() -> String! {
        return String(describing: paymentResult.paymentData?.payerCost?.installments)
    }
    
    open func issuerId() -> String!{
        return String(describing: paymentResult.paymentData?.issuer?._id)
    }
    
    func getColor() -> UIColor{
        if approved() {
            return UIColor(red: 59, green: 194, blue: 128)
        } else if inProcess() {
            return UIColor(red: 255, green: 161, blue: 90)
        } else if callForAuth() {
            return UIColor(red: 58, green: 184, blue: 239)
        } else if rejected(){
            return UIColor(red: 255, green: 89, blue: 89)
        }
        return UIColor()
    }
    
    func callForAuth() ->Bool{
        if self.paymentResult.statusDetail == "cc_rejected_call_for_authorize" {
            return true
        } else {
            return false
        }
    }
    
    func approved() -> Bool{
        if self.paymentResult.status == PaymentStatus.APPROVED.rawValue {
            return true
        } else {
            return false
        }
    }
    func inProcess() -> Bool{
        if self.paymentResult.status == PaymentStatus.IN_PROCESS.rawValue {
            return true
        } else {
            return false
        }
    }
    func rejected() -> Bool{
        if self.paymentResult.status == PaymentStatus.REJECTED.rawValue {
            return true
        } else {
            return false
        }
    }
    internal func getLayoutName() -> String! {
        
        if paymentResult.status == PaymentStatus.REJECTED.rawValue {
            if paymentResult.statusDetail == "cc_rejected_call_for_authorize" {
                return "authorize" //C4A
            } else if paymentResult.statusDetail.contains("cc_rejected_bad_filled")  {
                return "recovery" //bad fill something
            }
        }
        
        return paymentResult.status
    }
    
    func setCallbackWithTracker(cellName: String) -> (_ paymentResult : PaymentResult, _ status : MPStepBuilder.CongratsState) -> Void{
        let callbackWithTracker : (_ paymentResutl : PaymentResult, _ status : MPStepBuilder.CongratsState) -> Void = {(paymentResult ,status) in
            let paymentAction: PaymentActions
            if self.paymentResult.statusDetail.contains("cc_rejected_bad_filled"){
                paymentAction = PaymentActions.RECOVER_PAYMENT
            } else if paymentResult.status == PaymentStatus.REJECTED.rawValue{
                paymentAction = PaymentActions.SELECTED_OTHER_PM
            } else if cellName == "rejected" {
                paymentAction = PaymentActions.RECOVER_PAYMENT
            } else {
                paymentAction = PaymentActions.RECOVER_TOKEN
            }
            MPTracker.trackEvent(MercadoPagoContext.sharedInstance, screen: self.getLayoutName(), action: paymentAction.rawValue, result: nil)
            self.callback(status)
        }
        return callbackWithTracker
    }
    enum PaymentStatus : String {
        case APPROVED = "approved"
        case REJECTED = "rejected"
        case RECOVERY = "recovery"
        case IN_PROCESS = "in_process"
    }
    enum PaymentActions : String {
        case RECOVER_PAYMENT = "RECOVER_PAYMENT"
        case RECOVER_TOKEN = "RECOVER_TOKEN"
        case SELECTED_OTHER_PM = "SELECT_OTHER_PAYMENT_METHOD"
    }
    
    func isHeaderCellFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func isFooterCellFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 4
    }
    
    func isApprovedBodyCellFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row == 0 && approved()
    }
    
    func isEmailCellFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row == 1 && approved()
    }
    
    func isCallForAuthFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row == 0 && callForAuth()
    }
    func isSelectOtherPaymentMethodCellFor(indexPath: IndexPath) -> Bool {
        return !MercadoPagoCheckoutViewModel.paymentResultScreenPreference.isSelectAnotherPaymentMethodDisableCell() && indexPath.section == 1 && (rejected() || inProcess() || (indexPath.row == 1 && callForAuth()))
    }
    
    func isAdditionalCustomCellFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
    func isSecondaryExitButtonCellFor(indexPath: IndexPath) -> Bool {
        return indexPath.section == 3
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == 1 {
            return numberOfCellInBody()
        } else if section == 2 {
            return numberOfCustomAdditionalCells()
        }
        return 1
    }
    
    func numberOfCellInBody() -> Int {
        let selectAnotherCell = !MercadoPagoCheckoutViewModel.paymentResultScreenPreference.isSelectAnotherPaymentMethodDisableCell() ? 1 : 0
        if approved() {
            return !String.isNullOrEmpty(paymentResult.payerEmail) ? 2 : 1
            
        } else if callForAuth() {
            return selectAnotherCell + 1
        }
        
        return selectAnotherCell
    }
    
    func numberOfCustomAdditionalCells() -> Int {
        if !Array.isNullOrEmpty(PaymentResultScreenPreference.pendingAdditionalInfoCells) && inProcess(){
            return PaymentResultScreenPreference.pendingAdditionalInfoCells.count
        } else if !Array.isNullOrEmpty(PaymentResultScreenPreference.approvedAdditionalInfoCells) && approved() {
            return PaymentResultScreenPreference.approvedAdditionalInfoCells.count
        }
        return 0
    }
}

enum PaymentStatus : String {
    case APPROVED = "approved"
    case REJECTED = "rejected"
    case RECOVERY = "recovery"
    case IN_PROCESS = "in_process"
}

