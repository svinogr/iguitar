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
        realmGroup = groupDao.getFavoriteWithAsc()
    }
    
    override func setupSongs() {
        realmSongs = songDao.getFavoriteWithAsc()
    }
    
    override func setupNavigationBar() {
        title = "Избранные"
    }
    
    override func filterBy(text: String) {
        switch segments.selectedSegmentIndex {
        case 0:
            if(text.isEmpty) {
                realmGroup = groupDao.getFavoriteWithAsc()
            }else{
                realmGroup = groupDao.contains(name: text)
            }
        case 1:
            if(text.isEmpty) {
                realmSongs = songDao.getFavoriteWithAsc()
            } else {
                realmSongs =  songDao.contains(name: text)
            }
        default:
            print("error search")
        }
        
        mainTableView.reloadData()
    }
}
