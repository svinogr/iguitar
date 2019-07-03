//
//  FavoriteGroup.swift
//  iguitar
//
//  Created by Up Devel on 21/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation

class FavoriteGroup: MainViewController {
    
    override func setupGroups() {
        realmGroup = groupDao.getFavorite()
    }
    
    override func setupSongs() {
        realmSongs = songDao.getFavorite()
    }
    
    override func setupNavigationBar() {
        title = "Избранные"
    }
}
