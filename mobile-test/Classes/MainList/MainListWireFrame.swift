//
//  MainListWireFrame.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

class MainListWireFrame: MainListWireFrameProtocol {

    /// Creates the main module
    /// - Returns: main view of the application
    class func createMainListModule() -> UIViewController {
        let navController = mainStoryboard.instantiateViewController(withIdentifier: "MainListNC")
        if let view = navController.children.first as? MainListView {
            let presenter: MainListPresenterProtocol & MainListInteractorOutputProtocol = MainListPresenter()
            let interactor: MainListInteractorInputProtocol = MainListInteractor()
            let wireFrame: MainListWireFrameProtocol = MainListWireFrame()

            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            interactor.presenter = presenter

            return navController
        }
        return UIViewController()
    }

    /// Loads the detail of a superhero
    /// - Parameters:
    ///   - view: current view
    ///   - data: superhero id to load the data
    func presentNewViewDetail(view: MainListViewProtocol, data: Int) {
        let newDetail = DetailWireFrame.createDetailModule(data: data)
        if let newView = view as? UIViewController {
            newView.navigationController?.pushViewController(newDetail, animated: true)
        }
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "MainList", bundle: Bundle.main)
    }
    
}
