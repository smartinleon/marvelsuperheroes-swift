//
//  DetailWireFrame.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

class DetailWireFrame: DetailWireFrameProtocol {
    
    class func createDetailModule(data: Int) -> UIViewController {
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "DetailVC")
        if let view = viewController as? DetailView {
            let presenter: DetailPresenterProtocol & DetailInteractorOutputProtocol = DetailPresenter()
            let interactor: DetailInteractorInputProtocol = DetailInteractor()
            let wireFrame: DetailWireFrameProtocol = DetailWireFrame()
            view.presenter = presenter
            presenter.view = view
            presenter.wireFrame = wireFrame
            presenter.interactor = interactor
            presenter.id = data
            interactor.presenter = presenter

            return viewController
        }
        return UIViewController()
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "DetailView", bundle: Bundle.main)
    }
    
}
