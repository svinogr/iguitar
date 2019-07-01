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
    let groupDao =   GroupDao()
    var realmGroup: Results<Group>!
    var realmFilteredGroup: Results<Group>?
    var notificationToken: NotificationToken? = nil
    
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
           
            if (searchBarIsActive){
               return  realmFilteredGroup!.isEmpty ? 0 : realmFilteredGroup!.count
            } else {
              return   realmGroup.isEmpty ? 0:  realmGroup.count}
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
            self.groupDao.delete(item: self.realmGroup[indexPath.row])
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
            let group: Group
            if(searchBarIsActive) {
                group = realmFilteredGroup![indexPath.row]
            }else {group = realmGroup[indexPath.row]}
            
            cell = (tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainViewCell)
            cell.textLabel?.text = group.name
            
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
        for i in realmGroup {
          
            if i.name.first! == Character(letter)  {
                index = realmGroup.firstIndex(of: i)  /// сделать в фоновом потоке
                print(i)
                break
            }
            
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
        setNotificationToken()
        
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
        
        navigationItem.searchController = searchController
    }
    
    private func setNotificationToken() {
        
        notificationToken = realmGroup.observe { [weak self] (changes: RealmCollectionChange) in
         //   guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self!.mainTableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
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
    
    deinit {
        notificationToken = nil
    }
    
     func setupGroups() {
        realmGroup = groupDao.getAllItemsSortByName()
    
        
//        let group = Group()
//        let song = Song()
//        song.name = "hjgded"
//        group.listSongs.append(song)
        
        
        //        GroupDao.create(newGroup: group)//         let sd = RealmDao<Song>()
        //        let ad = RealmDao<Ackord>()
        //        for i in 0..<testMainAr.count {
        //            let group = Group()
        //            group.name = testMainAr[i]
        //            let song = Song()
        //            song.name = "hjgded"
        //            // group.listSongs.append(song)
        //            let song2 = Song()
        //            song2.name = "hjgded"
        //           let temptext = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        //
        //            song.text = temptext
        //            song2.text = temptext
        //
        //            let accord = Ackord()
        //            accord.name = "Am"
        //            ad.create(newItem: accord)
        //
        //            song.ackords.append(accord)
        //             song2.ackords.append(accord)
        //
        //             sd.create(newItem: song)
        //             sd.create(newItem: song2)
        //            //  song2.owmer = group
        //            //  realm.create(Group.self, value: group, update: true)
        //             group.listSongs.append(song)
        //             group.listSongs.append(song2)
        //
        //            gD.create(newItem: group)
        //
        //        let gr = gD.getAllGroup()

//        for i in gr {
//            print(i.listSongs)
//            print("id owner \(i.listSongs[0].parent)")
//        }
           
      //  }         // groupsArr.append(group)
        
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
        case "showGroup":
            guard let group = getSelectedItem() else {return}
            
            let groupVC = segue.destination as! GroupViewController
            groupVC.group = group
        default:
            return
        }

    }
    
    private func getSelectedItem() -> Group? {
    guard let index =  mainTableView.indexPathForSelectedRow?.row else { return nil}
        print(index)
    let  group = realmGroup[index]
        return group
    }
}

extension MainViewController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterBy(text: searchController.searchBar.text!)
    }
    
    private func filterBy(text: String) {
        realmFilteredGroup = realmGroup.filter("name CONTAINS[c] %@", text)
        mainTableView.reloadData()
    }
}
