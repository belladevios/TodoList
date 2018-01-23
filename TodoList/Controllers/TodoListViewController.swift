//
//  ViewController.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2017-12-21.
//  Copyright © 2017 Bella Diallo. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var todoItems: Results<Item>?

    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        self.loadItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        guard let hexColour = self.selectedCategory?.colour else {fatalError()}
        
        self.updateNavBar(withHexCode: hexColour)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.updateNavBar(withHexCode: "3690E2")
    }
    
    func updateNavBar(withHexCode hexColour:String) -> Void {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist !!!")}
        
        guard let navBarColour = UIColor(hexString:hexColour) else {fatalError("Can't create colour from hexString: \(hexColour) !!!")}
        
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.barTintColor = navBarColour
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:ContrastColorOf(navBarColour, returnFlat: true)]
        
        self.searchBar.barTintColor = navBarColour
    }
    
    //MARK: Table view Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = self.todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let colour = UIColor(hexString: self.selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(self.todoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
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
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
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

