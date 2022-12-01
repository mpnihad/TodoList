//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    
    var categoryBrain = CategoryBrain()
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todo to Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction (title: "Add Item", style: .default){ action in
            
            self.categoryBrain.addItem(name:  textField.text){ [weak self] in
                
                DispatchQueue.main.async {
                    
                    
                    self?.tableView.reloadData()
                    
                    
                    self?.saveItem()
                }}
            
            
            
        }
        
        alert.addTextField{ alertTextField in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true) {
            
        }
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryBrain.loadItems(){
            tableView.reloadData()
        }
        
    }
    
    
    
    func loadData(){
        
    }
    
    
}
// MARK: - Table view data source

extension CategoryViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItem", for: indexPath)
        let item = categoryBrain.categoryItems[indexPath.row]
        cell.textLabel?.text = item.name
        //        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryBrain.categoryItems.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let selectedCategory = categoryBrain.categoryItems[indexPath.row]{
            categoryBrain.selectedCategory = categoryBrain.categoryItems[indexPath.row]
            performSegue(withIdentifier: "GotoItemsView", sender: self)
//        }
       
        
    }
    
    
}

//MARK: - Segue Pass Data

extension CategoryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC : TodoListViewController = segue.destination as! TodoListViewController
        destinationVC.categoryName = categoryBrain.selectedCategory
    }
}






//MARK: - CoreData data source logics
extension CategoryViewController {
    
    
    
    
    
    
    func saveItem() {
        
        do{
            
            try categoryBrain.context.save()
            
        }
        catch {
            
            print("Error Saving \(error)")
            
        }
        tableView.reloadData()
    }
    
    
}



