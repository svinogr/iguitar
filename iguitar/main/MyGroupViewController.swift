//
//  MyGroupViewController.swift
//  iguitar
//
//  Created by Up Devel on 24/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation

class MyGroupViewController: MainViewController {
    
    override func setupGroups() {
        realmGroup = groupDao.getUsersItemsWithAsc()
    }
    
    override func setupSongs() {
        realmSongs = songDao.getUsersItemsWithAsc()
    }
    
    override func setupNavigationBar() {
        title  = NSLocalizedString("Yours", comment: "Yours")
    }
    
    override func filterBy(text: String) {
        switch segments.selectedSegmentIndex {
        case 0:
            if(text.isEmpty) {
                realmGroup = groupDao.getUsersItems()
            }else{
                realmGroup = groupDao.getUsersItemsWithAscContains(name: text)
            }
        case 1:
            if(text.isEmpty) {
                realmSongs = songDao.getUsersItemsWithAsc()
            } else {
                realmSongs =  songDao.getUsersItemsWithAscContains(name: text)
            }
        default:
            print("error search")
        }
        
        mainTableView.reloadData()
    }
}
