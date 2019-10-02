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
        let ackDao = AckordDao()
        let ack = Ackord()
        ack.name = name
        let check = ackDao.checkBy(nameOf: ack)
        if (check) {
           return realm.objects(Song.self).filter("name CONTAINS[c] %@", name)
        }
        
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
        let tf = TextFormat()
        print (tf.formatToHTML(text: newItem.text))
        
        try! realm.write{
            let id = incrementID()
            newItem.id = id
            realm.add(newItem)
            let group = realm.objects(Group.self).filter("id = %@", newItem.parentId)
            group[0].listSongs.append(newItem)
        }
        
        return newItem
    }
    
   public override func checkBy(nameOf: Song) -> Bool {
    var check = false
    let checkName = nameOf.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    let idGroup = nameOf.parentId
    
    let groupDao = GroupDao()
    let group = groupDao.getBy(id: idGroup)[0]
    
    let songs = group.listSongs
    
    for song in songs {
        
        if(song.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == checkName) {
            check = true
            break
        } else {continue}
        
    }
    
    return check
    }
    
    public func addToFavorite(item: Song) {
        try! realm.write {
            item.isFavorite = !item.isFavorite
        }
    }
}
