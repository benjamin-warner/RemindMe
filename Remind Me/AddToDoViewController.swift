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
        
        // This allows to hide the keyboard on tapping another location.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddToDoViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func onSubmit(_ sender: UIButton) {
        var text = todoText.text!
        todoText.text = ""
        if(text == ""){
            text = "No description."
        }
        let dateUnix = Int(todoDate.date.timeIntervalSince1970)
        
        // Get firebase Database reference, User ID
        let dbReference = Database.database().reference()
        let userId: String = Auth.auth().currentUser!.uid
    
        // Let firebase generate an ID for the new database entry
        let key = dbReference.child(userId+"/ToDos").childByAutoId().key
        
        // Create new ToDo Object
        let newToDo = ["Text" : text, "Time" : dateUnix] as [String : Any]
        
        // Update database with new ToDo
        let update = ["\(userId)/ToDos/\(key)" : newToDo]
        dbReference.updateChildValues(update)
    }
}

// This allows to hide the keyboard on tapping another location.
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
