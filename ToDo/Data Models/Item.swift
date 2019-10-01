//
//  Item.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 01/10/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //code relation chaque item a une categorie parent
    var parentCategorie = LinkingObjects(fromType: Categorie.self, property: "items")
}
