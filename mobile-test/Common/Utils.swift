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

    /// Shows alert with the message passed by parameter
    /// - Parameters:
    ///   - vc: viewcontroller in which the alertview will be presented
    ///   - message: message of the alert
    static func showErrorMessage(vc: UIViewController, message: String) {
        let alert = UIAlertController.init(title: "Atención", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }

    /// Gets the height of the label in base of the text
    /// - Parameters:
    ///   - text: text of the label
    ///   - font: font of the label
    ///   - width: width of the label
    /// - Returns: height of the label
    static func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

    /// Shows the url passed by parameter
    /// - Parameter url: url to load
    static func showUrl(url: String){
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

    /// Returns the localized string in base of the key
    /// - Parameter key: key of the localized string
    /// - Returns: string localized
    static func localizedString(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension String {
  var MD5: String {
      guard let d = data(using: .utf8) else {
          return ""
      }

      let computed = Insecure.MD5.hash(data: d)
      return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension UIView {

    func setCornerRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
