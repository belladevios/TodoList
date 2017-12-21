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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadItems()
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
        
        self.saveItems()
    }
    
    //MARK:-
    func saveItems() -> Void {
        //encode data to Items.plist
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemsArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error to ecode data !!!!")
        }
        self.tableView.reloadData()
    }
    
    func loadItems() -> Void {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let  decoder = PropertyListDecoder()
            do
            {
                self.itemsArray = try decoder.decode([Item].self, from: data)
            } catch{
                print(print("Error to decode data !!!!"))
            }
        }
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
                
                self.saveItems()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

