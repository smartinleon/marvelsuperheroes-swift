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
    var shero: SuperheroEntity?

    func interactorGetData(id: Int) {
        APIClient.shared.externalGetData(id: id) { [self] data, success in
            if data != nil{
                shero = data?.first
            }

            if success && shero != nil {
                APIClient.shared.externalGetSHeroImageData(shero: shero!, completionHandler: { (data, success) in
                    if success {
                        self.shero?.thumbnail?.data = data
                    }
                    
                    presenter?.interactorPushDataPresenter(shero: shero, success: success)
                })
            } else {
                presenter?.interactorPushDataPresenter(shero: shero, success: false)
            }
        }
    }
}
