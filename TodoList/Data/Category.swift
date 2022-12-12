//
//  Category.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = "ffffff"
    
    let item = List<TodoListItem>()
    
}
