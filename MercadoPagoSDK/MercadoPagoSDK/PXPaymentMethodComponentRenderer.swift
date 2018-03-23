//
//  PXPaymentMethodComponentRenderer.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 24/11/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

class PXPaymentMethodComponentRenderer: NSObject {
    //Image
    let IMAGE_WIDTH: CGFloat = 48.0
    let IMAGE_HEIGHT: CGFloat = 48.0

    //Action Button
    let BUTTON_HEIGHT: CGFloat = 34.0
    
    let TITLE_FONT_SIZE: CGFloat = PXLayout.M_FONT
    let SUBTITLE_FONT_SIZE: CGFloat = PXLayout.XS_FONT
    let DESCRIPTION_DETAIL_FONT_SIZE: CGFloat = PXLayout.XXS_FONT
    let DISCLAIMER_FONT_SIZE: CGFloat = PXLayout.XXXS_FONT

    func render(component: PXPaymentMethodComponent) -> PXPaymentMethodView {
        let pmBodyView = PXPaymentMethodView()
        pmBodyView.backgroundColor = component.props.backgroundColor
        pmBodyView.translatesAutoresizingMaskIntoConstraints = false
        let paymentMethodIcon = component.getPaymentMethodIconComponent()
        pmBodyView.paymentMethodIcon = paymentMethodIcon.render()
        pmBodyView.paymentMethodIcon!.layer.cornerRadius = IMAGE_WIDTH/2
        pmBodyView.addSubview(pmBodyView.paymentMethodIcon!)
        PXLayout.centerHorizontally(view: pmBodyView.paymentMethodIcon!).isActive = true
        PXLayout.setHeight(owner: pmBodyView.paymentMethodIcon!, height: IMAGE_HEIGHT).isActive = true
        PXLayout.setWidth(owner: pmBodyView.paymentMethodIcon!, width: IMAGE_WIDTH).isActive = true
        PXLayout.pinTop(view: pmBodyView.paymentMethodIcon!, withMargin: PXLayout.L_MARGIN).isActive = true

        // Title
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        pmBodyView.titleLabel = title
        pmBodyView.addSubview(title)
        title.attributedText = component.props.title
        title.font = Utils.getFont(size: TITLE_FONT_SIZE)
        title.textColor = component.props.boldLabelColor
        title.textAlignment = .center
        title.numberOfLines = 0
        pmBodyView.putOnBottomOfLastView(view: title, withMargin: PXLayout.S_MARGIN)?.isActive = true
        PXLayout.pinLeft(view: title, withMargin: PXLayout.S_MARGIN).isActive = true
        PXLayout.pinRight(view: title, withMargin: PXLayout.S_MARGIN).isActive = true

        if let detailText = component.props.subtitle {
            let detailLabel = UILabel()
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.addSubview(detailLabel)
            pmBodyView.subtitleLabel = detailLabel
            detailLabel.attributedText = detailText
            detailLabel.font = Utils.getFont(size: SUBTITLE_FONT_SIZE)
            detailLabel.textColor = component.props.lightLabelColor
            detailLabel.textAlignment = .center
            PXLayout.setHeight(owner: detailLabel, height: 18.0).isActive = true
            pmBodyView.putOnBottomOfLastView(view: detailLabel, withMargin: PXLayout.XXS_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: detailLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: detailLabel, withMargin: PXLayout.XXS_MARGIN).isActive = true
        }

        if let paymentMethodDescription = component.props.descriptionTitle {
            let descriptionLabel = UILabel()
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.addSubview(descriptionLabel)
            pmBodyView.descriptionTitleLabel = descriptionLabel
            descriptionLabel.attributedText = paymentMethodDescription
            descriptionLabel.font = Utils.getFont(size: DESCRIPTION_DETAIL_FONT_SIZE)
            descriptionLabel.numberOfLines = 2
            descriptionLabel.textColor = component.props.lightLabelColor
            descriptionLabel.textAlignment = .center
            pmBodyView.putOnBottomOfLastView(view: descriptionLabel, withMargin: PXLayout.XS_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: descriptionLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
            PXLayout.pinRight(view: descriptionLabel, withMargin: PXLayout.XS_MARGIN).isActive = true
        }

        if let pmDetailText = component.props.descriptionDetail {
            let pmDetailLabel = UILabel()
            pmDetailLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.descriptionDetailLabel = pmDetailLabel
            pmBodyView.addSubview(pmDetailLabel)
            pmDetailLabel.attributedText = pmDetailText
            pmDetailLabel.font = Utils.getFont(size: DESCRIPTION_DETAIL_FONT_SIZE)
            pmDetailLabel.textColor = component.props.lightLabelColor
            pmDetailLabel.textAlignment = .center
            pmBodyView.putOnBottomOfLastView(view: pmDetailLabel, withMargin: PXLayout.XXS_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: pmDetailLabel, withMargin:  PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: pmDetailLabel, withMargin:  PXLayout.XXS_MARGIN).isActive = true
        }

        if let disclaimer = component.props.disclaimer {
            let disclaimerLabel = UILabel()
            disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
            pmBodyView.disclaimerLabel = disclaimerLabel
            pmBodyView.addSubview(disclaimerLabel)
            disclaimerLabel.attributedText = disclaimer
            disclaimerLabel.numberOfLines = 2
            disclaimerLabel.font = Utils.getFont(size: DISCLAIMER_FONT_SIZE)
            disclaimerLabel.textColor = component.props.lightLabelColor
            disclaimerLabel.textAlignment = .center
            pmBodyView.putOnBottomOfLastView(view: disclaimerLabel, withMargin: PXLayout.M_MARGIN)?.isActive = true
            PXLayout.pinLeft(view: disclaimerLabel, withMargin:  PXLayout.XS_MARGIN).isActive = true
            PXLayout.pinRight(view: disclaimerLabel, withMargin:  PXLayout.XS_MARGIN).isActive = true
        }
        
        if let action = component.props.action {
            let actionButton = PXSecondaryButton()
            actionButton.translatesAutoresizingMaskIntoConstraints = false
            actionButton.setTitle(action.label, for: .normal)
            actionButton.add(for: .touchUpInside, action.action)
            pmBodyView.actionButton = actionButton
            pmBodyView.addSubview(actionButton)
            actionButton.backgroundColor = .clear
            
            pmBodyView.putOnBottomOfLastView(view: actionButton, withMargin: PXLayout.S_MARGIN)?.isActive = true
            
            PXLayout.pinLeft(view: actionButton, withMargin:  PXLayout.XXS_MARGIN).isActive = true
            PXLayout.pinRight(view: actionButton, withMargin:  PXLayout.XXS_MARGIN).isActive = true
            PXLayout.setHeight(owner: actionButton, height: BUTTON_HEIGHT).isActive = true
        }
        
        pmBodyView.pinLastSubviewToBottom(withMargin: PXLayout.L_MARGIN)?.isActive = true

        return pmBodyView
    }
}

class PXPaymentMethodView: PXBodyView {
    var paymentMethodIcon: UIView?
    var titleLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionTitleLabel: UILabel?
    var descriptionDetailLabel: UILabel?
    var disclaimerLabel: UILabel?
    var actionButton: PXSecondaryButton?
}