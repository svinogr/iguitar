//
//  AckordDao.swift
//  iguitar
//
//  Created by Up Devel on 28/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation

class AckordDao: RealmDao<Ackord> {
    
    override func create(newItem: Ackord) -> Ackord {
        let arr = realm.objects(Ackord.self).filter("name == %@", newItem.name)
        
        if (arr.count == 0) {
          return super.create(newItem: newItem)
        } else {
        return arr[0]
        }
       
    }
}
