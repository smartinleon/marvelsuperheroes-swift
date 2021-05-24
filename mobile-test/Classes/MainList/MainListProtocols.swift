//
//  MainListProtocols.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

protocol MainListViewProtocol: class {
    // PRESENTER -> VIEW
    var presenter: MainListPresenterProtocol? { get set }
    func setupView()
    func showSpinner()
    func hideAndStopSpinner()
    func showFilters()
    func showData(superheroes: [SuperheroEntity])
}

protocol MainListWireFrameProtocol: class {
    // PRESENTER -> WIREFRAME
    static func createMainListModule() -> UIViewController
    func presentNewViewDetail(view: MainListViewProtocol, data: Int)
}

protocol MainListPresenterProtocol: class {
    // VIEW -> PRESENTER
    var view: MainListViewProtocol? { get set }
    var interactor: MainListInteractorInputProtocol? { get set }
    var wireFrame: MainListWireFrameProtocol? { get set }
    
    func viewDidLoad()
    func loadImageData(searched: Bool, shero: SuperheroEntity)
    func searchData(text: String, offset: Int?)
    func filterData(text: String, data: [SuperheroEntity])
    func showFilters()
    func orderData(data: [SuperheroEntity], ordering: ComparisonResult) -> [SuperheroEntity]
    func showDetailView(data: Int)
}

protocol MainListInteractorOutputProtocol: class {
// INTERACTOR -> PRESENTER
    func interactorPushDataPresenter(superheroes: [SuperheroEntity]?, success: Bool)
}

protocol MainListInteractorInputProtocol: class {
    // PRESENTER -> INTERACTOR
    var presenter: MainListInteractorOutputProtocol? { get set }
    var textSearched: String { get set }
    var superheroesSearched: [SuperheroEntity] { get set }
    var superheroes: [SuperheroEntity] { get set }
    var localDatamanager: MainListLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: MainListRemoteDataManagerInputProtocol? { get set }
    func interactorGetData(text: String, offset: Int?)
    func interactorGetImageData(searched: Bool, shero: SuperheroEntity)
}

protocol MainListDataManagerInputProtocol: class {
    // INTERACTOR -> DATAMANAGER
}

protocol MainListRemoteDataManagerInputProtocol: class {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: MainListRemoteDataManagerOutputProtocol? { get set }
    func externalGetData(text: String, offset: Int?)
    func externalGetSHeroImageData(searched: Bool, shero: SuperheroEntity)
}

protocol MainListRemoteDataManagerOutputProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func completionData(text: String, superheroes: [SuperheroEntity]?, success: Bool)
    func completionImageData(searched: Bool, imageData: Data?, shero: SuperheroEntity?, success: Bool)
}

protocol MainListLocalDataManagerInputProtocol: class {
    // INTERACTOR -> LOCALDATAMANAGER
}
