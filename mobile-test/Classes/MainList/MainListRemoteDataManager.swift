//
//  MainListRemoteDataManager.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import Alamofire
import CryptoKit


class MainListRemoteDataManager:MainListRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: MainListRemoteDataManagerOutputProtocol?
    let o = Obfuscator()
    
    func externalGetData(text: String, offset: Int?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: Date())
        
        let timestamp = dateFormatter.date(from: dateStr)!.timeIntervalSince1970
        let md5Diggest = (String(Int(timestamp)) + o.reveal(key: Constants.ObfuscatedConstants.first) + o.reveal(key: Constants.ObfuscatedConstants.second)).MD5
        
        var url = Constants.urls.URL_BASE_MARVEL + Constants.endpoints.GET_CHARACTERS + "?ts=\(String(Int(timestamp)))&apikey=\(o.reveal(key: Constants.ObfuscatedConstants.second))&hash=\(md5Diggest)&limit=10"
        
        if let off = offset {
            url += "&offset=\(off)"
        }
        
        if !text.isEmpty {
            let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            url += "&nameStartsWith=\(String(describing: escapedString!))"
        }
        
        //Retrieving data from marvels api
        AF.request(url, method: .get)
        .validate(contentType: ["application/json"])
        .responseData { [self] response in
            switch response.result {
            case .success:
                do{
                    let superheroData = try JSONDecoder().decode(Superhero.self, from: response.data!)
                    if let sheroResults = superheroData.data?.results {
                        remoteRequestHandler?.completionData(text: text, superheroes: sheroResults, success: true)
                    }else {
                        remoteRequestHandler?.completionData(text: text, superheroes: nil, success: false)
                    }
                }catch{
                    remoteRequestHandler?.completionData(text: text, superheroes: nil, success: false)
                }
            case .failure:
                remoteRequestHandler?.completionData(text: text, superheroes: nil, success: false)
            }
        }
    }
    
    func externalGetSHeroImageData(searched: Bool, shero: SuperheroEntity){
        guard let path = shero.thumbnail?.path, let extensionString = shero.thumbnail?.extensionString else {
            remoteRequestHandler?.completionImageData(searched: searched, imageData: nil, shero: nil, success: false)
            return
        }
        
        AF.request(path + "." + extensionString)
        .responseData { [self] response in
            if let data = response.value {
                remoteRequestHandler?.completionImageData(searched: searched, imageData: data, shero: shero, success: true)
            }else {
                remoteRequestHandler?.completionImageData(searched: searched, imageData: nil, shero: nil, success: false)
            }
        }
    }
}
