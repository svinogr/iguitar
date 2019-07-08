//
//  GroupDao.swift
//  iguitar
//
//  Created by Up Devel on 25/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import RealmSwift

class GroupDao: RealmDao<Group> {
    
    public func deleteWithChilds(item: Group) {
        try! realm.write {
            for song in item.listSongs {
                realm.delete(song)
            }
            realm.delete(item)
        }
    }
    
    public func addToFavorite(item: Group) {
        try! realm.write {
            item.isFavorite = !item.isFavorite
        }
    }
}
