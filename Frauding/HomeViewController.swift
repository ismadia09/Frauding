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

    @IBOutlet weak var signalisationContainer: UIView!
    @IBOutlet weak var userPositionButton: UIButton!
    @IBOutlet weak var homeMapView: MKMapView!
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
    let signalisationColor = UIColor.greenColor()
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
        let storeCoordinates = CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        let region = MKCoordinateRegionMakeWithDistance(storeCoordinates, 250, 250)
        homeMapView.setRegion(region, animated: true)
        userPositionButton.layer.cornerRadius = 5
        stationSearchBar.delegate = self
        setupHomeView()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func getUserPosition(_ sender: Any) {
        setupMap()
    }
    func setupHomeView(){
    
        searchButton.tintColor = UIColor.greenColor()
        searchButton.setTitleColor(UIColor.greenColor(), for: .normal)
        
        searchButton.backgroundColor = UIColor.mainColor()
        signalisationContainer.backgroundColor = UIColor.mainColor()
        signalisationView.backgroundColor = UIColor.mainColor()
        view.backgroundColor = UIColor.mainColor()
        stationSearchBar.isHidden = true
        stationSearchBar.delegate = self
        stationsTableView.isHidden = true
        stationsTableView.delegate = self
        stationsTableView.dataSource = self
        stationsTableView.separatorColor = .clear
        stationsTableView.layer.cornerRadius = 4
        stationsTableView.backgroundColor = UIColor.mainColor()
        stationSearchBar.layer.cornerRadius = 4
        stationSearchBar.backgroundColor = UIColor.mainColor()
        
        let stationNib = UINib(nibName: "StationTableViewCell", bundle: nil)
        stationsTableView.register(stationNib, forCellReuseIdentifier: stationsCellId)
        titleLabel.text = "Frauding"
        searchButton.layer.cornerRadius = 4
        
        signalisationView.backgroundColor = UIColor.mainColor()
        signalisationView.layer.borderColor = signalisationColor.cgColor
        signalisationView.layer.borderWidth = 2
        signalisationView.layer.cornerRadius = 8
        signalisationLabel.text = "Signaler"
        signalisationLabel.textColor = signalisationColor
        signalisationButton.addTarget(self, action: #selector(report), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(goToRoute), for: .touchUpInside)
        
        
        let searchText = "Gare"
        let predicate = NSPredicate(format: "name contains [cd] %@", searchText)
       
    }
    
    @objc func goToRoute() {
        let routeViewController = RouteViewController()
        routeViewController.userPosition = userPosition
        routeViewController.modalPresentationStyle = .overCurrentContext
        present(routeViewController, animated: true, completion: nil)
        stationSearchBar.resignFirstResponder()
    }
    
    @objc func report(){
        
        //CustomNotifications.sendNotification(fcmToken: <#T##String#>, station: <#T##String#>)
        signalisationLabel.isHidden = true
        stationSearchBar.isHidden = false
        stationsTableView.isHidden = false
        
    }
    
    
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let localisation = locations.first{
            manager.distanceFilter = 20
            userPosition = localisation.coordinate
            print(localisation.coordinate)
            setupMap()
            //startPositionTextField.text = "User Location \(userPosition)"
        }
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempStationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stationsCellId, for: indexPath) as! StationTableViewCell
        cell.stationNameLabel.text = tempStationList[indexPath.row].name
        cell.metroLabel.text = tempStationList[indexPath.row].id_name
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
                self.stationSearchBar.text = ""
                self.tempStationList.removeAll()
                self.stationSearchBar.isHidden = true
                self.signalisationView.backgroundColor = self.signalisationColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                   self.signalisationView.backgroundColor = UIColor.mainColor()
                    self.stationSearchBar.isHidden = true
                    self.signalisationLabel.isHidden = false
                    tableView.reloadData()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeViewController : MKMapViewDelegate {
    func setupMap(){
        guard let latitude = userPosition?.latitude,
            let longitude = userPosition?.longitude else {
                return
        }
        let storeCoordinates = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegionMakeWithDistance(storeCoordinates, 250, 250)
        //let region = MKCoordinateRegionMake(storeCoordinates, MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let annotation = MKPointAnnotation()
        annotation.coordinate = storeCoordinates
        homeMapView.delegate = self
        homeMapView.mapType = MKMapType.standard
        homeMapView.isZoomEnabled = true
        homeMapView.isScrollEnabled = true
        homeMapView.removeAnnotations(homeMapView.annotations)
        homeMapView.addAnnotation(annotation)
        homeMapView.setRegion(region, animated: true)
        homeMapView.setCenter(storeCoordinates, animated: true)
        
    }

}
