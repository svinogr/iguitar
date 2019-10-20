//
//  Tab.swift
//  iguitar
//
//  Created by Up Devel on 26/09/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class Tab: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    
    }
    
}
