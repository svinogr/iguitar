//
//  File.swift
//  iguitar
//
//  Created by Up Devel on 28/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import RealmSwift

class SongDao: RealmDao<Song> {
    
    override func contains(name: String) -> Results<Song> {
        return realm.objects(Song.self).filter("name CONTAINS[c] %@ OR text CONTAINS[c] %@", name, name)
    }
    
    override func containsAsc(name: String) -> Results<Song> {
     return   super.contains(name: name).sorted(byKeyPath: "name", ascending: true)
    }
    
    override func getFavoriteWithAscContains(name: String) -> Results<Song> {
        let objects  = containsAsc(name: name)
        let fav = true
        return objects.filter("isFavorite = %@", fav)
    }
    
    override func getUsersItemsWithAscContains(name: String) -> Results<Song> {
        let objects  = containsAsc(name: name)
        let fav = true
        return objects.filter("isUser = %@", fav)
    }
    
    override func create(newItem: Song) -> Song {
        try! realm.write{
            let id = incrementID()
            newItem.id = id
            realm.add(newItem)
            print(newItem.parentId)
            let group = realm.objects(Group.self).filter("id = %@", newItem.parentId)
            print(group.count)
            group[0].listSongs.append(newItem)
        }
        
        return newItem
    }
    
    
    
    public func addToFavorite(item: Song) {
        try! realm.write {
            item.isFavorite = !item.isFavorite
        }
    }
}
