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
        static let first: [UInt8] = [34, 71, 70, 124, 0, 15, 81, 83, 3, 22, 7, 123, 97, 118, 4, 83, 80, 87, 21, 122, 3, 15, 8, 42, 81, 21, 77, 98, 87, 15, 95, 18, 81, 113, 85, 71, 87, 125, 88, 91]
        static let second: [UInt8] = [114, 72, 68, 117, 85, 8, 82, 1, 83, 70, 93, 40, 53, 42, 90, 83, 87, 86, 21, 40, 86, 90, 91, 117, 12, 64, 22, 96, 83, 11, 92, 21]

    }
}
