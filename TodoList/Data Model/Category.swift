//
//  Category.swift
//  TodoList
//
//  Created by Mamadou Bella Diallo on 2018-01-22.
//  Copyright © 2018 Bella Diallo. All rights reserved.
//

import UIKit
import RealmSwift

class Category: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    
}
