//
//  ViewController.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2017-12-21.
//  Copyright © 2017 Bella Diallo. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemsArray = [Item]()

    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50.0
        
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
        
        //TODO: Take care about order of removing item:
        //first: remove from context
        // then delete in itemArray
//        context.delete(itemsArray[indexPath.row]) // first
//        itemsArray.remove(at: indexPath.row)  // two

        self.itemsArray[indexPath.row].done = !self.itemsArray[indexPath.row].done
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.saveItems()
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
                
                let newItem = Item(context: self.context)
                newItem.title = title
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemsArray.append(newItem)
                
                self.saveItems()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Model Manupulation Methods
    func saveItems() -> Void {
        //encode data to Items.plist
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil) -> Void {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemsArray = try context.fetch(request)
        }catch {
            print("Error fetching data fron context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
}

//MARK: - Search bar methods
extension TodoListViewController:UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
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

