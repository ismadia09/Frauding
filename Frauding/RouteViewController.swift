//
//  RouteViewController.swift
//  Frauding
//
//  Created by Isma Dia on 04/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class RouteViewController: UIViewController {
    
    @IBOutlet weak var containerTopAnchor: NSLayoutConstraint!
    var itineraires = [Itineraire]()
    var allItinerairesInfos = [[String : Any]]()
    @IBOutlet weak var searchDestinationBar: UISearchBar!
    @IBOutlet weak var arrivalPositionTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var startPositionTextField: UITextField!
    
    @IBOutlet weak var routeTableView: UITableView!
    
    @IBOutlet weak var walkingRouteButton: UIButton!
    
    
    let routeCellId = "routeCellId"
    let searchDestinationCellId = "searchDestinationCellId"
    var locationManager : CLLocationManager!
    var userPosition : CLLocationCoordinate2D?
    var arrivalPosition : CLLocationCoordinate2D?
    let searchDestinationTableView = UITableView()
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
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
        
        searchCompleter.delegate = self
        searchDestinationBar.delegate = self
        setupRouteView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func closeRouteController(){
        self.dismiss(animated: true, completion: nil)
    }
    func setupRouteView(){
        //startPositionTextField.isEnabled = false
        //arrivalPositionTextField.isHidden = true
        closeButton.addTarget(self, action: #selector(closeRouteController), for: .touchUpInside)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView.layer.cornerRadius = 4
        routeTableView.delegate = self
        routeTableView.dataSource = self
        let routeNib = UINib(nibName: "RouteTableViewCell", bundle: nil)
        routeTableView.register(routeNib, forCellReuseIdentifier: routeCellId)
        
        searchDestinationTableView.delegate = self
        searchDestinationTableView.dataSource = self
        let searchDestinationNib = UINib(nibName: "SearchDestinationTableViewCell", bundle: nil)
        searchDestinationTableView.register(searchDestinationNib, forCellReuseIdentifier: searchDestinationCellId)
        
        view.addSubview(searchDestinationTableView)
        searchDestinationTableView.translatesAutoresizingMaskIntoConstraints = false
        searchDestinationTableView.leadingAnchor.constraint(equalTo: searchDestinationBar.leadingAnchor).isActive = true
        searchDestinationTableView.topAnchor.constraint(equalTo: searchDestinationBar.bottomAnchor, constant: 0).isActive = true
        searchDestinationTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        searchDestinationTableView.widthAnchor.constraint(equalTo: searchDestinationBar.widthAnchor).isActive = true
        searchDestinationTableView.layer.cornerRadius = 4
        
        searchDestinationTableView.isHidden = true
        
        
        
    }
}

extension RouteViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.routeTableView) {
            return 100
        }
        if (tableView == self.searchDestinationTableView){
            return 75
        }
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.routeTableView) {
            return itineraires.count
        }
        if (tableView == self.searchDestinationTableView){
            return searchResults.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if (tableView == self.routeTableView) {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: routeCellId, for: indexPath) as! RouteTableViewCell
            cell1.duréeLabel.text = allItinerairesInfos[indexPath.row]["duration"] as! String
            cell1.métroLabel.text = allItinerairesInfos[indexPath.row]["metro"] as! String
            cell1.infosLabel.text = allItinerairesInfos[indexPath.row]["walking"] as! String
            cell = cell1
        }
        
        if (tableView == self.searchDestinationTableView){
            // let  cell2 = tableView.dequeueReusableCell(withIdentifier: searchDestinationCellId, for: indexPath) as! SearchDestinationTableViewCell
            //cell = cell2
            let searchResult = searchResults[indexPath.row]
            let cell2 = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            cell2.textLabel?.text = searchResult.title
            cell2.detailTextLabel?.text = searchResult.subtitle
            cell = cell2
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (tableView == self.searchDestinationTableView){
            let completion = searchResults[indexPath.row]
            
            let searchRequest = MKLocalSearchRequest(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                let coordinate = response?.mapItems[0].placemark.coordinate
                print("*********")
                print(String(describing: coordinate))
                print("*********")
                self.arrivalPosition = coordinate
                if (self.userPosition != nil && self.arrivalPosition != nil){
                    //                self.itineraires =  RouteRequest.getRoute(from: self.userPosition!, to: self.arrivalPosition!)
                    
                    RouteRequest.getRoute(from: self.userPosition!, to: self.arrivalPosition!, completion: { (data) in
                        self.itineraires = data
                        print(self.itineraires)
                        self.searchDestinationTableView.isHidden = true
                        self.allItinerairesInfos = self.itinerairesInfo(self.itineraires)
                        self.routeTableView.reloadData()
                    })
                    
                }
            }
        }
        
        if (tableView == self.routeTableView){
            let routeStepViewController = RouteStepViewController()
            guard let routes = self.itineraires[indexPath.row].routes else {return}
            routeStepViewController.routes = routes
            routeStepViewController.modalPresentationStyle = .overCurrentContext
            self.present(routeStepViewController, animated: true, completion: nil)
        }
    }
    
    func itinerairesInfo(_ itineraires: [Itineraire]) -> [[String : Any]] {
        var allItinerairesInfo = [[String : Any]]()
        for itineraire in itineraires {
            guard let routes = itineraire.routes else {
                return allItinerairesInfo
            }
            var duration = 0
            var metroList : String = ""
            var walkingDuration = 0
            var itinerairesInfo : [String : String] = ["duration":"","destination":"", "metro":"", "walking":""]
            for route in routes {
                duration += (route.duration?.intValue)!
                let vehicleType = route.type!
                if vehicleType.elementsEqual("public_transport") {
                    let vehicule = UidDef.metroDictionary[route.vehicule!]
                    metroList.append("\(vehicule!) ")
                }
                if vehicleType.elementsEqual("street_network") {
                    walkingDuration += (route.duration?.intValue)!
                }
                
            }
            let destination = routes.last?.to_name_station
            searchDestinationBar.text = destination
            itinerairesInfo.updateValue("\(duration) minutes", forKey: "duration")
            itinerairesInfo.updateValue("\(destination)", forKey: "destination")
            itinerairesInfo.updateValue("\(metroList)", forKey: "metro")
            itinerairesInfo.updateValue("\(walkingDuration) mins à pied", forKey: "walking")
            allItinerairesInfo.append(itinerairesInfo)
        }
        
        return allItinerairesInfo
    }
}
extension RouteViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let localisation = locations.first {
            userPosition = localisation.coordinate
            print(localisation.coordinate)
            //startPositionTextField.text = "Ma Position"
        }
    }
}

extension RouteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchDestinationTableView.isHidden = false
        changeConstraint( constant: 150)    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        changeConstraint( constant: 400)    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        changeConstraint( constant: 400)
        searchBar.resignFirstResponder()
        
    }
    
    private func changeConstraint(constant : CGFloat ){
        
        containerTopAnchor.constant = constant
        searchDestinationTableView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        searchDestinationTableView.isHidden = false


        
    }
}

extension RouteViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchDestinationTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}




