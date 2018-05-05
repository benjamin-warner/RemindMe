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
    var Text: String!
    var Time: Int!
}

class TodoListViewController: UITableViewController {

    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbReference = Database.database().reference()
        let userId: String = Auth.auth().currentUser!.uid
        
        // Listen for new todos in the Firebase database
        dbReference.child(userId).queryOrderedByKey().observe(.childAdded, with: { (snapshot) -> Void in
            let snapshotValue = snapshot.value as? NSDictionary
            let text = snapshotValue?["Text"] as? String
            let time = snapshotValue?["Time"] as? Int
            self.todos.append(ToDo(Text: text, Time: time))
            self.tableView.reloadData()
                
        })
        
//        // Listen for deleted todos in the Firebase database
//        dbReference.observe(.childRemoved, with: { (snapshot) -> Void in
//            let index = self.todos.indexOfMessage(snapshot)
//            self.todos.remove(at: index)
//            self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionComments)], with: UITableViewRowAnimation.automatic)
//        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        cell.descriptionLabel?.text = todos[indexPath.row].Text
        let date = Date(timeIntervalSince1970: Double(todos[indexPath.row].Time))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = formatter.string(from: date)
        cell.dateLabel?.text = formattedDate
        return cell
    }
}
