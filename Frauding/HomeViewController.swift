//
//  HomeViewController.swift
//  Frauding
//
//  Created by Isma Dia on 04/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var signalisationView: UIView!
    @IBOutlet weak var signalisationLabel: UILabel!
    @IBOutlet weak var signalisationButton: UIButton!
    var userPosition : CLLocationCoordinate2D?
    var locationManager : CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Utiliser la localisation
        if CLLocationManager.locationServicesEnabled(){
            let manager = CLLocationManager()
            manager.delegate = self
            manager.startUpdatingLocation()
            manager.requestWhenInUseAuthorization()
            self.locationManager = manager
            
        }
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
        guard let postition = userPosition else {return}
        ControleurRequest.reportControleur(from: postition)
        signalisationView.backgroundColor = .green
    }
    
    
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let localisation = locations.first {
            userPosition = localisation.coordinate
            print(localisation.coordinate)
            //startPositionTextField.text = "User Location \(userPosition)"
        }
    }
}
