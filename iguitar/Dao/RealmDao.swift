//
//  GroupDao.swift
//  iguitar
//
//  Created by Up Devel on 20/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

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
    
    private  func incrementID() -> Int {
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
    
    public func getUsersItems() -> Results<T> {
        let user = true
        return realm.objects(T.self).filter("isUser = \(user)")
    }
    
    public func getBy(name: String) ->Results<T>? {
        return realm.objects(T.self).filter("name[c] == %@", name.capitalized)
    }
    
    public func contains(name: String) -> Results<T>{
       let objects =  realm.objects(T.self)
        return objects.filter("name CONTAINS[c] %@", name)
    }
   
}
