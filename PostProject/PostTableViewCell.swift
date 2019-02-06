//
//  PostTableViewCell.swift
//  PostProject
//
//  Created by Nathan Andrus on 2/6/19.
//  Copyright © 2019 Nathan Andrus. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cohortLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
