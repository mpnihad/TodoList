//
//  CategoryViewController.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    

    
    
    var categoryBrain = CategoryBrain()
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todo to Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction (title: "Add Item", style: .default){ action in
            
            
            
            self.categoryBrain.addItem(name: textField.text) { category in
                
                DispatchQueue.main.async {
                    
                    
                    self.tableView.reloadData()
                    
                    
                    self.saveItem(category: category)
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
    
    override func viewWillAppear(_ animation:Bool)
    {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Nav error -- Not found")
        }
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hexString : "1D9BF6")
        
        navBar.scrollEdgeAppearance = appearance
        
        
    }
    
    
    func loadData(){
        
    }
    
    
    override func updateModels(at indexPath: IndexPath) {
        self.categoryBrain.deleteItem(at: indexPath.row){
            DispatchQueue.main.async {


                self.tableView.reloadData()
            }
        }
        
    }
   
    
    
    
}
// MARK: - Table view data source

extension CategoryViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = categoryBrain.categoryItems?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No Categories added"
        //        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        cell.backgroundColor = UIColor(hexString:item?.color ?? "ffffff") 
        
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryBrain.categoryItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let selectedCategory = categoryBrain.categoryItems[indexPath.row]{
            categoryBrain.selectedCategory = categoryBrain.categoryItems?[indexPath.row]
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
    
    
    
    
    
    
    func saveItem(category: Category) {
        
        do{
            
            try categoryBrain.realm.write(){
                categoryBrain.realm.add(category)
            }
            
        }
        catch {
            
            print("Error Saving \(error)")
            
        }
        tableView.reloadData()
    }
    
    
   

    
    
}
