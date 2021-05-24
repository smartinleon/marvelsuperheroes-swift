//
//  Constants.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//

import Foundation

struct Constants {
    
    struct urls {
        static let URL_BASE_MARVEL = "https://gateway.marvel.com:443/v1/public/"
    }
    
    struct endpoints {
        static let GET_CHARACTERS = "characters"
    }
    
    struct ObfuscatedConstants {
        static let first: [UInt8] = [34, 71, 70, 124, 0, 15, 81, 83, 3, 22, 7, 123, 97, 118, 4, 83, 80, 87, 21, 118, 50, 47, 37, 10, 81, 3, 87, 68, 115, 18, 64, 34, 81, 89, 81, 84, 87, 68, 92, 123]
        static let second: [UInt8] = [114, 72, 68, 117, 85, 8, 82, 1, 83, 70, 93, 40, 53, 42, 90, 83, 87, 86, 21, 36, 103, 122, 118, 85, 12, 86, 12, 70, 119, 22, 67, 37]

    }
}
