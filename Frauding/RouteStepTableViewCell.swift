//
//  RouteStepTableViewCell.swift
//  Frauding
//
//  Created by Isma Dia on 06/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class RouteStepTableViewCell: UITableViewCell {

    @IBOutlet weak var controleurImageView: UIImageView!
    @IBOutlet weak var départLabel: UILabel!
    @IBOutlet weak var metroLabel: UILabel!
    @IBOutlet weak var arrivéeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        controleurImageView.isHidden = true
        controleurImageView.image!.withRenderingMode(.alwaysTemplate)
        controleurImageView.tintColor = .red
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
