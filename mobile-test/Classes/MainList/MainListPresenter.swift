//
//  MainListPresenter.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation

class MainListPresenter  {
    
    // MARK: Properties
    weak var view: MainListViewProtocol?
    var interactor: MainListInteractorInputProtocol?
    var wireFrame: MainListWireFrameProtocol?
    
}

extension MainListPresenter: MainListPresenterProtocol {
    func filterData(text: String, data: [SuperheroEntity]) {
        if text.isEmpty {
            interactor?.interactorGetData(text: "", offset: nil)
        }
    }
    
    // TODO: implement presenter methods
    func viewDidLoad() {
        interactor?.interactorGetData(text: "", offset: nil)
        view?.showSpinner()
    }
    
    func loadImageData(searched: Bool, shero: SuperheroEntity) {
        interactor?.interactorGetImageData(searched: searched, shero: shero)
    }
    
    func searchData(text: String, offset: Int?) {
        interactor?.interactorGetData(text: text, offset: offset)
        view?.showSpinner()
    }
    
    func showFilters() {
        view?.showFilters()
    }
    
    func showDetailView(data: SuperheroEntity) {
        wireFrame?.presentNewViewDetail(view: view!, data: data)
    }
}

extension MainListPresenter: MainListInteractorOutputProtocol {
    // TODO: implement interactor output methods
    func interactorPushDataPresenter(superheros: [SuperheroEntity]?, success: Bool) {
        if success && superheros != nil && superheros!.count > 0{
            view?.showData(superheros: superheros!)
        }else if success && superheros != nil && superheros!.count == 0 {
            view?.showErrorMessage(message: "No hay más datos a mostrar")
        }else {
            view?.showErrorMessage(message: "Se ha producido un error recuperando los datos")
        }
        
        view?.hideAndStopSpinner()
    }
    
    func interactorPushUpdatedDataPresenter(superheros: [SuperheroEntity]?, success: Bool) {
        if success && superheros != nil && superheros!.count > 0{
            view?.updateData(superheros: superheros!)
        }else if success && superheros != nil && superheros!.count == 0 {
            view?.showErrorMessage(message: "No hay más datos a mostrar")
        }else {
            view?.showErrorMessage(message: "Se ha producido un error recuperando los datos")
        }

        view?.hideAndStopSpinner()
    }
}
