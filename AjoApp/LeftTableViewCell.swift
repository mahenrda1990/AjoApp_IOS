//
//  LeftTableViewCell.swift
//  Ajo App
//
//  Created by mindcrewtechnologies on 23/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuName: UILabel!


       override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
