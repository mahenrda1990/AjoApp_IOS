//
//  ContectListTableViewCell.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 24/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class ContectListTableViewCell: UITableViewCell {

    @IBOutlet weak var SmsNumber: UILabel!
    @IBOutlet weak var SmsName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
