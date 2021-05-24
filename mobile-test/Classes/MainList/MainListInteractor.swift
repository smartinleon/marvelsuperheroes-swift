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
    var superheroes = [SuperheroEntity]()
    var superheroesSearched = [SuperheroEntity]()
    
    func interactorGetData(text: String, offset: Int?) {
        APIClient.shared.externalGetData(text: text, offset: offset) { [self] data, success in
//        Returns the data retrieved from the server
            if let dSheroes = data {
                if success && dSheroes.count > 0{
                    if !text.isEmpty{
                        if text.contains(textSearched){
                            for shero in dSheroes {
                                if !self.superheroesSearched.contains(where: {$0.id == shero.id}){
                                    self.superheroesSearched.append(shero)
                                }
                            }
                            presenter?.interactorPushDataPresenter(superheroes: self.superheroesSearched, success: true)
                        }else{
                            textSearched = text
                            superheroesSearched.removeAll()
                            for shero in dSheroes {
                                if !self.superheroesSearched.contains(where: {$0.id == shero.id}){
                                    self.superheroesSearched.append(shero)
                                }
                            }
                            presenter?.interactorPushDataPresenter(superheroes: self.superheroesSearched, success: true)
                        }
                    }else{
                        for shero in dSheroes {
                            if !self.superheroes.contains(where: {$0.id == shero.id}){
                                self.superheroes.append(shero)
                            }
                        }
                        presenter?.interactorPushDataPresenter(superheroes: self.superheroes, success: true)
                    }
                }else if success && dSheroes.count == 0{
                    presenter?.interactorPushDataPresenter(superheroes: dSheroes, success: true)
                }else {
                    presenter?.interactorPushDataPresenter(superheroes: nil, success: false)
                }
            }else {
                presenter?.interactorPushDataPresenter(superheroes: nil, success: false)
            }
        }
    }
    
    func interactorGetImageData(searched: Bool, shero: SuperheroEntity) {
        APIClient.shared.externalGetSHeroImageData(shero: shero) { [self] data, success in
            if searched {
                if success && superheroesSearched.count > 0{
                    if var sheroSelected = superheroesSearched.first(where: { $0.id == shero.id }) {
                        sheroSelected.thumbnail?.data = data
                        
                        for i in 0...superheroesSearched.count - 1 {
                            if superheroesSearched[i].id == sheroSelected.id {
                                superheroesSearched[i] = sheroSelected
                                break
                            }
                        }
                    }
                }
                
                if superheroesSearched.count > 0 {
                    presenter?.interactorPushDataPresenter(superheroes: superheroesSearched, success: true)
                }else {
                    presenter?.interactorPushDataPresenter(superheroes: superheroesSearched, success: false)
                }
            }else{
                if success && superheroes.count > 0{
                    if var sheroSelected = superheroes.first(where: { $0.id == shero.id }) {
                        sheroSelected.thumbnail?.data = data
                        
                        for i in 0...superheroes.count - 1 {
                            if superheroes[i].id == sheroSelected.id {
                                superheroes[i] = sheroSelected
                                break
                            }
                        }
                    }
                }
                
                if superheroes.count > 0 {
                    presenter?.interactorPushDataPresenter(superheroes: superheroes, success: true)
                }else {
                    presenter?.interactorPushDataPresenter(superheroes: superheroes, success: false)
                }
            }
        }
    }
}
