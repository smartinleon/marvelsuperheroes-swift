//
//  APIClient.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 24/05/2021.
//

import Foundation
import Alamofire

class APIClient {
    
    var baseURL: String
    let o = Obfuscator()

    static let shared = { APIClient(url: APIManager.shared.baseURL) }()
    
    required init(url: String){
        self.baseURL = url
    }
    
    func externalGetData(id: Int? = nil, text: String? = "", offset: Int? = nil, completionHandler: @escaping (_ data: [SuperheroEntity]?, _ success: Bool) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: Date())
        
        let timestamp = dateFormatter.date(from: dateStr)!.timeIntervalSince1970
        let md5Diggest = (String(Int(timestamp)) + o.reveal(key: Constants.ObfuscatedConstants.first) + o.reveal(key: Constants.ObfuscatedConstants.second)).MD5

        var url = baseURL + Constants.endpoints.GET_CHARACTERS
        
        if let idShero = id {
            url += "/\(idShero)"
        }
        
        url += "?ts=\(String(Int(timestamp)))&apikey=\(o.reveal(key: Constants.ObfuscatedConstants.second))&hash=\(md5Diggest)&limit=10"
        
        if let off = offset {
            url += "&offset=\(off)"
        }
        
        if let textSheroes = text {
            if !textSheroes.isEmpty {
                let escapedString = textSheroes.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                url += "&nameStartsWith=\(String(describing: escapedString!))"
            }
        }
        
        //Retrieving data from marvels api
        AF.request(url, method: .get)
        .validate(contentType: ["application/json"])
        .responseData { response in
            switch response.result {
            case .success:
                do{
                    let superheroData = try JSONDecoder().decode(Superhero.self, from: response.data!)
                    if let sheroResults = superheroData.data?.results {
                        completionHandler(sheroResults, true)
                    }else {
                        completionHandler(nil, false)
                    }
                }catch{
                    completionHandler(nil, false)
                }
            case .failure:
                completionHandler(nil, false)
            }
        }
    }
    
    func externalGetSHeroImageData(shero: SuperheroEntity, completionHandler: @escaping (_ data: Data?, _ success: Bool) -> Void) {
        guard let path = shero.thumbnail?.path, let extensionString = shero.thumbnail?.extensionString else {
            completionHandler(nil, false)
            return
        }
        
        AF.request(path + "." + extensionString)
        .responseData { response in
            if let data = response.value {
                completionHandler(data, true)
            }else {
                completionHandler(nil, false)
            }
        }
    }
}
