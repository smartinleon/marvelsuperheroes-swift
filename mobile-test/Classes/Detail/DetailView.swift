//
//  DetailViewController.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//  
//

import Foundation
import UIKit

class DetailView: UIViewController {

    @IBOutlet weak var view_data: UIView!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_description: UIView!
    @IBOutlet weak var view_comics: UIView!
    @IBOutlet weak var view_series: UIView!
    @IBOutlet weak var view_stories: UIView!
    
    @IBOutlet weak var iv_shero: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    
    @IBOutlet weak var cns_heightDescription: NSLayoutConstraint!
    @IBOutlet weak var cns_heightComics: NSLayoutConstraint!
    @IBOutlet weak var cns_heightSeries: NSLayoutConstraint!
    @IBOutlet weak var cns_heightStories: NSLayoutConstraint!
    
    @IBOutlet weak var tableview_comics: UITableView!
    @IBOutlet weak var tableview_series: UITableView!
    @IBOutlet weak var tableview_stories: UITableView!

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    // MARK: Properties
    var presenter: DetailPresenterProtocol?
    var shero: SuperheroEntity?

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    @IBAction func moreInfoDetailAction(_ sender: Any) {
        if let superhero = shero {
            presenter?.showUrl(shero: superhero, type: "detail")
        }
    }
    
    @IBAction func moreInfoComicsAction(_ sender: Any) {
        if let superhero = shero {
            presenter?.showUrl(shero: superhero, type: "comiclink")
        }
    }
}

extension DetailView: DetailViewProtocol {
    
    func setupView() {
        iv_shero.layer.masksToBounds = true
        iv_shero.layer.borderColor = UIColor.darkGray.cgColor
        iv_shero.layer.borderWidth = 1
        iv_shero.setCornerRadius(cornerRadius: iv_shero.bounds.width / 2)
        
        view_data.setCornerRadius(cornerRadius: 5)
        
        view_header.layer.shadowPath = UIBezierPath(rect: view_header.bounds).cgPath
        view_header.layer.shadowRadius = 5
        view_header.layer.shadowOffset = .zero
        view_header.layer.shadowOpacity = 1
        
        view_description.layer.cornerRadius = 5
        view_description.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view_stories.layer.cornerRadius = 5
        view_stories.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    /// Shows the superhero data passed by parameter
    /// - Parameter shero: superhero data to load
    func showData(shero: SuperheroEntity) {
        DispatchQueue.main.async { [self] in
            self.shero = shero
            
            title = self.shero?.name
            
            if let data = self.shero?.thumbnail?.data {
                iv_shero.image = UIImage(data: data)
            }
            
            lbl_name.text = self.shero?.name

            if let sheroDescription = self.shero?.description {
                lbl_description.text = sheroDescription.isEmpty ? Utils.localizedString(key: "str_no_description") : sheroDescription

                if let lblDescriptionText = lbl_description.text {
                  cns_heightDescription.constant = 75 + Utils.heightForView(text: lblDescriptionText, font: lbl_description.font, width: lbl_description.bounds.width)
                }

                tableview_series.reloadData()
                tableview_comics.reloadData()
                tableview_stories.reloadData()
            }
        }
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

extension DetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If the superhero doesnt have comics, series or stories, the tableview doesnt appear
        if shero != nil {
            if tableView == tableview_comics {
                if let sheroComicsItems = shero?.comics?.items {
                    if sheroComicsItems.count == 0 {
                        view_comics.isHidden = true
                        cns_heightComics.constant = 0
                    }
                    return sheroComicsItems.count
                }
            } else if tableView == tableview_series {
                if let sheroSeriesItems = shero?.comics?.items {
                    if sheroSeriesItems.count == 0 {
                        view_series.isHidden = true
                        cns_heightSeries.constant = 0
                    }
                    return sheroSeriesItems.count
                }
            } else if tableView == tableview_stories {
                if let sheroStoriesItems = shero?.stories?.items {
                  if sheroStoriesItems.count == 0 {
                        view_stories.isHidden = true
                        cns_heightStories.constant = 0
                    }
                    return sheroStoriesItems.count
                }
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Shows the data into the specific tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailTableViewCell
        
        if shero != nil {
            if tableView == tableview_comics {
                if let sheroComicsItems = shero?.comics?.items {
                    let comic = sheroComicsItems[indexPath.row]

                    cell?.lbl_name.text = comic.name
                }
            }else if tableView == tableview_series {
                if let sheroSeriesItems = shero?.series?.items {
                    let serie = sheroSeriesItems[indexPath.row]

                    cell?.lbl_name.text = serie.name
                }
            }else if tableView == tableview_stories {
                if let sheroStoriesItems = shero?.stories?.items {
                    let story = sheroStoriesItems[indexPath.row]

                    cell?.lbl_name.text = story.name
                }
            }
        }

        guard let detailCell = cell else {
            return DetailTableViewCell()
        }

        return detailCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
