//
//  GroupDao.swift
//  iguitar
//
//  Created by Up Devel on 20/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift


func getFileDB() -> URL {
    let fp =  Bundle.main.url(forResource: "db", withExtension:  "realm")
    return fp!
}

let realm = try! Realm(fileURL: getFileDB())

class RealmDao<T: CommomWithId> {
    
    public  func getAllItems()-> Results<T> {
        return realm.objects(T.self)
    }
    
    public  func getAllItemsSortByName()-> Results<T> {
        return realm.objects(T.self).sorted(byKeyPath: "name", ascending: true)
    }
    
    public func delete(item: T) {
        try! realm.write {
            realm.delete(item)
        }
    }
    
    func incrementID() -> Int {
        return (realm.objects(T.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    public func  create(newItem: T) -> T{
        try! realm.write{
            let id = incrementID()
            newItem.id = id
            realm.add(newItem)
        }
        
        return newItem
    }
    
    public func update(oldItem: T) {
        try! realm.write {
            realm.add(oldItem, update: .modified)
        }
    }
    
    public func getFavorite() -> Results<T> {
        let fav = true
        return  realm.objects(T.self).filter("isFavorite = \(fav)")
    }
    
    public func getFavoriteWithAsc() -> Results<T> {
        let objects = getFavorite()
        let fav = true
        return  objects.sorted(byKeyPath: "name", ascending: fav)
    }
    
    public func getUsersItems() -> Results<T> {
        let user = true
        return realm.objects(T.self).filter("isUser = \(user)")
    }
    
    public func getUsersItemsWithAsc() -> Results<T> {
        let objects = getUsersItems()
        let user = true
        return objects.sorted(byKeyPath: "name", ascending: user)
    }
    
    public func getUsersItemsWithAscContains(name: String) -> Results<T> {
        let objects = getUsersItemsWithAsc()
        return objects.filter("name = %@", name)
    }
    
    public func getBy(name: String) ->Results<T>? {
        return realm.objects(T.self).filter("name == %@", name.capitalized)
    }
    
    public func contains(name: String) -> Results<T>{
       let objects =  realm.objects(T.self)
        return objects.filter("name CONTAINS[c] %@", name)
    }
    
    public func containsAsc(name: String) -> Results<T>{
        let objects =  self.contains(name: name)
        return objects.sorted(byKeyPath: "name", ascending: true)
    }
    
    public func getFavoriteWithAscContains(name: String) -> Results<T> {
        let object = containsAsc(name: name)
        let fav = true
        return  object.filter("isFavorite = %@", fav)
    }
}
