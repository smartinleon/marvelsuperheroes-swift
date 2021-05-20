//
//  MainListInteractor.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation

class MainListInteractor: MainListInteractorInputProtocol {
    // MARK: Properties
    weak var presenter: MainListInteractorOutputProtocol?
    var textSearched: String = "??????"
    var superheros = [SuperheroEntity]()
    var superherosSearched = [SuperheroEntity]()
    var localDatamanager: MainListLocalDataManagerInputProtocol?
    var remoteDatamanager: MainListRemoteDataManagerInputProtocol?
    
    func interactorGetData(text: String, offset: Int?) {
        remoteDatamanager?.externalGetData(text: text, offset: offset)
    }
    
    func interactorGetImageData(searched: Bool, shero: SuperheroEntity) {        remoteDatamanager?.externalGetSHeroImageData(searched: searched, shero: shero)
    }
}

extension MainListInteractor: MainListRemoteDataManagerOutputProtocol {
    func completionData(text: String, superheros: [SuperheroEntity]?, success: Bool) {
        if success && superheros != nil && superheros!.count > 0{
            if !text.isEmpty{
                if text.contains(textSearched){
                    for shero in superheros! {
                        if !self.superherosSearched.contains(where: {$0.id == shero.id}){
                            self.superherosSearched.append(shero)
                        }
                    }
                    presenter?.interactorPushDataPresenter(superheros: self.superherosSearched, success: true)
                }else{
                    textSearched = text
                    superherosSearched.removeAll()
                    for shero in superheros! {
                        if !self.superherosSearched.contains(where: {$0.id == shero.id}){
                            self.superherosSearched.append(shero)
                        }
                    }
                    presenter?.interactorPushDataPresenter(superheros: self.superherosSearched, success: true)
                }
            }else{
                for shero in superheros! {
                    if !self.superheros.contains(where: {$0.id == shero.id}){
                        self.superheros.append(shero)
                    }
                }
                presenter?.interactorPushDataPresenter(superheros: self.superheros, success: true)
            }
        }else if success && superheros != nil && superheros!.count == 0{
            presenter?.interactorPushDataPresenter(superheros: superheros, success: true)
        }else {
            presenter?.interactorPushDataPresenter(superheros: nil, success: false)
        }
    }
    
    func completionImageData(searched: Bool, imageData: Data?, shero: SuperheroEntity?, success: Bool) {
        // TODO: Implement use case methods
        if searched {
            if success && shero != nil && superherosSearched.count > 0{
                if var sheroSelected = superherosSearched.first(where: { $0.id == shero?.id }) {
                    sheroSelected.thumbnail?.data = imageData
                    
                    for i in 0...superherosSearched.count - 1 {
                        if superherosSearched[i].id == sheroSelected.id {
                            superherosSearched[i] = sheroSelected
                            break
                        }
                    }
                }
            }
            
            if superherosSearched.count > 0 {
                presenter?.interactorPushUpdatedDataPresenter(superheros: superherosSearched, success: true)
            }else {
                presenter?.interactorPushUpdatedDataPresenter(superheros: superherosSearched, success: false)
            }
        }else{
            if success && shero != nil && superheros.count > 0{
                if var sheroSelected = superheros.first(where: { $0.id == shero?.id }) {
                    sheroSelected.thumbnail?.data = imageData
                    
                    for i in 0...superheros.count - 1 {
                        if superheros[i].id == sheroSelected.id {
                            superheros[i] = sheroSelected
                            break
                        }
                    }
                }
            }
            
            if superheros.count > 0 {
                presenter?.interactorPushUpdatedDataPresenter(superheros: superheros, success: true)
            }else {
                presenter?.interactorPushUpdatedDataPresenter(superheros: superheros, success: false)
            }
        }
    }
}
