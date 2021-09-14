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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        presenter?.viewDidLoad()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let tfText = textField.text {
            presenter?.filterData(text: tfText, data: superheroes)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        if let tfSearchText = tf_search.text {
            presenter?.searchData(text: tfSearchText, offset: nil)
        }
    }
    
    @IBAction func filtersAction(_ sender: Any) {
        presenter?.showFilters()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        tf_search.resignFirstResponder()
    }
}

extension MainListView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            if touchView.isDescendant(of: tableView){
                return false
            }
        }

        return true
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

    /// Shows the ascending and descending filters
    func showFilters() {
        let optionMenu = UIAlertController(title: nil, message: Utils.localizedString(key: "title_order_by_name"), preferredStyle: .actionSheet)
        let orderAscAction = UIAlertAction.init(title: Utils.localizedString(key: "title_order_asc"), style: .default) { [self] (alert) in
            if let sheroFiltered = (presenter?.orderData(data: superheroesFiltered, ordering: .orderedAscending)) {
              superheroesFiltered = sheroFiltered

              DispatchQueue.main.async {
                  tableView.reloadData()
              }
            }
        }
        
        let orderDescAction = UIAlertAction(title:  Utils.localizedString(key: "title_order_desc"), style: .default) { [self] (alert) in
            if let sheroFiltered = (presenter?.orderData(data: superheroesFiltered, ordering: .orderedDescending)) {
              superheroesFiltered = sheroFiltered

              DispatchQueue.main.async {
                  tableView.reloadData()
              }
            }
        }
            
        let cancelAction = UIAlertAction(title: Utils.localizedString(key: "str_exit"), style: .cancel)
            
        optionMenu.addAction(orderAscAction)
        optionMenu.addAction(orderDescAction)
        optionMenu.addAction(cancelAction)
            
        self.present(optionMenu, animated: true, completion: nil)
    }

  /// Loads the superheroes data
  /// - Parameter superheroes: data
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
        //Presenting the cell based on the superhero, if it has not image, calls the presenter to retrieve it
        let shero = superheroesFiltered[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuperheroCell", for: indexPath) as? SuperheroTableViewCell
        
        cell?.lbl_name.text = shero.name
        
        if let data = shero.thumbnail?.data {
            DispatchQueue.main.async {
              cell?.iv_shero?.image = UIImage(data: data)
            }
        }

        guard let sheroCell = cell else {
            return SuperheroTableViewCell()
        }

        return sheroCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If the user selects the row, we presents the detail
        let shero = superheroesFiltered[indexPath.row]
        if let idShero = shero.id {
            presenter?.showDetailView(data: idShero)
        }
    }
  
    /// If the user scrolls to the bottom, we retrieve the next 10 superheroes from the api
    /// - Parameter scrollView: scrollview of the view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if let tfSearchText = tf_search.text {
              presenter?.searchData(text: tfSearchText, offset: (superheroesFiltered.count + 1))
            }
        }
    }
}
