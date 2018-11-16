//
//  RouteStepViewController.swift
//  Frauding
//
//  Created by Isma Dia on 06/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import UIKit

class RouteStepViewController: UIViewController {
    
    @IBOutlet weak var arrivéeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var okButton: UIButton!
    var routes : [Route]? {
        didSet {
        }
    }
    
    let routeStepCellId = "routeStepCellId"
    @IBOutlet weak var routeStepTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = UIColor.mainColor()
        routeStepTableView.delegate = self
        routeStepTableView.dataSource = self
        let routeStepNib = UINib(nibName: "RouteStepTableViewCell", bundle: nil)
        routeStepTableView.register(routeStepNib, forCellReuseIdentifier: routeStepCellId)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        okButton.addTarget(self, action: #selector(closeRouteController), for: .touchUpInside)
        containerView.layer.cornerRadius = 10
        okButton.layer.cornerRadius = 4
        okButton.backgroundColor = UIColor.greenColor()
        guard let arrivée = routes?.last?.to_name_station else {return}
        destinationLabel.text = " Vers \(arrivée)"
        arrivéeLabel.isHidden = true
        arrivéeLabel.text = " Vers \(arrivée)"
        arrivéeLabel.textColor = UIColor.greenColor()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func closeRouteController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension RouteStepViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: routeStepCellId, for: indexPath) as! RouteStepTableViewCell
        let route = routes![indexPath.row]
        cell.départLabel.text = route.from_name_station
        if(route.transfer_type?.elementsEqual("walking"))!{
            cell.metroLabel.text = "à pied"
            cell.metroLabel.isHidden = false
            cell.logoMImage.isHidden = true
            cell.metroImage.isHidden = true
            
        }else{
            // cell.metroLabel.text = UidDef.metroDictionary[route.vehicule!]
            let metroImageName = UidDef.metroImageDictionary[route.vehicule!]
            cell.metroImage.image = UIImage(named: metroImageName!)
            cell.logoMImage.isHidden = false
            cell.metroImage.isHidden = false
            cell.metroLabel.isHidden = true
            
        }
        let portique_name = route.portique_from?.name
        if portique_name != nil {
             cell.portiqueLabel.text = "Portique : \(route.portique_from!.name!.uppercased())"
        }

        cell.arrivéeLabel.text = route.to_name_station
        let controleurs = (route.stop_point_from_controleurs?.intValue)!
        if (controleurs > 0) {
            //cell.backgroundColor = .red
            cell.controleurImageView.isHidden = false
        }
        return cell
    }
    
    
}
