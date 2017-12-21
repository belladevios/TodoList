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
        item2.title = "Shoping"
        self.itemsArray.append(item2)
        
        let item3 = Item()
        item3.title = "Travelling"
        self.itemsArray.append(item3)
    }

    //MARK: Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = self.itemsArray[indexPath.row].title
        cell.accessoryType = self.itemsArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.itemsArray[indexPath.row].done = !self.itemsArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.tableView.reloadData()
    }
    
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add task", message: "", preferredStyle: .alert)
        alert.addTextField { (aTextfield) in
            aTextfield.placeholder = "add your item"
            textField = aTextfield
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alertAction) in
            if let title = textField.text{
                let item = Item()
                
                item.title = title
                self.itemsArray.append(item)
                self.tableView.reloadData()
            }
           
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

