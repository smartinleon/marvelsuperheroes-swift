//
//  MainListView.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

class MainListView: UIViewController {
    
    @IBOutlet weak var view_text: UIView!
    @IBOutlet weak var view_search: UIView!
    @IBOutlet weak var view_filters: UIView!
    
    @IBOutlet weak var tf_search: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: Properties
    var presenter: MainListPresenterProtocol?
    
    var superheros = [SuperheroEntity]()
    var superherosFiltered = [SuperheroEntity]()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Superhéroes Marvel"
        
        tf_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view_text.layer.cornerRadius = 5
        view_search.layer.cornerRadius = 5
        view_filters.layer.cornerRadius = 5
        
        presenter?.viewDidLoad()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        presenter?.filterData(text: textField.text!, data: superheros)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        presenter?.searchData(text: tf_search.text!, offset: nil)
    }
    
    @IBAction func filtersAction(_ sender: Any) {
        presenter?.showFilters()
    }
}

extension MainListView: MainListViewProtocol {
    // TODO: implement view output methods
    func showData(superheros: [SuperheroEntity]) {
        DispatchQueue.main.async { [self] in
            self.superheros.removeAll()
            superherosFiltered.removeAll()
            
             self.superheros = superheros
            superherosFiltered = self.superheros
            tableView.reloadData()
        }
    }
    
    func updateData(superheros: [SuperheroEntity]) {
        self.superheros = superheros
        superherosFiltered = self.superheros
    }
    
//    func showDataFilterd(data: [SuperheroEntity]){
//        DispatchQueue.main.async { [self] in
//            self.superheros = data
//            superherosFiltered = data
//            tableView.reloadData()
//        }
//    }
    
    func showFilters() {
        let optionMenu = UIAlertController(title: nil, message: "Filtrar por:", preferredStyle: .actionSheet)
        let orderAscAction = UIAlertAction(title: "Orden ascendente", style: .default)
        let orderDescAction = UIAlertAction(title: "Orden descentente", style: .default)
            
        let cancelAction = UIAlertAction(title: "Salir", style: .cancel)
            
        optionMenu.addAction(orderAscAction)
        optionMenu.addAction(orderDescAction)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showErrorMessage(message: String) {
        let alert = UIAlertController.init(title: "Atención", message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSpinner() {
        DispatchQueue.main.async { [self] in
            spinner.startAnimating()
            spinner.isHidden = false
        }
    }
    
    func hideAndStopSpinner() {
        DispatchQueue.main.async { [self] in
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
        }
    }
}

extension MainListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superherosFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == superherosFiltered.count - 1 && superherosFiltered.count >= 10{
            presenter?.searchData(text: tf_search.text!, offset: (superherosFiltered.count + 1))
        }
        
        let shero = superherosFiltered[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperheroCell", for: indexPath) as! SuperheroTableViewCell

        cell.lbl_name.text = shero.name
        
        if let data = shero.thumbnail?.data {
            DispatchQueue.main.async {
                cell.iv_shero?.image = UIImage(data: data)
            }
        }else {
            DispatchQueue.global(qos: .background).async { [self] in
                presenter?.loadImageData(searched: !tf_search.text!.isEmpty, shero: shero)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shero = superherosFiltered[indexPath.row]
        presenter?.showDetailView(data: shero)
    }
}
