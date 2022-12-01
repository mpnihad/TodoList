//
//  Category.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let item = List<TodoListItem>()
    
}
