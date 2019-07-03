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
}
