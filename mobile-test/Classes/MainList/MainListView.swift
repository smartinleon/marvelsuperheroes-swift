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
    
    var superheroes = [SuperheroEntity]()
    var superheroesFiltered = [SuperheroEntity]()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        presenter?.filterData(text: textField.text!, data: superheroes)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        presenter?.searchData(text: tf_search.text!, offset: nil)
    }
    
    @IBAction func filtersAction(_ sender: Any) {
        presenter?.showFilters()
    }
}

extension MainListView: MainListViewProtocol {
    
    func setupView() {
        title = Utils.localizedString(key: "title_main")
        
        tf_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view_text.setCornerRadius(cornerRadius: 5)
        view_search.setCornerRadius(cornerRadius: 5)
        view_filters.setCornerRadius(cornerRadius: 5)
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
    
    func showFilters() {
//        Showing filters
        let optionMenu = UIAlertController(title: nil, message: Utils.localizedString(key: "title_order_by_name"), preferredStyle: .actionSheet)
        let orderAscAction = UIAlertAction.init(title: Utils.localizedString(key: "title_order_asc"), style: .default) { [self] (alert) in
            superheroesFiltered = (presenter?.orderData(data: superheroesFiltered, ordering: .orderedAscending))!
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        
        let orderDescAction = UIAlertAction(title:  Utils.localizedString(key: "title_order_desc"), style: .default) { [self] (alert) in
            superheroesFiltered = (presenter?.orderData(data: superheroesFiltered, ordering: .orderedDescending))!
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
            
        let cancelAction = UIAlertAction(title: Utils.localizedString(key: "str_exit"), style: .cancel)
            
        optionMenu.addAction(orderAscAction)
        optionMenu.addAction(orderDescAction)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func showData(superheroes: [SuperheroEntity]) {
        DispatchQueue.main.async { [self] in
            self.superheroes = superheroes
            superheroesFiltered = self.superheroes
            tableView.reloadData()
        }
    }
}

extension MainListView: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superheroesFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Presenting the cell based on the superhero, if it has not image, calls the presenter to retrieve it
        let shero = superheroesFiltered[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperheroCell", for: indexPath) as! SuperheroTableViewCell
        
        cell.lbl_name.text = shero.name
        
        if let data = shero.thumbnail?.data {
            DispatchQueue.main.async {
                cell.iv_shero?.image = UIImage(data: data)
            }
        }else {
            let searched = !tf_search.text!.isEmpty
            DispatchQueue.global(qos: .background).async { [self] in
                presenter?.loadImageData(searched: searched, shero: shero)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        If the user selects the row, we presents the detail
        let shero = superheroesFiltered[indexPath.row]
        if let idShero = shero.id {
            presenter?.showDetailView(data: idShero)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        If the use scrolls to the bottom, we retrieve the next 10 superheros from the api
        if (scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height)) {
            presenter?.searchData(text: tf_search.text!, offset: (superheroesFiltered.count + 1))
        }
    }
}
