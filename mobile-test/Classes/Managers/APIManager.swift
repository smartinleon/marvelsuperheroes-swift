//
//  APIManager.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 24/05/2021.
//

import Foundation

let sharedAPIManager = { APIManager() }()

class APIManager {
    
    lazy var baseURL: String = {
        return Constants.urls.URL_BASE_MARVEL
    }()
}
