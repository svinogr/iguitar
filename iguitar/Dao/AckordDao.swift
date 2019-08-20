//
//  AckordDao.swift
//  iguitar
//
//  Created by Up Devel on 28/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import RealmSwift
class AckordDao: RealmDao<Ackord> {
    
    override func create(newItem: Ackord) -> Ackord {
        let arr = realm.objects(Ackord.self).filter("name == %@", newItem.name)
        
        if (arr.count == 0) {
            newItem.isUser = true
          return super.create(newItem: newItem)
        } else {
        return arr[0]
        }
    }
    
    override func checkBy(nameOf: Ackord) -> Bool {
        var check = false
        
        let ackords = realm.objects(Ackord.self).filter("name = %@", nameOf.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        
        if(ackords.count > 0) {
            check = true
        }
        return check
    }
    
}
