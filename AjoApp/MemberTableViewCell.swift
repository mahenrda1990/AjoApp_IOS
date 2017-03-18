//
//  MemberTableViewCell.swift
//  AjoApp
//
//  Created by mindcrewtechnologies on 01/03/17.
//  Copyright © 2017 mahendra. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    @IBOutlet weak var NameLble: UILabel!
    
    
    @IBOutlet weak var InfoBtn: UIButton!

    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
