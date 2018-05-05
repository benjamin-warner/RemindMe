//
//  AddToDoViewController.swift
//  Remind Me
//
//  Created by Benjamin Warner on 5/5/18.
//  Copyright © 2018 Benjamin Warner. All rights reserved.
//

import UIKit
import Firebase

class AddToDoViewController: UIViewController {

    @IBOutlet weak var todoText: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddToDoViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        let text = todoText.text ?? "No description"
        let dateUnix = Int(todoDate.date.timeIntervalSince1970)
        
        // Get firebase Database reference, User ID
        let dbReference = Database.database().reference()
        let userId: String = Auth.auth().currentUser!.uid
    
        // Let firebase generate an ID for the new database entry
        let key = dbReference.child(userId).child("ToDos").childByAutoId().key
        
        // Create new ToDo Object
        let newToDo = ["Text" : text, "Time" : dateUnix] as [String : Any]
        
        // Update database with new ToDo
        let update = ["\(userId)/\(key)" : newToDo]
        dbReference.updateChildValues(update)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
