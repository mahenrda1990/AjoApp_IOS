//
//  AckDetilsTableViewCell.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 01/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class AckDetilsTableViewCell: UITableViewCell {
    @IBOutlet weak var HeadingLbl: UILabel!
    @IBOutlet weak var ShadowView: UIView!
    
    @IBOutlet weak var Yesbtn: UIButton!
    @IBOutlet weak var NOBtn: UIButton!
    @IBOutlet weak var IdidItBtn: UIButton!
    @IBOutlet weak var Chackbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
