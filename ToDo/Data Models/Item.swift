//
//  Item.swift
//  ToDo
//
//  Created by Jean martin Kyssama on 28/09/2019.
//  Copyright © 2019 Jean martin Kyssama. All rights reserved.
//

import Foundation

// la classe peut etre encodée et décodée dans un dataFilePath
class Item: Codable{
    var title: String = ""
    var done: Bool = false
}
