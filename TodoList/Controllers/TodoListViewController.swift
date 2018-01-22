//
//  ViewController.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2017-12-21.
//  Copyright © 2017 Bella Diallo. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var todoItems: Results<Item>?

    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
        self.loadItems()
    }

    //MARK: Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = self.todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    item.done = !item.done
                }
            } catch{
                print("Error saving done status   \(error)")
            }
            
        }
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
            
            if let title = textField.text, let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                       
                        let newItem = Item()
                        newItem.title = title
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("Error saving item \(error)")
                }
            }
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Model Manupulation Methods
    
    func loadItems() -> Void {
       
        self.todoItems = self.selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        self.tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController:UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        self.todoItems = self.todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        self.tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

