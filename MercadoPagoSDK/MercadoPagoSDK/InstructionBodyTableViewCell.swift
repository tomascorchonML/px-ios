//
//  InstructionBodyTableViewCell.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 11/6/16.
//  Copyright © 2016 MercadoPago. All rights reserved.
//

import UIKit

class InstructionBodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottom: UILabel!
    @IBOutlet weak var view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func fillCell(instruction: Instruction?, payment: Payment){
        if let instruction = instruction{
            var height = 30
            var previus: UIView?
            var constrain = 0
            for (index, info) in instruction.info.enumerated() {
                previus = UIView()
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                label.textAlignment = .center
                let descriptionAttributes: [String:AnyObject]
                if index == 2 || index == 3 || index == 4 {
                    descriptionAttributes = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 16) ?? UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName: UIColor.gray]
                } else {
                    descriptionAttributes = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 18) ?? UIFont.systemFont(ofSize: 18),NSForegroundColorAttributeName: UIColor.gray]
                }
                
                let myAttrString = NSAttributedString(string: info, attributes: descriptionAttributes)
                label.numberOfLines = 3
                label.attributedText = myAttrString
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let views = ["label": label]
                self.view.addSubview(label)
                
                let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[label]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                let heightConstraints:[NSLayoutConstraint]
                //let heightConstraints2:[NSLayoutConstraint]
                if index == 0{
                    
                    
                    heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    //heightConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(40)-[label]-(40)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                }
                    
                    
                else {
                    
                    if index+1 != instruction.info.count && instruction.info[index-1] != ""{
                        heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)]
                        constrain = 0
                    } else if index == 6 {
                        heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 60)]

                        constrain = 60
                    } else {
                        heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                        constrain = 30
                        
                    }
                    
                }
                previus = label
                NSLayoutConstraint.activate(widthConstraints)
                NSLayoutConstraint.activate(heightConstraints)
                if index == 4{
                    ViewUtils.drawBottomLine(y: CGFloat(label.frame.maxY), width: UIScreen.main.bounds.width, inView: self.view)
                }
                //NSLayoutConstraint.activate(heightConstraints2)
                
                
                height += Int(label.frame.height) + constrain
                
            }
            for refence in instruction.references {
                var i = 0
                if let labelText = refence.label{
                    var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                    label.textAlignment = .center
                    let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.gray]
                    let myAttrString = NSAttributedString(string: String(describing: labelText), attributes: descriptionAttributes)
                    label.numberOfLines = 3
                    label.attributedText = myAttrString
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.sizeToFit()
                    
                    let views = ["label": label]
                    self.view.addSubview(label)
                    
                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[label]-(20)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    let heightConstraints:[NSLayoutConstraint]
                    //let heightConstraints2:[NSLayoutConstraint]
                    
                    if  previus != nil {
                    heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                    } else {
                        heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(30)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    }
                    
                    
                    previus = label
                    NSLayoutConstraint.activate(widthConstraints)
                    NSLayoutConstraint.activate(heightConstraints)
                    height += Int(label.frame.height) + 30
                    i += 1
                }
                
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                label.textAlignment = .center
                let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 20) ?? UIFont.systemFont(ofSize: 20),NSForegroundColorAttributeName: UIColor.black]
                let myAttrString = NSAttributedString(string: String(describing: refence.getFullReferenceValue()), attributes: descriptionAttributes)
                label.numberOfLines = 3
                label.attributedText = myAttrString
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let views = ["label": label]
                self.view.addSubview(label)
                let widthConstraints:[NSLayoutConstraint]

                if payment.paymentMethodId == "redlink"{
                    widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[label]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                } else {
                    widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[label]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                }
                let heightConstraints:[NSLayoutConstraint]
                //let heightConstraints2:[NSLayoutConstraint]
                
                heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 1)]
                
                
                previus = label
                NSLayoutConstraint.activate(widthConstraints)
                NSLayoutConstraint.activate(heightConstraints)
                
                height += Int(label.frame.height) + 1
                
            }
            if instruction.accreditationMessage != "" {
                
                var label = UILabel(frame: CGRect(x: 0, y: height, width: 200, height: 0))
                label.textAlignment = .center
                let descriptionAttributes: [String:AnyObject] = [NSFontAttributeName : UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 12) ?? UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName: UIColor.gray]
                let myAttrString = NSAttributedString(string: String(describing: instruction.accreditationMessage), attributes: descriptionAttributes)
                label.numberOfLines = 3
                label.attributedText = myAttrString
                label.translatesAutoresizingMaskIntoConstraints = false
                label.sizeToFit()
                
                let image = UIImageView(frame: CGRect(x: 0, y: height, width: 16, height: 16))
                image.image = MercadoPago.getImage("iconTime")
                image.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(image)
                
                let views = ["label": label, "image": image] as [String : Any]
                self.view.addSubview(label)
                
                let widthConstraints:[NSLayoutConstraint]
                

                widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[image]-[label]-\((UIScreen.main.bounds.width - label.frame.width - 16)/2)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)

                let heightConstraints:[NSLayoutConstraint]
                
                
                heightConstraints = [NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                NSLayoutConstraint.activate(widthConstraints)
                NSLayoutConstraint.activate(heightConstraints)
                
                
                let verticalConstraint = NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
                //let widthConstraints2 = [NSLayoutConstraint(item: image, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)]
                view.addConstraint(verticalConstraint)
                //NSLayoutConstraint.activate(widthConstraints2)
                
                previus = label
            }
            if instruction.actions != nil && (instruction.actions?.count)! > 0 {
                if instruction.actions![0].tag == ActionTag.LINK.rawValue {
                    let button = UIButton(frame: CGRect(x: 0, y: height, width: 160, height: 30))
                    //button.actionLink = instruction.actions![0].url
                    button.titleLabel?.font = UIFont(name: MercadoPago.DEFAULT_FONT_NAME, size: 16) ?? UIFont.systemFont(ofSize: 16)
                    button.setTitle(instruction.actions![0].label, for: .normal)
                    button.setTitleColor(UIColor(red: 0, green: 158, blue: 227), for: .normal)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    self.method = {
                        UIApplication.shared.openURL(URL(string: instruction.actions![0].url)!)
                    }
                    button.addTarget(self, action: #selector(setter: method), for: .touchUpInside)
                    self.view.addSubview(button)
                    let views = ["button": button]
                    let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(60)-[button]-(60)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
                    let heightConstraints:[NSLayoutConstraint]
                    
                    
                    heightConstraints = [NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: previus, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 30)]
                    NSLayoutConstraint.activate(widthConstraints)
                    NSLayoutConstraint.activate(heightConstraints)
                    previus = button
                }
            }
            
        let views = ["label": previus]
            let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            NSLayoutConstraint.activate(heightConstraints)
            
        }
        
    }

    var method : ((Void)->Void)!
    
}
