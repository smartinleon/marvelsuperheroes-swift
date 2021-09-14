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

        if let idFinal = id {
            interactor?.interactorGetData(id: idFinal)
        }else {
            view?.hideAndStopSpinner()

            if let vc = view as? UIViewController {
                Utils.showErrorMessage(vc: vc, message: Utils.localizedString(key: "str_error_retrieving_data"))
            }
        }
    }

    /// Calls the Utils to load an specific url
    /// - Parameters:
    ///   - shero: data to load an specific url
    ///   - type: type of the url
    func showUrl(shero: SuperheroEntity, type: String) {
        if let urls = shero.urls {
            for urlItem in urls {
                if urlItem.type == type {
                  if let url = urlItem.url {
                        Utils.showUrl(url: url)
                        break
                    }
                }
            }
        }
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {

    /// Calls the view with the data or shows an error message
    /// - Parameters:
    ///   - shero: data of the superhero to show the detail
    ///   - success: boolean indicating if success or not
    func interactorPushDataPresenter(shero: SuperheroEntity?, success: Bool) {
        if success {
            if let superhero = shero {
                view?.showData(shero: superhero)
            }
        }else {
            if let vc = view as? UIViewController {
                Utils.showErrorMessage(vc: vc, message: Utils.localizedString(key: "str_error_retrieving_data"))
            }
        }

        view?.hideAndStopSpinner()
    }
}
