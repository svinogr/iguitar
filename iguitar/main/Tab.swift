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
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        var flag = true
        let tag = viewController.tabBarItem.tag
        
        let purchased = userDef.bool(forKey: "purchased")
        
        if(tag == 2 || tag == 3) {
            
            if(!purchased){
                showMessageForPurchased()
                flag = false
            }
        }
        
        return flag
    }

    func showMessageForPurchased() {
        guard let product = PurchaseManager.shared.getProductWitInfo() else {return}
        
        let title = product.retrievedProducts.first?.localizedTitle
        let cost = product.retrievedProducts.first?.localizedPrice
        let localizedDescription = product.retrievedProducts.first?.localizedDescription
        
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        let buy = UIAlertAction(title: "Купить", style: .default, handler:  { c in
            PurchaseManager.shared.purchase()
        })
        
        let dialog = UIAlertController(title: "", message: "\(cost) \(localizedDescription)", preferredStyle: .alert)
        dialog.addAction(cancel)
        dialog.addAction(buy)
        
        present(dialog, animated: true, completion: nil)
    }
    
    
  
    
}
