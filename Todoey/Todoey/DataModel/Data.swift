//
//  Data.swift
//  Todoey
//
//  Created by yoonyeosong on 2023/12/09.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
