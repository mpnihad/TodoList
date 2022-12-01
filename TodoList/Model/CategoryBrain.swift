//
//  CategoryBrain.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import UIKit
import CoreData


struct CategoryBrain {
    var categoryItems = [Category]()
    
    var selectedCategory : Category = Category()
    
  
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
    mutating func addItem(name : String?, callBack :() -> Void){
        if let name = name{
            let newCategory = Category(context: self.context)
            newCategory.name = name
            categoryItems.append(newCategory)
            callBack()
        }
    }
    
   
    
   
    
    mutating func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest(),callback: () -> Void) {
        
        
        do{
            
            
           
          
            categoryItems = try context.fetch(request) as [Category]
          
            
            
        }
        catch{
            print("Error \(error)")
            
        }
    }
}



