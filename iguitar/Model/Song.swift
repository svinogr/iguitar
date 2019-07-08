//
//  Song.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift

class Song: CommomWithId {
    @objc dynamic var name = ""
    @objc dynamic var text = ""
    let parent = LinkingObjects(fromType: Group.self, property: "listSongs")
    @objc dynamic var isUser = false
    @objc dynamic var isFavorite = false
    let ackords = List<Ackord>()
    var parentId = 0
}

