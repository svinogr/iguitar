//
//  SettingsViewController.swift
//  iguitar
//
//  Created by Up Devel on 17/10/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var hideReclamaBtn: UIButton!
    
    @IBOutlet weak var restoreBtn: UIButton!
   
    @IBAction func restore(_ sender: Any) {
        restore()
    }
    
    @IBAction func hideReclamaBtn(_ sender: Any) {
       purchasereclama()
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setStyleApp()
    }
    
    private func setupView(){
        title = NSLocalizedString("Settings", comment: "Settings")
    }
    
    func setStyleApp() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        setStyle(button: hideReclamaBtn)
        setStyle(button: restoreBtn)
    }
    
    private func setStyle(button: UIButton) {
        button.backgroundColor = UIColor(patternImage: UIImage())
        button.layer.borderColor = tintColor.cgColor
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.tintColor = tintColor
    }
    
    func purchasereclama() {
        let purchased = PurchaseManager.checkUserDef()
        if(!purchased){
            showMessageForPurchased()
        }
    }
    
    func showMessageForPurchased() {
        PurchaseManager.shared.getProductWitInfo { (product) in
            
            _ = product.retrievedProducts.first?.localizedTitle
            let cost = product.retrievedProducts.first?.localizedPrice
            let localizedDescription = product.retrievedProducts.first?.localizedDescription
            
            let cancel = UIAlertAction(title:NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
            let buy = UIAlertAction(title: NSLocalizedString("Purchase", comment: "Purchase"), style: .default, handler:  { c in
                PurchaseManager.shared.purchase()
            })
            
            let dialog = UIAlertController(title: "", message: "\(String(describing: localizedDescription!)) -  \(String(describing: cost!)) ", preferredStyle: .alert)
            dialog.addAction(cancel)
            dialog.addAction(buy)
            
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
    private func restore() {
        PurchaseManager.shared.restore()
    }

}
