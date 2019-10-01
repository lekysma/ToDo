//
//  Categorie.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 01/10/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import Foundation
import RealmSwift

class Categorie: Object {
    @objc dynamic var name: String = ""
    // code relation une categorie avec plusieurs items
    var items = List<Item>()
}
