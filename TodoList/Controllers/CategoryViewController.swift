//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2018-01-18.
//  Copyright © 2018 Bella Diallo. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories : [Category] = [Category]()
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadCategories()
    }
    
    //MARK:- Table view Datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = self.categories[indexPath.row].name
        
        return cell
    }
    
    //MARK:- Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationViewController = segue.destination as! TodoListViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                destinationViewController.selectedCategory = self.categories[indexPath.row]
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
                let newCategory = Category(context: self.context)
                newCategory.name = text
                
                self.categories.append(newCategory)
                
                self.saveCategories()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories()  {
        
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            self.categories = try self.context.fetch(request)
        } catch  {
            print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }
    
}
