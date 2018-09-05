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

class RouteViewController: UIViewController {
 
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
        //searchDestinationBar.isHidden = true
        closeButton.addTarget(self, action: #selector(closeRouteController), for: .touchUpInside)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
        searchDestinationTableView.leadingAnchor.constraint(equalTo: arrivalPositionTextField.leadingAnchor).isActive = true
        searchDestinationTableView.topAnchor.constraint(equalTo: arrivalPositionTextField.bottomAnchor, constant: 0).isActive = true
        searchDestinationTableView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        searchDestinationTableView.widthAnchor.constraint(equalTo: arrivalPositionTextField.widthAnchor).isActive = true
        
        
    }
}

extension RouteViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.routeTableView) {
            return 3
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
        }
      }
    }
}
extension RouteViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let localisation = locations.first {
            userPosition = localisation.coordinate
            print(localisation.coordinate)
            startPositionTextField.text = "User Location \(userPosition)"
        }
    }
}

extension RouteViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
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




