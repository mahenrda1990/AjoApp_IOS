//
//  UpcomingTableViewCell.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 28/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {
    @IBOutlet weak var Satuslbl: UILabel!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var ShadowView: UIView!
    @IBOutlet weak var GroupNamelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
