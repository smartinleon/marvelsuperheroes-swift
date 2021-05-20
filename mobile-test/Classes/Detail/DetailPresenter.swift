//
//  DetailPresenter.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation

class DetailPresenter: DetailPresenterProtocol{
    
    // MARK: Properties
    weak var view: DetailViewProtocol?
    var shero: SuperheroEntity?
    var interactor: DetailInteractorInputProtocol?
    var wireFrame: DetailWireFrameProtocol?
    
    // TODO: implement presenter methods
    func viewDidLoad() {
    }
    
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    // TODO: implement interactor output methods
}
