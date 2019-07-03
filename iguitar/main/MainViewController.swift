//
//  ViewController.swift
//  iguitar
//
//  Created by Up Devel on 18/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var alphabetTableView: UITableView!
    @IBOutlet weak var segments: UISegmentedControl!
    @IBOutlet weak var newItemBtn: UIBarButtonItem!
    
    let groupDao =   GroupDao()
    let songDao = SongDao()
    
    var realmGroup: Results<Group>!
    
    var realmSongs: Results<Song>!
  
   
    var notificationToken: NotificationToken? = nil
    var notificationTokenFiltered: NotificationToken? = nil
    
    var seachBarTextIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    
    var searchBarIsActive: Bool {
        return searchController.isActive && !seachBarTextIsEmpty
    }
    
    var isOpenedYet = false
    var testMainAr = ["Kino", "Alice", "KISH", "Murzilka", "DDT", "COY", "Sector GAza", "Bi2", "Splin", "Antares", "BG", "Beatles", "Queen", "Scorpions", "Uha", "Modern Talking", "Knyaz", "Polina", "Fixics",]
    var groupsArr = [Group]()
    
    let testAlphaAr = ["1-9", "A-Z", "А-Я"]
    let alphabet_En = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let alphabet_Ru = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Э", "Ю", "Я"]
    let alphabet_Number =   ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    var alpgabetDataCell: [AlphabetStructure] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier == "main" {
            
//            if (searchBarIsActive){
//                switch segments.selectedSegmentIndex {
//                case 0: return  realmFilteredGroup!.isEmpty ? 0:  realmFilteredGroup!.count
//                case 1: return  realmFilteredSongs!.isEmpty ? 0:  realmFilteredSongs!.count
//                default:
//                   return 0
//                }
//            } else {
            
                switch segments.selectedSegmentIndex {
                case 0: return  realmGroup.isEmpty ? 0:  realmGroup.count
                case 1: return  realmSongs.isEmpty ? 0:  realmSongs.count
                default:
                     return 0
//                }
         }
        }
        else {
            if alpgabetDataCell[section].isOpened {
                return alpgabetDataCell[section].data.count + 1
            }else {
                return 1
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "удалить") { (action, indexPath) in
          let index = indexPath.row
            
//            if(self.searchBarIsActive) {
//                switch self.segments.selectedSegmentIndex {
//                case 0:
//                    self.groupDao.deleteWithChilds(item: self.realmFilteredGroup![index])
//              //      tableView.deleteRows(at: [indexPath], with: .automatic) //потому что не рабоатет нотификатион
//
//                case 1:
//                    self.songDao.delete(item: self.realmFilteredSongs![index])
//                   //  tableView.deleteRows(at: [indexPath], with: .automatic) //потому что не рабоатет нотификатион
//                default:
//                  print("nothing to del")
//                }
//            } else {
                switch self.segments.selectedSegmentIndex {
                case 0: self.groupDao.deleteWithChilds(item: self.realmGroup![index])
                case 1:
                    self.songDao.delete(item:self.realmSongs![index])
                default:
                   print("nothing to del")
            //    }
            }
        }
        
        let updateAction = UITableViewRowAction(style: .default, title: "изменить"){ (action, indexPath) in
            self.performSegue(withIdentifier: "updateGroup", sender: self.realmGroup[indexPath.row])
            print(indexPath)
        }
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .green
        
        return[updateAction, deleteAction]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.restorationIdentifier == "main" { return 1}
        else {return alpgabetDataCell.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView.restorationIdentifier == "main" {
            
            switch segments.selectedSegmentIndex {
            case 0:  cell = (tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainViewCell)
              let group: Group
//            if(searchBarIsActive) {
//                group = realmFilteredGroup![indexPath.row]
//            }else {
                group = realmGroup[indexPath.row]
                
         //   }
                  cell.textLabel?.text = group.name
            case 1:  cell = (tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongViewCell)
            let song: Song
//            if(searchBarIsActive) {
//                song = realmFilteredSongs![indexPath.row]
//            }else {
                song = realmSongs[indexPath.row]
                
      //      }
            cell.textLabel?.text = song.name
            default:
                  cell = (tableView.dequeueReusableCell(withIdentifier: "mainCell") as! SongViewCell)

            }
    
        }else {
              cell = (tableView.dequeueReusableCell(withIdentifier: "alphabetCell") as! AlphabetViewCell)
            
            if indexPath.row == 0 {
                cell.textLabel?.text = alpgabetDataCell[indexPath.section].title
            }else {
                cell.textLabel?.text = alpgabetDataCell[indexPath.section].data[indexPath.row - 1]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.restorationIdentifier == "main" {
            
        }else {
            if indexPath.row == 0 {
                if !alpgabetDataCell[indexPath.section].isOpened {
                    alpgabetDataCell[indexPath.section].isOpened = true
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }else {
                    alpgabetDataCell[indexPath.section].isOpened = false
                    let sections = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(sections, with: .none)
                }
            } else { // если кликается буква
                moveToLetter(letter: alpgabetDataCell[indexPath.section].data[indexPath.row - 1])
            }
        }
    }
    
    //MARK: moveToLetter
    
    private func moveToLetter(letter: String){
        var index: Int?
        
        switch segments.selectedSegmentIndex {
        case 0:
//        if(searchBarIsActive) {
//            for i in realmFilteredGroup! {
//                if i.name.first! == Character(letter)  {
//                    index = realmFilteredGroup!.firstIndex(of: i)  /// сделать в фоновом потоке
//                    break
//                }
//            }
//        } else {
            for i in realmGroup {
                if i.name.first! == Character(letter)  {
                    index = realmGroup.firstIndex(of: i)  /// сделать в фоновом потоке
                    break
                }
            }
//        }
        case 1:
//            if(searchBarIsActive) {
//                for i in realmFilteredSongs! {
//                    if i.name.first! == Character(letter)  {
//                        index = realmFilteredSongs!.firstIndex(of: i)  /// сделать в фоновом потоке
//                        break
//                    }
//                }
//            } else {
                for i in realmSongs {
                    if i.name.first! == Character(letter)  {
                        index = realmSongs.firstIndex(of: i)  /// сделать в фоновом потоке
                        break
                    }
                }
           // }
        default:
            print(1)
        }
        
        if index == nil{ return}
        let row = IndexPath(row: index!, section: 0)
        
       mainTableView.scrollToRow(at: row, at: .middle, animated: true)
  // mainTableView.selectRow(at: row, animated: true, scrollPosition: .middle)
  
    }
    //MARK: DIDLOW
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearch()
        testMainAr.sort()
        setupGroups()
        setupSongs()
        setNotificationTokenForGroup()
        
        let num = getAlphabetStructure(title: "0-9", arr: alphabet_Number)
        let en = getAlphabetStructure(title: "A-Z", arr: alphabet_En)
        let ru = getAlphabetStructure(title: "А-Я", arr: alphabet_Ru)
        
        alpgabetDataCell.append(num)
        alpgabetDataCell.append(en)
        alpgabetDataCell.append(ru)
        // Do any additional setup after loading the view.
    }
    
     func setupNavigationBar() {
        title = "Все группы"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
       // let sections = IndexSet.init(integer: IndexPath(item: 0, section: 1).section)
      //  alphabetTableView.reloadSections(sections, with: .none)
       // alphabetTableView.reloadData()
     //   alphabetTableView.selectRow(at: IndexPath(item: 0, section: 1), animated: true, scrollPosition: .middle)
       // alphabetTableView.reloadData()
        if(!isOpenedYet){
        self.tableView(alphabetTableView, didSelectRowAt: IndexPath(item: 0, section: 2))
            isOpenedYet = true
        }
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func setNotificationTokenForGroup() {
        
        notificationToken = realmGroup.observe { [weak self] (changes: RealmCollectionChange) in
            //   guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self!.mainTableView.reloadData()

            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                print("from group realm")
                self!.mainTableView.beginUpdates()
                self!.mainTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                self!.mainTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                self!.mainTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                self!.mainTableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                // fatalError("\(error)")
                print(error)
            }
        }
        
    }
    
    private func setNotificationTokenForSong() {
        
        notificationToken = realmSongs.observe { [weak self] (changes: RealmCollectionChange) in
            //   guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self!.mainTableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                print("from song realm")
                self!.mainTableView.beginUpdates()
                self!.mainTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                self!.mainTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                self!.mainTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                self!.mainTableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                // fatalError("\(error)")
                print(error)
            }
        }
    }
    
//    private func setNotificationTokenForSong2() {
//
//        notificationToken = realmFilteredSongs!.observe { [weak self] (changes: RealmCollectionChange) in
//            //   guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                // Results are now populated and can be accessed without blocking the UI
//                self!.mainTableView.reloadData()
//
//            case .update(_, let deletions, let insertions, let modifications):
//                // Query results have changed, so apply them to the UITableView
//                print("from song realm")
//                self!.mainTableView.beginUpdates()
//                self!.mainTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                               with: .automatic)
//                self!.mainTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                               with: .automatic)
//                self!.mainTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                               with: .automatic)
//                self!.mainTableView.endUpdates()
//            case .error(let error):
//                // An error occurred while opening the Realm file on the background worker thread
//                // fatalError("\(error)")
//                print(error)
//            }
//        }
//    }
    
//    private func setNotificationTokenForGroup2() {
//
//        notificationToken = realmFilteredGroup.observe { [weak self] (changes: RealmCollectionChange) in
//            //   guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                // Results are now populated and can be accessed without blocking the UI
//                self!.mainTableView.reloadData()
//
//            case .update(_, let deletions, let insertions, let modifications):
//                // Query results have changed, so apply them to the UITableView
//                print("from song realm")
//                self!.mainTableView.beginUpdates()
//                self!.mainTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                               with: .automatic)
//                self!.mainTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                               with: .automatic)
//                self!.mainTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                               with: .automatic)
//                self!.mainTableView.endUpdates()
//            case .error(let error):
//                // An error occurred while opening the Realm file on the background worker thread
//                // fatalError("\(error)")
//                print(error)
//            }
//        }
//    }
//
    
    
    deinit {
        notificationToken = nil
    }
    
    func setupSongs() {
        realmSongs = songDao.getAllItemsSortByName()
      //  realmFilteredSongs = realm.objects(Song.self).filter(NSPredicate(value: false))
    }
    
    
    func temFunccraete() {
        let acDao = AckordDao()
        
        for i in 0...1000 {
            let group = Group()
            group.name = "Группа \(i)"
            
           
            for y in 0...3 {
                let song = Song()
                song.name = "песня \(y)"
                song.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
                for _ in 0...2 {
                    let acckord = Ackord()
                    acckord.name = "dm"
                  _ =  acDao.create(newItem: acckord)
                    song.ackords.append(acckord)
                }
                
               _ = songDao.create(newItem: song)
                group.listSongs.append(song)
            }
            _ = groupDao.create(newItem: group)
            
        }
        
        
    }
    
    
     func setupGroups() {
      // temFunccraete()
        realmGroup = groupDao.getAllItemsSortByName()
      //  realmFilteredGroup = realm.objects(Group.self).filter(NSPredicate(value: false))
        
        
    }
    
    private func getAlphabetStructure(title: String, arr: [String]) -> AlphabetStructure {
        let structure = AlphabetStructure()
        structure.title = title
        
        for i in arr {
            structure.data.append(i)
        }
        
        return structure
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        switch identifier {
        case "updateGroup":
            let top = segue.destination as! UINavigationController
            let addNewVC = top.viewControllers[0] as! AddNewGroupViewController
            
            let group = sender as! Group
            
            addNewVC.group = group
        case "updateSong":
            let top = segue.destination as! UINavigationController
            let addNewVC = top.viewControllers[0] as! AddNewSongViewController
            
            let song = sender as! Song
            
            addNewVC.song = song
        case "showGroup":
            guard let group = getSelectedItem() else {return}
            
            let groupVC = segue.destination as! GroupViewController
            groupVC.group = (group as! Group)
            
        case "showSong":
            guard let song = getSelectedItem() else {return}
            
            let songVC = segue.destination as! SongViewController
            songVC.song = (song as! Song)
        default:
            return
        }
    }
    
    private func getSelectedItem() -> CommomWithId? {
    guard let index =  mainTableView.indexPathForSelectedRow?.row else { return nil}
        let item: CommomWithId?
        
//        if(searchBarIsActive) {
//
//            switch segments.selectedSegmentIndex {
//            case 0: item = realmFilteredGroup![index]
//            case 1: item = realmFilteredSongs![index]
//            default:
//                item = nil
//            }
//
//        } else {
            switch segments.selectedSegmentIndex {
            case 0: item = realmGroup![index]
            case 1: item = realmSongs![index]
            default:
                item = nil
            }
       // }

        return item
    }
    
    @IBAction func sort(_ sender: Any) {
         newItemBtn.isEnabled = !newItemBtn.isEnabled
        
        if(segments.selectedSegmentIndex == 0) {
            setNotificationTokenForGroup()
            
        } else{
            setNotificationTokenForSong()
        }
        
        if (!searchBarIsActive) {
            mainTableView.reloadData()
        } else {
            updateSearchResults(for: searchController)
        }
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
//        if(segments.selectedSegmentIndex == 0) {
//            print("end search 1 + act0")
//            setNotificationTokenForGroup2()
//        }else {
//            print("end search 1 + acti")
//            setNotificationTokenForSong2()}
//        updateSearchResults(for: searchController)
//
        filterBy(text: searchController.searchBar.text!)
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        if(segments.selectedSegmentIndex == 0) {
//            print("end search 0")
//            setNotificationTokenForGroup()
//        }else {
//             print("end search 1")
//            setNotificationTokenForSong()}
//    }
    
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        if(segments.selectedSegmentIndex == 0) {
//            print("end search 0 + act")
//            setNotificationTokenForGroup2()
//        }else {
//            print("end search 1 + acti")
//            setNotificationTokenForSong2()}
//    }
    
    private func filterBy(text: String) {
        switch segments.selectedSegmentIndex {
        case 0:
            //  setNotificationTokenForGroup2()
            if(text.isEmpty) {
                realmGroup = groupDao.getAllItemsSortByName()
            }else{
                realmGroup = groupDao.contains(name: text)
            }
        case 1:
            //setNotificationTokenForSong2()
            if(text.isEmpty) {
                realmSongs = songDao.getAllItemsSortByName()
            } else {
                realmSongs =  songDao.contains(name: text)
            }
        default:
            print("error search")
        }
    
        mainTableView.reloadData()
    }
}

