//
//  RouteTableViewCell.swift
//  Frauding
//
//  Created by Isma Dia on 04/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import WebKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var metroCollectionView: UICollectionView!
    @IBOutlet weak var duréeLabel: UILabel!
    @IBOutlet weak var métroLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var infosLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var imagesString : [String]? {
        didSet{
            metroCollectionView.reloadData()
//            for image in imagesString! {
//                getImages(metro: image)
//                metroCollectionView.reloadData()
//            }
            
        }
    }
    //var webviews : [WKWebView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.backgroundColor = UIColor.mainColor()
        okButton.layer.cornerRadius = 10
        okButton.backgroundColor = UIColor.greenColor()
        duréeLabel.textColor = UIColor.greenColor()
        métroLabel.textColor = UIColor.greenColor()
        infosLabel.textColor = UIColor.greenColor()
        metroCollectionView.delegate = self
        metroCollectionView.dataSource = self
        let nib = UINib(nibName: "MetroCollectionViewCell", bundle: nil)
        metroCollectionView.register(nib, forCellWithReuseIdentifier: "metro")
        metroCollectionView.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func getImages(metro : String){
//        let metroImageName = UidDef.metroImageDictionary[metro]
//        let path: String = Bundle.main.path(forResource: metroImageName, ofType: "svg")!
//        guard let url: URL = URL(string: path) else {
//            return
//        } //Creating a URL which points towards our path
//        //Creating a page request which will load our URL (Which points to our path)
//        let request: URLRequest = URLRequest(url: url)
//        let webview = WKWebView()
//        webview.translatesAutoresizingMaskIntoConstraints = false
//        webview.load(request as URLRequest)
//        webviews.append(webview)
//
//    }
    
}

extension RouteTableViewCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesString?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "metro", for: indexPath) as! MetroCollectionViewCell
        if (imagesString != nil ){
            if (imagesString!.count > indexPath.item){
                cell.imageMetro.image = UIImage(named: (imagesString?[indexPath.item])!)

            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    
}
