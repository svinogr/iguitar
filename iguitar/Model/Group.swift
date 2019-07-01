//
//  Group.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift

class Group: CommomWithId {
    
    @objc dynamic var name = ""
    @objc dynamic var descriptionGroup = ""
    @objc dynamic var isUser = false
    @objc dynamic var imgData: Data?
    @objc dynamic var isFavorite = false
    let listSongs = List<Song>()
}
