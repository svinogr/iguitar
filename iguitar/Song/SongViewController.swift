//
//  SongViewController.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit
import RealmSwift
class SongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSong: UITextView!
    
    var song: Song!
    var notificationToken: NotificationToken? = nil
    
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
        let ackkord = song.ackords[indexPath.row]
        cell.nameAckord.text = ackkord.name.ackordUpCase
        cell.backgroundColor = UIColor(patternImage: UIImage())
      //  cell.ackordImage.image = UIImage(named: "Photo")
        if (ackkord.imageData != nil){
            
            if let picA = UIImage(data: ackkord.imageData!) {
                cell.ackordImage.image = picA
            } else  {cell.ackordImage.image = UIImage(named: "Photo")}
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSong()
        setupNavigationBar()
        setStyleApp()
        setNotificationToken()
    }
    
    func setStyleApp() {
        tableView.backgroundColor = UIColor(patternImage: UIImage())
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.backgroundColor = UIColor(patternImage: UIImage())
        
        textSong.backgroundColor = UIColor(patternImage: UIImage())
        textSong.layer.cornerRadius = 6 // подобрано вручную- пересчитать
        textSong.clipsToBounds = true
        
         navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupNavigationBar() {
        let top = navigationController?.navigationBar.topItem
        top?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем кнопку кансел и все что идет после стрелочки кнопки назад
        navigationItem.leftBarButtonItem = nil
        top?.backBarButtonItem?.tintColor = tintColor
        title = song.name
    }
    
    private func setupSong() {
        textSong.attributedText = "<pre> \(song.text) </pre>".htmlToAttributedString    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "showAckord":
            let ackVC = segue.destination as! AckordViewController
            guard let index =  tableView.indexPathForSelectedRow?.row else { return }
            let ackord =  self.song.ackords[index]
          
            ackVC.ackord = ackord
        default:
            return
        }
    }
    
    private func setNotificationToken() {
        
        notificationToken = song.ackords.observe { [weak self] (changes: RealmCollectionChange) in
            //   guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self!.tableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                self!.tableView.beginUpdates()
                self!.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                           with: .automatic)
                self!.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                           with: .fade)
                self!.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                           with: .automatic)
                self!.tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                // fatalError("\(error)")
                print(error)
            }
        }
    }
    
    deinit {
        notificationToken = nil
    }

}
extension String {
    var ackordUpCase: String {
        if let two = firstIndex(of: "/") {
            _ = self[two].uppercased()
        }
        return self.capitalized
    }
}

    

