//
//  AckordViewController.swift
//  iguitar
//
//  Created by Up Devel on 23/07/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class AckordViewController: UIViewController {
    public var ackord: Ackord!
    @IBOutlet weak var ackordImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyleApp()
        setupNavigationBar()
        setupAccord()
        // Do any additional setup after loading the view.
    }
    
    private func setupAccord() {
        if let image = UIImage(named: ackord.name) {
            ackordImage.image = image
        } else {
            setupTryAddImage()
        }
    }
    
    private func setupTryAddImage() {
        // code for add button etc
    }
    
    private func setStyleApp() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem.leftBarButtonItem?.tintColor = tintColor
    }
    
    private func setupNavigationBar() {
        let top = navigationController?.navigationBar.topItem
        top?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем кнопку кансел и все что идет после стрелочки кнопки назад
        navigationItem.leftBarButtonItem = nil
        top?.backBarButtonItem?.tintColor = tintColor
//        title = ackord.name
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
