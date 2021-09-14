//
//  MainListProtocols.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

protocol MainListViewProtocol: AnyObject {
    // PRESENTER -> VIEW
    var presenter: MainListPresenterProtocol? { get set }
    func setupView()
    func showSpinner()
    func hideAndStopSpinner()
    func showFilters()
    func showData(superheroes: [SuperheroEntity])
}

protocol MainListWireFrameProtocol: AnyObject {
    // PRESENTER -> WIREFRAME
    static func createMainListModule() -> UIViewController
    func presentNewViewDetail(view: MainListViewProtocol, data: Int)
}

protocol MainListPresenterProtocol: AnyObject {
    // VIEW -> PRESENTER
    var view: MainListViewProtocol? { get set }
    var interactor: MainListInteractorInputProtocol? { get set }
    var wireFrame: MainListWireFrameProtocol? { get set }
    
    func viewDidLoad()
//    func loadImageData(searched: Bool, shero: SuperheroEntity)
    func searchData(text: String, offset: Int?)
    func filterData(text: String, data: [SuperheroEntity])
    func showFilters()
    func orderData(data: [SuperheroEntity], ordering: ComparisonResult) -> [SuperheroEntity]
    func showDetailView(data: Int)
}

protocol MainListInteractorOutputProtocol: AnyObject {
// INTERACTOR -> PRESENTER
    func interactorPushDataPresenter(superheroes: [SuperheroEntity]?, success: Bool)
}

protocol MainListInteractorInputProtocol: AnyObject {
    // PRESENTER -> INTERACTOR
    var presenter: MainListInteractorOutputProtocol? { get set }
    var textSearched: String { get set }
    var superheroesSearched: [SuperheroEntity] { get set }
    var superheroes: [SuperheroEntity] { get set }
    func interactorGetData(text: String, offset: Int?)
    func interactorGetImageData(searched: Bool, shero: SuperheroEntity, group: DispatchGroup)
}
