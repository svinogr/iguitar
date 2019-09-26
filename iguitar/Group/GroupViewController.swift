//
//  GroupViewController.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit
import  RealmSwift

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageOfGroup: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private let favoriteImage = UIImage(named: "emptyStar")
    var group: Group!
    //var groupdao: GroupDao?
    var songDao: SongDao?
    
    var notificationToken: NotificationToken? = nil
    
  //  var songs = [Song]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
        hidesBottomBarWhenPushed = true
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.listSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let song = group.listSongs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongViewCell
        
        cell.nameSangLabel.text = song.name.capitalized
        cell.backgroundColor = UIColor(patternImage: UIImage())
       
        if(song.isFavorite) {
            cell.favoriteImage.image = favoriteImage
        } else {
            cell.favoriteImage.image = nil
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songDao = SongDao()
        setupImage()
        setupNavigationBar()
        setNotificationToken()
        setStyleApp()
        // Do any additional setup after loading the view.
    }
    
    private func setupImage() {
        if group.imgData == nil {
            imageOfGroup.image = UIImage(named: "Photo")
        } else {
            imageOfGroup.image = UIImage(data: group.imgData!)
        }
    }
    
    private func setupNavigationBar() {
        
        let top = navigationController?.navigationBar.topItem
        top?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем кнопку кансел и все что идет после стрелочки кнопки назад
        top?.backBarButtonItem?.tintColor = tintColor
        navigationItem.leftBarButtonItem = nil
        
        title = group.name.capitalized
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.row
        
        let delete = UIContextualAction(style: .destructive, title: "", handler: {
            (a, b, c) in
            let song = self.group.listSongs[index]
            self.songDao!.delete(item: song)
            
            c(true)
        })
        delete.image = UIImage(named: "trash2")
        
        let updateAction = UIContextualAction(style: .normal, title: "изменить"){ (action, indexPath, c) in
            if(self.group.listSongs[index].isUser){
             self.performSegue(withIdentifier: "updateSong", sender: self.group.listSongs[index])
            } else {
                self.showMessageForActionsWithNotUserItems(message: "Возможно изменять только свои добавленые песни")
            }
            
            c(true)
        }
        
         updateAction.image = UIImage(named: "compose")
        
        let config = UISwipeActionsConfiguration(actions:[delete, updateAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    func showMessageForActionsWithNotUserItems(message: String) {
        let cancel = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        
        let dialog = UIAlertController(title: "", message: message, preferredStyle: .alert)
        dialog.addAction(cancel)
        
        present(dialog, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.row
        
        let favoriteAction = UIContextualAction(style: .normal, title: "избранное") { (action, indexPath, c) in
           let song = self.group.listSongs[index]
            c(true)
            self.songDao?.addToFavorite(item: song)
        }
        
        favoriteAction.image = UIImage(named: "favorite")
        
        let config = UISwipeActionsConfiguration(actions: [favoriteAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "updateSong":
            let top = segue.destination as! UINavigationController
            
            let song = sender as! Song
         //   song.parentId = group.id
            
            let addNSC = top.viewControllers[0] as! AddNewSongViewController
            addNSC.song = song
            addNSC.isUpdate = true
        case "addNewSong":
            let top = segue.destination as! UINavigationController
            
            let song = Song()
            song.parentId = group.id
            
            let addNSC = top.viewControllers[0] as! AddNewSongViewController
            addNSC.song = song
            addNSC.isUpdate = false
        case "showSong":
            guard let index =  tableView.indexPathForSelectedRow?.row else { return }
            
            let song = group.listSongs[index]
            
            let groupVC = segue.destination as! SongViewController
            groupVC.song = song
            
        default:
            return
        }      
    }
    
    func setStyleApp() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        tableView.backgroundColor = UIColor(patternImage: UIImage())
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        
        let top = navigationController?.navigationBar.topItem
        top?.backBarButtonItem?.tintColor = tintColor
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setNotificationToken() {
        
        notificationToken = group.listSongs.observe { [weak self] (changes: RealmCollectionChange) in
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
