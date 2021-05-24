//
//  DetailPresenter.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

class DetailPresenter: DetailPresenterProtocol{
    
    // MARK: Properties
    weak var view: DetailViewProtocol?
    var id: Int?
    var interactor: DetailInteractorInputProtocol?
    var wireFrame: DetailWireFrameProtocol?
    
    func viewDidLoad() {
        view?.setupView()
        view?.showSpinner()
        interactor?.interactorGetData(id: id!)
    }
    
    func showUrl(shero: SuperheroEntity, type: String) {
//        Shows an specific url
        if shero.urls != nil {
            for urlItem in shero.urls! {
                if urlItem.type == type {
                    Utils.showUrl(url: urlItem.url!)
                    break
                }
            }
        }
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    
    func interactorPushDataPresenter(shero: SuperheroEntity?, success: Bool) {
//        Calls the view with the data or shows an error message
        if success && shero != nil{
            view?.showData(shero: shero!)
        }else {
            if let vc = view as? UIViewController {
                Utils.showErrorMessage(vc: vc, message: Utils.localizedString(key: "str_error_retrieving_data"))
            }
        }

        view?.hideAndStopSpinner()
    }
}
