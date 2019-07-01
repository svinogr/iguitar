//
//  Ackord.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift

class Ackord: CommomWithId {
    @objc dynamic var name = ""
    @objc dynamic var imageData: Data?
    let parent = LinkingObjects(fromType: Song.self, property: "ackords")
}
