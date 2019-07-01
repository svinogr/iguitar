//
//  SongViewController.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class SongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSong: UITextView!
    
    
    var song: Song!
   // var ackords = [Ackord]()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hidesBottomBarWhenPushed = true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return song.ackords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ackordCell") as! AckordViewCell
        cell.nameAckord.text = song.ackords[indexPath.row].name
        cell.ackordImage.image = UIImage(named: "Photo")
      
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSong()
        setupNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar() {
        let top = navigationController?.navigationBar.topItem
        top?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем кнопку кансел и все что идет после стрелочки кнопки назад
        navigationItem.leftBarButtonItem = nil
        title = song.name
    }
    
    private func setupSong() {
       
        textSong.text = song.text
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

    

