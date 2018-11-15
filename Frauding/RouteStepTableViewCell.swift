//
//  RouteStepTableViewCell.swift
//  Frauding
//
//  Created by Isma Dia on 06/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import WebKit

class RouteStepTableViewCell: UITableViewCell {

    @IBOutlet weak var logoMImage: UIImageView!
    @IBOutlet weak var metroImage: UIImageView!
    @IBOutlet weak var controleurImageView: UIImageView!
    @IBOutlet weak var départLabel: UILabel!
    @IBOutlet weak var metroLabel: UILabel!
    @IBOutlet weak var arrivéeLabel: UILabel!
    @IBOutlet weak var portiqueLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        containerView.backgroundColor = UIColor.greenColor()
        controleurImageView.isHidden = true
        controleurImageView.image!.withRenderingMode(.alwaysTemplate)
        controleurImageView.tintColor = .red
        metroImage.backgroundColor = .clear
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
