//
//  SearchResultTableViewCell.swift
//  Horizon
//
//  Created by Devesh Tibarewal on 09/02/23.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var nameUI: UILabel!
    @IBOutlet weak var descriptionUI: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
