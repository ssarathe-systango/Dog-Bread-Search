//
//  TableViewCell.swift
//  Dog Bread Search
//
//  Created by macmini01 on 02/08/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var TextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
