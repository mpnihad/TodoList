//
//  CategoryBrain.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import UIKit
import RealmSwift
import ChameleonFramework


struct CategoryBrain {
    
    let realm = try! Realm()
    
    var categoryItems: Results<Category>?
    
    var selectedCategory : Category? = Category()
    
    
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    mutating func addItem(name : String?, callBack :(Category) -> Void){
        if let name = name{
            let newCategory = Category()
            newCategory.name = name
            newCategory.color = UIColor.randomFlat().hexValue()
            callBack(newCategory)
        }
    }
    
    
    
    
    
    mutating func loadItems(callback: () -> Void) {
        
        
        
        
        
        
        categoryItems = realm.objects(Category.self)
        
        
        
    }
    


func deleteItem(at row: Int,callback: () -> Void){
    do {
        if let category = categoryItems?[row]{
            try realm.write {
                
                     realm.delete(category)
               
                
                
                
                callback()
                
            }
            
        }
        
        
    }
    catch{
        
    }
    
}
}








