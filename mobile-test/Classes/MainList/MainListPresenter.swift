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
        view?.showSpinner()
        interactor?.interactorGetData(text: "", offset: nil)
    }

  /// Searching specific superhero name
  /// - Parameters:
  ///   - text: text name of superhero, used in searcher
  ///   - offset: value of the next count elements to return
    func searchData(text: String, offset: Int?) {
        view?.showSpinner()
        interactor?.interactorGetData(text: text, offset: offset)
    }
    
    func showFilters() {
        view?.showFilters()
    }

  /// //Sorts the data by comparisong
  /// - Parameters:
  ///   - data: superheroes list to order
  ///   - ordering: comparison, can be ascending or descending
  /// - Returns: superheroes list ordered
    func orderData(data: [SuperheroEntity], ordering: ComparisonResult) -> [SuperheroEntity] {
        data.sorted { (sh1, sh2) -> Bool in
            guard let superhero1 = sh1.name else {
              return false
            }

            guard let superhero2 = sh2.name else {
              return false
            }

            return (superhero1.localizedCaseInsensitiveCompare(superhero2) == ordering)
        }
    }

  /// Presents the detail of the superhero
  /// - Parameter data: superhero id to load
    func showDetailView(data: Int) {
        if let v = view {
            wireFrame?.presentNewViewDetail(view: v, data: data)
        }
    }
}

extension MainListPresenter: MainListInteractorOutputProtocol {

    /// Retrieves data from server and presents error or the data
    /// - Parameters:
    ///   - superheroes: superheroes data loaded
    ///   - success: boolean indicating if success or not
    func interactorPushDataPresenter(superheroes: [SuperheroEntity]?, success: Bool) {
        if let sheros = superheroes {
            if success && sheros.count > 0 {
                view?.showData(superheroes: sheros)
            }else if success && sheros.count == 0 {
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
}
