//
//  Items.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2018-01-22.
//  Copyright © 2018 Bella Diallo. All rights reserved.
//

import UIKit
import RealmSwift

class Item: Object {

    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
