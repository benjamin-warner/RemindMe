//
//  TodoListViewController.swift
//  Remind Me
//
//  Created by Benjamin Warner on 5/5/18.
//  Copyright © 2018 Benjamin Warner. All rights reserved.
//

import UIKit
import Firebase

struct ToDo{
    var Id: String
    var Text: String!
    var Time: Int!
}

class TodoListViewController: UITableViewController {
    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbReference = Database.database().reference()
        let userToDoDirectory: String = Auth.auth().currentUser!.uid + "/ToDos"
        
        // Listen for new todos in the Firebase database
        dbReference.child(userToDoDirectory).queryOrderedByKey().observe(.childAdded, with: { (snapshot) -> Void in
            let snapshotValue = snapshot.value as? NSDictionary
            let text = snapshotValue?["Text"] as? String
            let time = snapshotValue?["Time"] as? Int
            self.todos.append(ToDo(Id: snapshot.key, Text: text, Time: time))
            self.tableView.reloadData()
                
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            // Remove from Firebase
            let dbReference = Database.database().reference()
            let userToDoDirectory: String = Auth.auth().currentUser!.uid + "/ToDos"
            dbReference.child(userToDoDirectory).child(todos[indexPath.row].Id).removeValue()
            
            // Remove from local array
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            incrementCompletedCount()
        }
    }
    
    func incrementCompletedCount() {
        // Get firebase Database reference, User ID
        let dbReference = Database.database().reference()
        let userId: String = Auth.auth().currentUser!.uid
        
        // This gets the ToDo count value, then increments it.
        dbReference.child(userId).child("Finished").observeSingleEvent(of: .value, with: { snapshot in
            if let count = snapshot.value as? Int {
                let newCount = count + 1
                dbReference.child(userId).child("Finished").setValue(newCount)
            }
            else{
                // Set to 1 if no ToDo has been added until now.
                dbReference.child(userId).child("Finished").setValue(1)
            }
        })
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        
        // Format date to string
        let date = Date(timeIntervalSince1970: Double(todos[indexPath.row].Time))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = formatter.string(from: date)
        
        // Assign label values
        cell.dateLabel?.text = formattedDate
        cell.descriptionLabel?.text = todos[indexPath.row].Text
        
        return cell
    }
    
    @IBAction func enableEditing(_ sender: Any) {
        self.setEditing(!self.isEditing, animated: true)
    }
}
