//
//  SuperheroTableViewCell.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 20/05/2021.
//

import Foundation
import UIKit

class SuperheroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view_data: UIView!
    
    @IBOutlet weak var iv_shero: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view_data.layer.cornerRadius = 5
        
        iv_shero.layer.masksToBounds = true
        iv_shero.layer.cornerRadius =  iv_shero.bounds.width / 2
    }
}
