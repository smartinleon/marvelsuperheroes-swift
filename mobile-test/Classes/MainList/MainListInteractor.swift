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

    /// Calls the API to returns the superheroes from the Marvel's API
    /// - Parameters:
    ///   - text: text name of superhero, used in searcher
    ///   - offset: value of the next count elements to return
    func interactorGetData(text: String, offset: Int?) {
        APIClient.shared.externalGetData(text: text, offset: offset) { [self] data, success in
            if let dSheroes = data {
                if success && dSheroes.count > 0{
                    if !text.isEmpty{
                        if text.contains(textSearched){
                            for shero in dSheroes {
                                if !superheroesSearched.contains(where: {$0.id == shero.id}){
                                    superheroesSearched.append(shero)
                                }
                            }
                            presenter?.interactorPushDataPresenter(superheroes: superheroesSearched, success: true)
                        }else{
                            textSearched = text
                            superheroesSearched.removeAll()
                            for shero in dSheroes {
                                if !superheroesSearched.contains(where: {$0.id == shero.id}){
                                    superheroesSearched.append(shero)
                                }
                            }
                            
                            let group = DispatchGroup()
                            
                            //Retrieving images data from server
                            for sheroData in superheroesSearched {
                                group.enter()
                                interactorGetImageData(searched: true, shero: sheroData, group: group)
                            }
                            
                            group.notify(queue: .main) {
                                presenter?.interactorPushDataPresenter(superheroes: superheroesSearched, success: true)
                            }
                        }
                    }else{
                        for shero in dSheroes {
                            if !superheroes.contains(where: {$0.id == shero.id}){
                                superheroes.append(shero)
                            }
                        }
                        
                        
                        let group = DispatchGroup()
                        
                        //Retrieving images data from server
                        for sheroData in superheroes {
                            group.enter()
                            interactorGetImageData(searched: false, shero: sheroData, group: group)
                        }
                        
                        group.notify(queue: .main) {
                            presenter?.interactorPushDataPresenter(superheroes: superheroes, success: true)
                        }
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

    /// Calls the API to returns the image of the superhero passed by parameter
    /// - Parameters:
    ///   - searched: boolean indicating if user has search superheroes info by searcher
    ///   - shero: superhero data to load image data
    ///   - group: dispatch group to load the data synchronized
    func interactorGetImageData(searched: Bool, shero: SuperheroEntity, group: DispatchGroup) {
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
                
                group.leave()
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
                
                group.leave()
            }
        }
    }
}
