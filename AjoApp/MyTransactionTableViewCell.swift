//
//  MyTransactionTableViewCell.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 27/02/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class MyTransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var HeadingLbl: UILabel!
    @IBOutlet weak var Menberlbl: UILabel!
    @IBOutlet weak var ShadowView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
