//
//  Utils.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 20/05/2021.
//

import Foundation
import UIKit
import CryptoKit

class Utils {
    static func showErrorMessage(vc: UIViewController, message: String) {
        let alert = UIAlertController.init(title: "Atención", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
    
    static func showUrl(url: String){
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func localizedString(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UIView {
    func setCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
}
