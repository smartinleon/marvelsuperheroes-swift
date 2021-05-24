//
//  DetailRemoteDataManager.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import Alamofire

class DetailRemoteDataManager:DetailRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: DetailRemoteDataManagerOutputProtocol?
    let o = Obfuscator()
    
    func externalGetData(id: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateFormatter.string(from: Date())
        
        let timestamp = dateFormatter.date(from: dateStr)!.timeIntervalSince1970
        let md5Diggest = (String(Int(timestamp)) + o.reveal(key: Constants.ObfuscatedConstants.first) + o.reveal(key: Constants.ObfuscatedConstants.second)).MD5

        let url = Constants.urls.URL_BASE_MARVEL + Constants.endpoints.GET_CHARACTERS + "/\(id)" + "?ts=\(String(Int(timestamp)))&apikey=\(o.reveal(key: Constants.ObfuscatedConstants.second))&hash=\(md5Diggest)"
        
        //Retrieving data from marvels api
        AF.request(url, method: .get)
        .validate(contentType: ["application/json"])
        .responseData { [self] response in
            switch response.result {
            case .success:
                do{
                    let superheroData = try JSONDecoder().decode(Superhero.self, from: response.data!)
                    if let sheroResults = superheroData.data?.results {
                        if sheroResults.count == 1 {
                            remoteRequestHandler?.completionData(shero: sheroResults.first, success: true)
                        }else {
                            remoteRequestHandler?.completionData(shero: nil, success: false)
                        }
                    }else {
                        remoteRequestHandler?.completionData(shero: nil, success: false)
                    }
                }catch{
                    remoteRequestHandler?.completionData(shero: nil, success: false)
                }
            case .failure:
                remoteRequestHandler?.completionData(shero: nil, success: false)
            }
        }
    }
    
    func externalGetSHeroImageData(shero: SuperheroEntity){
        guard let path = shero.thumbnail?.path, let extensionString = shero.thumbnail?.extensionString else {
            remoteRequestHandler?.completionImageData(imageData: nil, success: false)
            return
        }
        
        AF.request(path + "." + extensionString)
        .responseData { [self] response in
            if let data = response.value {
                remoteRequestHandler?.completionImageData(imageData: data, success: true)
            }else {
                remoteRequestHandler?.completionImageData(imageData: nil, success: false)
            }
        }
    }
}
