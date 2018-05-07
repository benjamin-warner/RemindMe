//
//  LoginViewController.swift
//  Remind Me
//
//  Created by Benjamin Warner on 4/17/18.
//  Copyright © 2018 Benjamin Warner. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var LoginActionButton: UIButton!
    
    var newUser: Bool = false
    
    @IBAction func LoginOptionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            newUser = false
            LoginActionButton.setTitle("Log In", for: .normal)
            break
        case 1:
            newUser = true
            LoginActionButton.setTitle("Register", for: .normal)
            break
        default:
            break
        }
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        let email = self.userEmail.text != nil ? self.userEmail.text! : ""
        let password = self.userPassword.text != nil ? self.userPassword.text! : ""
        
        if(email != "" && password != ""){
            handleAuth(email: email, password: password)
        }
    }
    
    func handleAuth(email: String, password: String){
        if(newUser){
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                self.handleFirebaseResponse(error: error)
            }
        }
        else{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                self.handleFirebaseResponse(error: error)
            }
        }
    }
    
    func handleFirebaseResponse(error: Error?){
        if(error == nil){
            print("cool")
            self.performSegue(withIdentifier: "AuthProcessor", sender: self)
        }
        else{
            print("Uncool")
            print("\(error.debugDescription)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
