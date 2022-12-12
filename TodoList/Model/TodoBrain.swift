//
//  TodoBrain.swift
//  TodoList
//
//  Created by Nihad-Mac on 29/11/22.
//

import UIKit
import CoreData
import RealmSwift

struct TodoBrain {
    
    
    var todoItems : Results<TodoListItem>?
    
    let realm = try! Realm()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryName : Category? = nil
    
    mutating func addItem(name : String?, callBack :() -> Void){
        if let name = name, let categoryNam = categoryName{
            
            do {
                try realm.write {
                    let newItem = TodoListItem()
                    newItem.title = name
                    newItem.isChecked = false
                    newItem.date = Date.now
                    categoryNam.item.append(newItem)
                }
                callBack()
            } catch  {
                print("Error \(error.localizedDescription)")
            }
            
        }
    }
    
    mutating func selectOrDeselectItem (at row: Int, callBack :() -> Void) {
        
        do {
            try realm.write{
                todoItems?[row].isChecked = !(todoItems?[row].isChecked ?? false)
                callBack()
            }
        } catch  {
            print("error \(error.localizedDescription)")
            
        }
        
        
        
    }
    
    
    
    mutating func loadItems( category : Category? = nil,callback: () -> Void) {
        
        
        
        if let categorys = category{
            
            categoryName = categorys
        }
        
        
        print(categoryName)
        
        
        todoItems = categoryName?.item.sorted(byKeyPath: "title",ascending: true)
        
        callback()
        
    }
    
     func deleteItem(at row: Int,callback: () -> Void){
        do {
            if let item = todoItems?[row]{
                try realm.write {
                    try realm.delete(item)
                    
                    
                    
                    callback()
                    
                }
                
            }
            
            
        }
        catch{
            
        }
        
    }
}



