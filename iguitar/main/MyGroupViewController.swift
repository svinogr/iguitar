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
        realmGroup = groupDao.getUsersItems()
    }
    
    override func setupNavigationBar() {
            title  = "Мои добавленные"
    }
}
