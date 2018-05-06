//
//  ViewController.swift
//  Remind Me
//
//  Created by Benjamin Warner on 4/17/18.
//  Copyright © 2018 Benjamin Warner. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var currentCount: UILabel!
    @IBOutlet weak var finishedCount: UILabel!
    @IBOutlet weak var avgTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get current user's email
        userName.text = Auth.auth().currentUser!.email
        
        // Get Firebase references
        let dbReference = Database.database().reference()
        let userId = Auth.auth().currentUser!.uid
        
        // Get ToDo count
        dbReference.child(userId).child("Count").observe(.value, with: { (snapshot) in
            if let count = snapshot.value as? Int {
                self.currentCount.text = String(count)
            }
            else{
                self.currentCount.text = String(0)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}

