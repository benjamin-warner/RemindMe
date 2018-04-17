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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(Auth.auth().currentUser != nil){
            performSegue(withIdentifier: "AuthProcessor", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginOptionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            newUser = false
            LoginActionButton.setTitle("Log In", for: .normal)
            break
        case 1:
            newUser = true
            LoginActionButton.setTitle("Signup", for: .normal)
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
                if(error == nil){
                    print("cool")
                    self.performSegue(withIdentifier: "AuthProcessor", sender: self)
                }
                else{
                    print("Uncool")
                    print("\(error.debugDescription)")
                }
            }
        }
        else{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
