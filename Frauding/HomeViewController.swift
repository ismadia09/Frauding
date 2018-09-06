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
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var stationsTableView: UITableView!
    @IBOutlet weak var stationSearchBar: UISearchBar!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var signalisationView: UIView!
    @IBOutlet weak var signalisationLabel: UILabel!
    @IBOutlet weak var signalisationButton: UIButton!
    var userPosition : CLLocationCoordinate2D?
    var locationManager : CLLocationManager!
    
    var stationList = [Station]()
    var tempStationList = [Station]()
    let stationsCellId = "stationsCellId"
    
    var commitPredicate: NSPredicate?
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
        ControleurRequest.getStationsList(completion: { (data) in
            self.stationList = data
            self.tempStationList = data
            self.stationsTableView.reloadData()
            
        })
        setupHomeView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupHomeView(){
        stationSearchBar.isHidden = true
        stationSearchBar.delegate = self
        stationsTableView.isHidden = true
        stationsTableView.delegate = self
        stationsTableView.dataSource = self
        stationsTableView.layer.cornerRadius = 4
        stationSearchBar.layer.cornerRadius = 4
        
        let stationNib = UINib(nibName: "StationTableViewCell", bundle: nil)
        stationsTableView.register(stationNib, forCellReuseIdentifier: stationsCellId)
        titleLabel.text = "Frauding"
        searchButton.layer.cornerRadius = 4
        searchButton.layer.borderColor = UIColor.lightGray.cgColor
        searchButton.layer.borderWidth = 1
        
        signalisationView.backgroundColor = .red
        signalisationView.layer.cornerRadius = 4
        signalisationLabel.text = "Signaler"
        signalisationButton.addTarget(self, action: #selector(report), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(goToRoute), for: .touchUpInside)
        
        
        let searchText = "Gare"
        let predicate = NSPredicate(format: "name contains [cd] %@", searchText)
       
    }
    
    @objc func goToRoute() {
        let routeViewController = RouteViewController()
        routeViewController.modalPresentationStyle = .overCurrentContext
        present(routeViewController, animated: true, completion: nil)
    }
    
    @objc func report(){
        guard let postition = userPosition else {return}
        stationSearchBar.isHidden = false
        stationsTableView.isHidden = false
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

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stationsCellId, for: indexPath) as! StationTableViewCell
        cell.stationNameLabel.text = tempStationList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let idToSend = tempStationList[indexPath.row].id_name else {
            return
        }
        ControleurRequest.reportControleur(id: idToSend) { (response) in
            if response {
                self.stationSearchBar.isHidden = true
                self.stationsTableView.isHidden = true
                self.signalisationView.backgroundColor = .green
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                   self.signalisationView.backgroundColor = .red
                }

            }
        }
    }
    
    
}
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        tempStationList.removeAll()
        for station in stationList {
            let range = station.name?.lowercased().range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
            if range != nil {
                tempStationList.append(station)
            }
        }
      stationsTableView.reloadData()
    }
}
