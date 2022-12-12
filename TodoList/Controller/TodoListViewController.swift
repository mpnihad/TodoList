//
//  ViewController.swift
//  TodoList
//
//  Created by Nihad-Mac on 29/11/22.
//

import UIKit
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    
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
        //            todoBrain.todoItems = items
        //
        //        }
    }
    
    
    override func viewWillAppear(_ animated:Bool)
    {
        if let colors = todoBrain.categoryName?.color{
            
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Nav error -- Not found")
            }
            
            if let color = UIColor(hexString: colors){
                
//                navBar.barTintColor = color
                navBar.tintColor = ContrastColorOf(color, returnFlat: true)
                searchBar.barTintColor = color
                searchBar.tintColor = ContrastColorOf(color, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
                
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = color
                navBar.scrollEdgeAppearance = appearance
            }
        }
       
    }
    
    
    
    
    //MARK: - UITableViewProtocol
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return todoBrain.todoItems?.count ?? 1
    }
    
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        let item = todoBrain.todoItems?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "No title"
        cell.accessoryType = ( item?.isChecked ?? false) ? .checkmark : .none
        let color = UIColor(hexString: todoBrain.categoryName?.color ?? "ffffff")!.lighten(byPercentage:CGFloat(indexPath.row)/CGFloat(todoBrain.todoItems!.count))!
        
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color , returnFlat: true)
//        UIColor(hexString: todoBrain.categoryName?.color ?? "ffffff")?(byPercentage:CGFloat(indexPath.row+1)/CGFloat(todoBrain.todoItems!.count))
//        cell.backgroundColor = UIColor(hexColor:)
        
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
        todoBrain.selectOrDeselectItem(at: indexPath.row){[weak self] in
            
            DispatchQueue.main.async{
                
                
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                
                
                cell.accessoryType =  (self?.todoBrain.todoItems?[indexPath.row].isChecked ?? false) ? .checkmark : .none
                
                
                tableView.reloadData()
                
                //        context.delete(todoBrain.todoItems[indexPath.row])
                //        todoBrain.todoItems.remove(at: indexPath.row)
//                
//                self?.saveItem()
                
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
    }
    
    override func updateModels(at indexPath: IndexPath) {
        self.todoBrain.deleteItem(at: indexPath.row){
            DispatchQueue.main.async {


                self.tableView.reloadData()
            }
        }
        
    }
   
    
    
    
    //MARK: - Add New Item
    
    //Core data
    //     func saveItem() {
    //        let encoder = PropertyListEncoder()
    //
    //        do{
    //            let data = try encoder.encode(self.todoBrain.todoItems)
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
    //                    todoBrain.todoItems =  try decoder.decode([Item].self, from: data)
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
                    
                    
                }
            }
            //            if let item ={
            //
            //
            //
            //
            //
            //
            //                //                self.defaults.setValue(self.todoBrain.todoItems, forKey: "TodoListArray")
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
        
        
        todoBrain.todoItems = todoBrain.todoItems?.filter("title CONTAINS[cd] %@ ", searchBar.text ?? "").sorted(byKeyPath: "date",ascending: false
    )
        DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
        
//        let request : NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
//        
//        let predicateItem  = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text ?? "")
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        todoBrain.loadItems(with : request,predicate : predicateItem){
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//
//        }
        
    }
    //    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    //        loadItems()
    //    }
    //
    //
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
         
            todoBrain.loadItems() {
                DispatchQueue.main.async {

                    self.tableView.reloadData()
                }
            }
//            todoBrain.loadItems(){
//                DispatchQueue.main.async {
//
//                    self.tableView.reloadData()
//                }
//            }
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
    
}

//MARK: - CoreData data source logics

extension TodoListViewController {
    
    
    
    
    
   
    
    
}



