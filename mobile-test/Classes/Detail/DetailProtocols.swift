//
//  DetailProtocols.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

protocol DetailViewProtocol: class {
    // PRESENTER -> VIEW
    var presenter: DetailPresenterProtocol? { get set }
    func setupView()
    func showSpinner()
    func hideAndStopSpinner()
    func showData(shero: SuperheroEntity)
}

protocol DetailWireFrameProtocol: class {
    // PRESENTER -> WIREFRAME
    static func createDetailModule(data: Int) -> UIViewController
}

protocol DetailPresenterProtocol: class {
    // VIEW -> PRESENTER
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorInputProtocol? { get set }
    var wireFrame: DetailWireFrameProtocol? { get set }
    var id: Int? { get set }
    
    func viewDidLoad()
    func showUrl(shero: SuperheroEntity, type: String)
}

protocol DetailInteractorOutputProtocol: class {
// INTERACTOR -> PRESENTER
    func interactorPushDataPresenter(shero: SuperheroEntity?, success: Bool)
}

protocol DetailInteractorInputProtocol: class {
    // PRESENTER -> INTERACTOR
    var presenter: DetailInteractorOutputProtocol? { get set }
    var shero: SuperheroEntity? { get set }
    func interactorGetData(id: Int)
}
