//
//  TodoBrain.swift
//  TodoList
//
//  Created by Nihad-Mac on 29/11/22.
//

import UIKit
import CoreData

struct TodoBrain {
    var itemArray = [TodoListItem]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryName : Category? = nil
    
    mutating func addItem(name : String?, callBack :() -> Void){
        if let name = name, let categoryNam = categoryName{
            let newItem = TodoListItem(context: self.context)
            newItem.title = name
            newItem.isChecked = false
            newItem.parentCategory = categoryNam
            itemArray.append(newItem)
            callBack()
        }
    }
    
    mutating func selectOrDeselectItem (at row: Int, callBack :() -> Void) {
        itemArray[row].isChecked = !itemArray[row].isChecked
        callBack();
        
    }
    
   
    
    mutating func loadItems(with request: NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest(), category:Category? = nil, predicate:NSPredicate? = nil, callback: () -> Void) {
        
        if let categorys = category{
            
            categoryName = categorys
        }
        
        
        
        let categoryPredicate  = NSPredicate(format: "parentCategory.name MATCHES %@", categoryName!.name!)
        let compoundPredicate = predicate != nil ? NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!,categoryPredicate]) : NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
//
        
        request.predicate = compoundPredicate
        
        
        do{
           
            
            
            
            itemArray = try context.fetch(request) as [TodoListItem]
          
                
                
                callback()
            
            
            
        }
        catch{
            print("Error \(error)")
            
        }
    }
}



