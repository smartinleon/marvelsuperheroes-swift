//
//  Utils.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 20/05/2021.
//

import Foundation
import CryptoKit

class Utils {
    
}

extension String {
var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}
