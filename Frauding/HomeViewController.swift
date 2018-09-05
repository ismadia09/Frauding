//
//  HomeViewController.swift
//  Frauding
//
//  Created by Isma Dia on 04/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var signalisationView: UIView!
    @IBOutlet weak var signalisationLabel: UILabel!
    @IBOutlet weak var signalisationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupHomeView(){
        titleLabel.text = "Frauding"
        searchButton.layer.cornerRadius = 4
        searchButton.layer.borderColor = UIColor.lightGray.cgColor
        searchButton.layer.borderWidth = 1
        
        signalisationView.backgroundColor = .red
        signalisationView.layer.cornerRadius = 4
        signalisationLabel.text = "Signaler"
        signalisationButton.addTarget(self, action: #selector(report), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(goToRoute), for: .touchUpInside)
    }
    
    @objc func goToRoute() {
        let routeViewController = RouteViewController()
        routeViewController.modalPresentationStyle = .overCurrentContext
        present(routeViewController, animated: true, completion: nil)
    }
    
    @objc func report(){
        signalisationView.backgroundColor = .green
    }
    
    
}
