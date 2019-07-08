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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongViewCell
        cell.textLabel?.text = group.listSongs[indexPath.row].name
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       songDao = SongDao()
        setupImage()
        setupNavigationBar()
        setNotificationToken()
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
        navigationItem.leftBarButtonItem = nil
        
        title = group.name
    
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "удалить") { (action, indexPath) in
            

           // self.group.listSongs.remove(at: indexPath.row)// возможно нуджно торвать оит резалтс
            
          //  self.groupdao!.update(oldItem: self.group)
            let song = self.group.listSongs[indexPath.row]
            self.songDao!.delete(item: song)
    
        }
        
        let updateAction = UITableViewRowAction(style: .default, title: "изменить"){ (action, indexPath) in
     
            self.performSegue(withIdentifier: "updateSong", sender: self.group.listSongs[indexPath.row])
      
        }
        
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .green
        
        return[updateAction, deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "updateSong":
            let top = segue.destination as! UINavigationController
            
            let song = sender as! Song
            song.parentId = group.id
            
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
            
            let  song = group.listSongs[index]
            
            let groupVC = segue.destination as! SongViewController
            groupVC.song = song
            
        default:
            return
        }      
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
