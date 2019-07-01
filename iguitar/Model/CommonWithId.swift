//
//  CommonWithId.swift
//  iguitar
//
//  Created by Up Devel on 21/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift

class CommomWithId: Object {
    @objc dynamic var id = 0
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func == (lhs: CommomWithId, rhs: CommomWithId) -> Bool {
        return lhs.id == rhs.id
        //// сравнить id !!!!!!!!!!!!!!!!!!
    }
}
