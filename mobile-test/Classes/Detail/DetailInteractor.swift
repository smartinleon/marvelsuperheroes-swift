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

    /// Calls the API with the superhero id to load its data
    /// - Parameter id: superhero id
    func interactorGetData(id: Int) {
        APIClient.shared.externalGetData(id: id) { [self] data, success in
            if data != nil {
                shero = data?.first
            }

            if success {
              if let superhero = shero {
                APIClient.shared.externalGetSHeroImageData(shero: superhero, completionHandler: { (data, success) in
                    if success {
                        shero?.thumbnail?.data = data
                    }

                    presenter?.interactorPushDataPresenter(shero: shero, success: success)
                })
              }else {
                presenter?.interactorPushDataPresenter(shero: shero, success: false)
              }
            } else {
                presenter?.interactorPushDataPresenter(shero: shero, success: false)
            }
        }
    }
}
