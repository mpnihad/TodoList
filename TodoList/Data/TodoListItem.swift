//
//  Item.swift
//  TodoList
//
//  Created by Nihad-Mac on 01/12/22.
//

import Foundation
import RealmSwift

class TodoListItem : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isChecked : Bool = false
    @objc dynamic var date : Date = Date.now
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")
    
}
