//
//  MainListPresenter.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

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
    
    func viewDidLoad() {
        view?.setupView()
        interactor?.interactorGetData(text: "", offset: nil)
        view?.showSpinner()
    }
    
    func loadImageData(searched: Bool, shero: SuperheroEntity) {
//        Gets the data associated to the url image of the superhero
        interactor?.interactorGetImageData(searched: searched, shero: shero)
    }
    
    func searchData(text: String, offset: Int?) {
//        Searching specific superhero name
        interactor?.interactorGetData(text: text, offset: offset)
        view?.showSpinner()
    }
    
    func showFilters() {
        view?.showFilters()
    }
    
    func orderData(data: [SuperheroEntity], ordering: ComparisonResult) -> [SuperheroEntity] {
//        Sorts the data by comparisong
        data.sorted { (sh1, sh2) -> Bool in
                    let superhero1 = sh1.name
                    let superhero2 = sh2.name
            return (superhero1!.localizedCaseInsensitiveCompare(superhero2!) ==  ordering)
        }
    }
    
    func showDetailView(data: Int) {
//        Presenting the detail of the superhero
        wireFrame?.presentNewViewDetail(view: view!, data: data)
    }
    
}

extension MainListPresenter: MainListInteractorOutputProtocol {

    func interactorPushDataPresenter(superheroes: [SuperheroEntity]?, success: Bool) {
//        Retrieved data from server and presents error or the data
        if success && superheroes != nil && superheroes!.count > 0{
            view?.showData(superheroes: superheroes!)
        }else if success && superheroes != nil && superheroes!.count == 0 {
            if let vc = view as? UIViewController {
                Utils.showErrorMessage(vc: vc, message: Utils.localizedString(key: "str_no_more_data"))
            }
        }else {
            if let vc = view as? UIViewController {
                Utils.showErrorMessage(vc: vc, message: Utils.localizedString(key: "str_error_retrieving_data"))
            }
        }
        
        view?.hideAndStopSpinner()
    }
}
