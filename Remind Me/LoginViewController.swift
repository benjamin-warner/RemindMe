//
//  LoginViewController.swift
//  Remind Me
//
//  Created by Benjamin Warner on 4/17/18.
//  Copyright © 2018 Benjamin Warner. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var LoginActionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginOptionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            LoginActionButton.setTitle("Log In", for: .normal)
            break
        case 1:
            LoginActionButton.setTitle("Signup", for: .normal)
            break
        default:
            break
        }
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
