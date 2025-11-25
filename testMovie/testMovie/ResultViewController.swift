//
//  ResultViewController.swift
//  testMovie
//
//  Created by Fahim Mashroor on 11/11/25.
//

import UIKit
import Alamofire


class ResultViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var recievedData: [String : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = recievedData {
            nameLabel.text = "\(data["name"] ?? "")"
            passwordLabel.text = "\(data["password"] ?? "")"
            emailLabel.text = "\(data["email"] ?? "")"
            numberLabel.text = "\(data["number"] ?? "")"
            countryLabel.text = "\(data["country"] ?? "")"
        }
    }
    
    @IBAction func goToMoviesButton(_ sender: Any) {
        RoutingController.goToTableViewController(from: self)
    }
    
}
