//
//  ViewController.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2017-12-21.
//  Copyright © 2017 Bella Diallo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemsArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = Item()
        item1.title = "Cleaining"
        self.itemsArray.append(item1)
        
        let item2 = Item()
        item2.title = "Cleaining"
        self.itemsArray.append(item2)
        
        let item3 = Item()
        item3.title = "Cleaining"
        self.itemsArray.append(item3)
    }

    //MARK: Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = self.itemsArray[indexPath.row].title
        
        return cell
    }
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

