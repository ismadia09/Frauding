//
//  RouteTableViewCell.swift
//  Frauding
//
//  Created by Isma Dia on 04/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var duréeLabel: UILabel!
    @IBOutlet weak var métroLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var infosLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        okButton.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
