//
//  scrollViewController.swift
//  testMovie
//
//  Created by Fahim Mashroor on 10/11/25.
//

import UIKit

class scrollViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameButton: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var countryField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameButton.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
        numberField.delegate = self
        countryField.delegate = self
        
        nameButton.placeholder = "Name"
        passwordField.placeholder = "Password"
        emailField.placeholder = "Email"
        numberField.placeholder = "Phone Number"
        countryField.placeholder = "Country"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            if textField.text == textField.placeholder {
                textField.text = ""
            }
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
           if textField.text?.isEmpty == true {
                textField.text = textField.placeholder
            }
        }
    
    
    @IBAction func clearButton(_ sender: Any) {
        nameButton.text = ""
        passwordField.text = ""
        emailField.text = ""
        numberField.text = ""
        countryField.text = ""
        
        nameButton.placeholder = "Name"
        passwordField.placeholder = "Password"
        emailField.placeholder = "Email"
        numberField.placeholder = "Phone Number"
        countryField.placeholder = "Country"
        
        print("Data Cleared!")
    }
    @IBAction func submitButton(_ sender: Any) {
        
        guard let name = nameButton.text, !name.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let number = numberField.text, !number.isEmpty,
              let country = countryField.text, !country.isEmpty else{
            print("Error!")
            return
        }
        
        let data : [String : String] = [
            
            "name" : name,
            "password" : password,
            "email" : email,
            "number" : number,
            "country" : country
        ]
        
        RoutingController.goToResultViewController(from: self, with: data)

    }

   
    
}
