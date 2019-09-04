//
//  ViewController.swift
//  iguitar
//
//  Created by Up Devel on 18/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyStoreKit

let tintColor = UIColor(displayP3Red: 138/255, green: 42/255, blue: 16/255, alpha: 0.80)

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var alphabetTableView: UITableView!
    @IBOutlet weak var segments: UISegmentedControl!
    @IBOutlet weak var newItemBtn: UIBarButtonItem!
    @IBAction func restore(_ sender: Any) {
        restore()
    }
    
    
    let groupDao =   GroupDao()
    let songDao = SongDao()
    let userDef = UserDefaults.standard
    let identifier = "com.updevel.iguitar.nonCons"
    let maxVisible = 5
    
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
  
    var groupsArr = [Group]()
    
    let testAlphaAr = ["1-9", "A-Z", "А-Я"]
    let alphabet_En = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let alphabet_Ru = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Э", "Ю", "Я"]
    let alphabet_Number =   ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    var alpgabetDataCell: [AlphabetStructure] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.restorationIdentifier == "main" {
            switch segments.selectedSegmentIndex {
            case 0: return  realmGroup.isEmpty ? 0:  realmGroup.count
            case 1: return  realmSongs.isEmpty ? 0:  realmSongs.count
            default:
                return 0
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.row
        
        let delete = UIContextualAction(style: .normal, title: "", handler: {
            (a, b, c) in
      
            switch self.segments.selectedSegmentIndex {
            case 0:
                  print(indexPath.row)
               if self.checkForRowUserDef(indexPath: indexPath) {
                print(indexPath.row)
                self.groupDao.deleteWithChilds(item: self.realmGroup![index])
                }
                c(true)
            case 1:
             if self.checkForRowUserDef(indexPath: indexPath){
                self.songDao.delete(item:self.realmSongs![index])
                }
                c(true)
            default:
                print("nothing to del")
            }
            
        })
        delete.image = UIImage(named: "trash2")
        delete.backgroundColor = UIColor.red
        
        let updateAction = UIContextualAction(style: .normal, title: ""){ (action, i, c) in
            if (self.segments.selectedSegmentIndex == 0) {
                if self.checkForRowUserDef(indexPath: indexPath){
                    self.performSegue(withIdentifier: "updateGroup", sender: self.realmGroup![index])
                }
                c(true)
            } else {
                if self.checkForRowUserDef(indexPath: indexPath){
                    self.performSegue(withIdentifier: "updateSong", sender: self.realmSongs![index])
                }
                c(true)
                
                        }
                    }

        updateAction.image = UIImage(named: "compose")
        
        let config = UISwipeActionsConfiguration(actions:[delete, updateAction])
        config.performsFirstActionWithFullSwipe = false
    
        return config
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let index = indexPath.row

        let favoriteAction = UIContextualAction(style: .normal, title: "") { (action, i, c) in
                        switch self.segments.selectedSegmentIndex {
                        case 0:
                            if self.checkForRowUserDef(indexPath: indexPath){
                            self.groupDao.addToFavorite(item: self.realmGroup![index])
                            }// можно написать что только в платной
                            c(true)
                        case 1:
                             if self.checkForRowUserDef(indexPath: indexPath){
                            self.songDao.addToFavorite(item:self.realmSongs![index])
                             }
                            c(true)
                        default:
                            print("nothing to del")
                        }
                    }
        favoriteAction.image = UIImage(named: "favorite")
        
        let config = UISwipeActionsConfiguration(actions: [favoriteAction])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
  
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.restorationIdentifier == "main" { return 1}
        else {return alpgabetDataCell.count}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // var cell: UITableViewCell
        
        if tableView.restorationIdentifier == "main" {
            
            if (segments.selectedSegmentIndex == 0) {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainViewCell
                let group: Group
                group = realmGroup[indexPath.row]
                
                let image: UIImage
                
                if (group.imgData == nil) {
                    image = UIImage(named: "Photo")!
                } else {
                    image = UIImage(data: group.imgData!)!
                }
                
                cell.imageViewGroup.image = image
                cell.imageViewGroup.layer.cornerRadius = cell.imageViewGroup.frame.width / 2
                cell.imageViewGroup.clipsToBounds = true
                cell.labalGroupName.text = group.name.capitalized
                cell.labelSongQuantity.text = String(format: "кол-во песен: %X", group.listSongs.count)
               
                if(group.isFavorite) {
                    cell.imageViewFavorite.image = UIImage(named: "emptyStar")
                } else {
                    cell.imageViewFavorite.image = nil
                }
                
                cell.backgroundColor = UIColor(patternImage: UIImage())
                return cell
            } else {
                let  cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongViewCell
                let song: Song
                
                song = realmSongs[indexPath.row]
                
                cell.nameSangLabel.text = song.name.capitalized
                if(song.isFavorite) {
                    cell.favoriteImage.image = UIImage(named: "emptyStar")
                } else {
                    cell.favoriteImage.image = nil
                }
                
                cell.backgroundColor = UIColor(patternImage: UIImage())
                return cell
            }
            
        }else {
            let  cell = (tableView.dequeueReusableCell(withIdentifier: "alphabetCell") as! AlphabetViewCell)
             cell.backgroundColor = UIColor(patternImage: UIImage())
            if (indexPath.row == 0) {
                cell.textLabel?.text = alpgabetDataCell[indexPath.section].title
            }else {
                cell.textLabel?.text = alpgabetDataCell[indexPath.section].data[indexPath.row - 1]
            }
            
             cell.backgroundColor = UIColor(patternImage: UIImage())
            return cell
        }
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
        print(letter)
        switch segments.selectedSegmentIndex {
        case 0:
            for i in realmGroup {
                if i.name.first! == Character(letter.lowercased())  { // lowercase взависимости от записи в базе
                
                    index = realmGroup.firstIndex(of: i)  /// сделать в фоновом потоке
                    break
                }
            }
        case 1:
            for i in realmSongs {
                if i.name.first! == Character(letter.lowercased())  { // lowercase взависимости от записи в базе
                    index = realmSongs.firstIndex(of: i)  /// сделать в фоновом потоке
                    break
                }
            }
            
        default:
            print(1)
        }
        
        if index == nil{return}
        let row = IndexPath(row: index!, section: 0)
        
        mainTableView.scrollToRow(at: row, at: .middle, animated: true)
    }
    
    //MARK: DIDLOW
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearch()
        setupGroups()
        setupSongs()
        setNotificationTokenForGroup()
        
        let num = getAlphabetStructure(title: "0-9", arr: alphabet_Number)
        let en = getAlphabetStructure(title: "A-Z", arr: alphabet_En)
        let ru = getAlphabetStructure(title: "А-Я", arr: alphabet_Ru)
        
        alpgabetDataCell.append(num)
        alpgabetDataCell.append(en)
        alpgabetDataCell.append(ru)
        setStyleApp()
    }
    
    func setStyleApp() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.tabBarController?.tabBar.backgroundImage = UIImage()
       
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        
        mainTableView.backgroundColor = UIColor(patternImage: UIImage())
        alphabetTableView.backgroundColor = UIColor(patternImage: UIImage())
       
        segments.tintColor = tintColor.withAlphaComponent(0.3)
        
        let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo", size: 14)!,
                             NSAttributedString.Key.foregroundColor: UIColor.black]
        segments.setTitleTextAttributes(fontAttribute, for: .normal)
        tabBarController?.tabBar.tintColor = tintColor
      
    }
    
    func setupNavigationBar() {
        title = "Все"
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(!isOpenedYet){
            self.tableView(alphabetTableView, didSelectRowAt: IndexPath(item: 0, section: 2))
            isOpenedYet = true
        }
        
        if let textField = self.navigationItem.searchController?.searchBar.value(forKey: "searchField") as? UITextField {
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) { // If `searchController` is in `navigationItem`
                backgroundView?.backgroundColor = tintColor.withAlphaComponent(0.3) //Or any transparent color that matches with the `navigationBar color`
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() }) // Fixes an UI bug when searchBar appears or hides when scrolling
            }
            
            backgroundView?.layer.cornerRadius = 10.5
            backgroundView?.layer.masksToBounds = true
            //Continue changing more properties...
        }
           searchController.searchBar.tintColor = tintColor
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func setNotificationTokenForGroup() {
        if(notificationToken != nil){
            notificationToken!.invalidate()
        }
       
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
    
    private func setNotificationTokenForSong() {
        if(notificationToken != nil){
            notificationToken!.invalidate()
        }
        notificationToken = realmSongs.observe { [weak self] (changes: RealmCollectionChange) in
               guard let mainTableView = self?.mainTableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
              mainTableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                mainTableView.beginUpdates()
                mainTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                mainTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                               with: .automatic)
                mainTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                               with: .automatic)
                mainTableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                // fatalError("\(error)")
                print("err \(error)")
            }
        }
    }
    
    deinit {
        notificationToken = nil
        notificationTokenFiltered = nil
    }
    
    func setupSongs() {
        realmSongs = songDao.getAllItemsSortByName()
    }
    
    func temFunccraete() {
    
    var array = [Group]()
        
        for i in 0...10 {
            let group = Group()
            group.name = "Группа \(i)"
           
            
            for y in 0...30 {
                let song = Song()
                song.name = "песня \(y)"
                song.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
              
                for o in 0...2 {
                    let acckord = Ackord()
                    acckord.name = "dm\(o)"
                    
                    song.ackords.append(acckord)
                }
                
                group.listSongs.append(song)
                           }
             array.append(group)
        }
        
        createNewDataBase(groups: array)
        
    }
    
    private func createNewDataBase(groups: [Group]){
        
        let ackDao = AckordDao()
        
        for gr in groups {
            
            var newGr = Group()
            newGr.name = gr.name
            
            newGr =  groupDao.create(newItem: newGr)
            
            for song in gr.listSongs{
                
                let newSn = Song()
                newSn.parentId = newGr.id
                newSn.name = song.name
                newSn.text = song.text
                
                for ack in song.ackords{
                    var newAck = Ackord()
                    newAck.name = ack.name
                    newAck = ackDao.create(newItem: newAck)
                    newSn.ackords.append(newAck)
                }
                
                _ =   songDao.create(newItem: newSn)
                //update ackk
            }
        }
        
    }
    
    func setupGroups() {
       // temFunccraete()
        realmGroup = groupDao.getAllItemsSortByName()
    }
    
    private func getAlphabetStructure(title: String, arr: [String]) -> AlphabetStructure {
        let structure = AlphabetStructure()
        structure.title = title
        
        for i in arr {
            structure.data.append(i)
        }
        
        return structure
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView.restorationIdentifier == "main"){
            switch segments.selectedSegmentIndex {
            case 0:  return 85
            case 1:  return 50
            default:
               return 85
            }
        } else {
            return 50
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //purchase()
        let indexPath = mainTableView.indexPathForSelectedRow
      return checkForRowUserDef(indexPath: indexPath!)
    }
    
    private func checkForRowUserDef(indexPath: IndexPath) -> Bool {
        print(indexPath.row)
        
         var canAction = false
        
        if checkUserDef() {
            canAction =  true
        } else {
            
            switch self.segments.selectedSegmentIndex {
            case 0:
                if realmGroup[indexPath.row].id < maxVisible {
                    canAction = true
                }
                
                
                // можно написать что только в платной
                
            case 1:
                if realmSongs[indexPath.row].id < maxVisible {
                    canAction = true
                }
            default: break
                
                
            }
        }
        return canAction
    }
    
    private func checkUserDef()-> Bool {
        let purchased = userDef.bool(forKey: "purchased")
        return purchased
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
                addNewVC.isUpdate = true
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
        
        switch segments.selectedSegmentIndex {
        case 0: item = realmGroup![index]
        case 1: item = realmSongs![index]
        default:
            item = nil
        }
        
        return item
    }
    
    @IBAction func sort(_ sender: Any) {
        if (newItemBtn != nil) {
            newItemBtn.isEnabled = !newItemBtn.isEnabled
        }
        
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
    
    func filterBy(text: String) {
        switch segments.selectedSegmentIndex {
        case 0:
            if(text.isEmpty) {
                realmGroup = groupDao.getAllItemsSortByName()
            }else{
                realmGroup = groupDao.contains(name: text)
            }
            setNotificationTokenForGroup()
        case 1:
            if(text.isEmpty) {
                realmSongs = songDao.getAllItemsSortByName()
            } else {
                realmSongs =  songDao.contains(name: text)
            }
            
            setNotificationTokenForSong()
        default:
            print("error search")
        }
        
        mainTableView.reloadData()
    }
    
    private func restore() {
        NetworkActivityIndicator.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            NetworkActivityIndicator.networkOperationFinished()
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                for purchase in results.restoredPurchases {
                    // fetch content from your server, then:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                }
                self.userDef.set(true, forKey: "purchased")
                //   self.setupProducts()
              //  self.tableView.reloadData()  здесть рсторе или юзер дефолтс
                
                print("Restore Success: \(results.restoredPurchases)")
                
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    func purchase()  {
        NetworkActivityIndicator.networkOperationStarted()
        let idString = identifier
        SwiftyStoreKit.retrieveProductsInfo([idString]) { result in
            NetworkActivityIndicator.networkOperationFinished()
            if let productRetriv = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(productRetriv, quantity: 1, atomically: true) { result in
                    // handle result (same as above)
                    print(productRetriv.localizedTitle)
                    print(result)
                    switch result {
                    case .success(let productRetriv):
                        // fetch content from your server, then:
                        if productRetriv.needsFinishTransaction {
                            SwiftyStoreKit.finishTransaction(productRetriv.transaction)
                        }
                       // product.isPurchased = true  поставить юзер дефолт тру
                       // self.tableView.reloadData()
                        
                    // print("Purchase Success: \(productRetriv.productId)")
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        case .privacyAcknowledgementRequired:
                            print("case pokupri")
                        case .unauthorizedRequestData:
                                print("case pokupri")
                        case .invalidOfferIdentifier:
                                print("case pokupri")
                        case .invalidSignature:
                                print("case pokupri")
                        case .missingOfferParams:
                                print("case pokupri")
                        case .invalidOfferPrice:
                                print("case pokupri")
                        @unknown default:
                                print("case pokupri")
                        }
                    }
                }
            }
        }
    }
    
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterBy(text: searchController.searchBar.text!)
    }
}


class NetworkActivityIndicator: NSObject {
    private static var loadingCount = 0
    
    class func networkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished(){
        if loadingCount > 0{
            loadingCount -= 1
        }
        
        if loadingCount == 0{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
}
