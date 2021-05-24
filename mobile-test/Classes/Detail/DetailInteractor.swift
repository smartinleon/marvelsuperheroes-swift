//
//  DetailInteractor.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation

class DetailInteractor: DetailInteractorInputProtocol {

    // MARK: Properties
    weak var presenter: DetailInteractorOutputProtocol?
    var localDatamanager: DetailLocalDataManagerInputProtocol?
    var remoteDatamanager: DetailRemoteDataManagerInputProtocol?
    var shero: SuperheroEntity?

    func interactorGetData(id: Int) {
        remoteDatamanager!.externalGetData(id: id)
    }
}

extension DetailInteractor: DetailRemoteDataManagerOutputProtocol {
    
    func completionData(shero: SuperheroEntity?, success: Bool) {
        if success && shero != nil {
            self.shero = shero
            remoteDatamanager?.externalGetSHeroImageData(shero: shero!)
        } else {
            presenter?.interactorPushDataPresenter(shero: shero, success: false)
        }
    }
    
    func completionImageData(imageData: Data?, success: Bool) {
        if success && shero != nil {
            self.shero?.thumbnail?.data = imageData
        }
        
        presenter?.interactorPushDataPresenter(shero: shero, success: success)
    }
}
