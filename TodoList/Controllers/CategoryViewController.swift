//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2018-01-18.
//  Copyright © 2018 Bella Diallo. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCategories()
    }
    
    //MARK:- Table view Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = self.categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK:- Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! TodoListViewController
                destinationViewController.selectedCategory = self.categories?  [indexPath.row]
            }
        }
        
    }
    
    
    //MARK: - add button pressed method
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (aTextField) in
            textField = aTextField
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            if let text = textField.text {
                let newCategory = Category()
                newCategory.name = text
                
                self.save(category: newCategory)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func save(category:Category)  {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {

        categories = realm.objects(Category.self)
        
        self.tableView.reloadData()
    }
    
}
