//
//  ViewController.swift
//  TodoList
//
//  Created by Nihad-Mac on 29/11/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var todoBrain = TodoBrain()
    
    var categoryName : Category? {
        didSet {
            todoBrain.loadItems(category: categoryName!) {
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    
    let  dataFilePath  = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist", isDirectory: false)
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        //        let decoder = PropertyListDecoder()
        
        searchBar.delegate = self
        
        
        
        
        
        //        if let items =  (defaults.object(forKey: "TodoListArray")) as? [Item] {
        //            todoBrain.itemArray = items
        //
        //        }
    }
    
    
    
    
    //MARK: - UITableViewProtocol
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return todoBrain.itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = todoBrain.itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isChecked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        todoBrain.selectOrDeselectItem(at: indexPath.row){[weak self] in
            
            DispatchQueue.main.async{
                
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
                
                cell.accessoryType =  self?.todoBrain.itemArray[indexPath.row].isChecked ?? false ? .checkmark : .none
                
                
                
                //        context.delete(todoBrain.itemArray[indexPath.row])
                //        todoBrain.itemArray.remove(at: indexPath.row)
                
                self?.saveItem()
                
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
    
    
    //MARK: - Add New Item
    
    //Core data
    //     func saveItem() {
    //        let encoder = PropertyListEncoder()
    //
    //        do{
    //            let data = try encoder.encode(self.todoBrain.itemArray)
    //
    //            if let filePath = self.dataFilePath {
    //                try data.write(to: filePath)
    //
    //            }
    //        }
    //        catch {
    //            print(error.localizedDescription)
    //
    //        }
    //         tableView.reloadData()
    //    }
    
    //    func loadItems() {
    
    //        do{
    //
    //
    //
    //            if let filePath = self.dataFilePath {
    //                let datas = try? Data(contentsOf: filePath)
    //                item(context:self.context)
    //                if let data = datas{
    //                    todoBrain.itemArray =  try decoder.decode([Item].self, from: data)
    //                }
    //
    //            }
    //        }
    //        catch {
    //            print(error.localizedDescription)
    //
    //        }
    //    }
    
    
    
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert =  UIAlertController(title: "Add New Todo to Item", message: "", preferredStyle: .alert)
        
        
        let action = UIAlertAction (title: "Add Item", style: .default){ action in
            
            self.todoBrain.addItem(name:  textField.text){ [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    
                    
                    self?.saveItem()
                }
            }
            //            if let item ={
            //
            //
            //
            //
            //
            //
            //                //                self.defaults.setValue(self.todoBrain.itemArray, forKey: "TodoListArray")
            //            }
            
            
        }
        
        alert.addTextField{ alertTextField in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true) {
            
        }
        
    }
    
    
}


//MARK: - Search Bar

extension TodoListViewController : UISearchBarDelegate {
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
        
        let predicateItem  = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text ?? "")
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        todoBrain.loadItems(with : request,predicate : predicateItem){
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
    }
    //    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    //        loadItems()
    //    }
    //
    //
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            todoBrain.loadItems(){
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
    
}

//MARK: - CoreData data source logics

extension TodoListViewController {
    
    
    
    
    
    
    func saveItem() {
        
        do{
            
            try todoBrain.context.save()
            
        }
        catch {
            
            print("Error Saving \(error)")
            
        }
        tableView.reloadData()
    }
    
    
}

