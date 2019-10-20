//
//  AddNewSongViewController.swift
//  iguitar
//
//  Created by Up Devel on 24/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class AddNewGroupViewController: UITableViewController {

    var group: Group?
    var isUpdate = false
    let groupDao = GroupDao()
    var isChageImage = false { // this
        didSet {
            if(!nameGroup.text!.isEmpty) {
                saveBtn.isEnabled = true
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameGroup: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let saveGroup = getGroupForSave()
      
        if(isUpdate) {
            let checkSame = checkSameByName(name: saveGroup.name)
            saveGroup.id = group!.id
            saveGroup.listSongs = group!.listSongs
          
            if(checkSame && !isChageImage){
                displayErrore()
                return
            }
            
            groupDao.update(oldItem: saveGroup)
            
        } else {
            let checkSame = checkSameByName(name: saveGroup.name)
            
            if(checkSame){
                displayErrore()
                return
            }
            saveGroup.isUser = true
            _ = groupDao.create(newItem: saveGroup)
        }
        
       dismiss(animated: true, completion: nil)
    }
    
    private func checkSameByName(name: String) -> Bool {
        let group = Group()
        group.name = name
        let check = groupDao.checkBy(nameOf: group)
        return check
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBAction func choosePhotoGroup(_ sender: UIImageView) {
        chooseImage(by: .photoLibrary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        nameGroup.addTarget(self, action: #selector(emptyFieldListener), for: .editingChanged)
        
        saveBtn.isEnabled = false
        
        if(group != nil) {
            isUpdate = true

        }else {
            group = Group()
        }
     
        setupGroup()
        setStyleApp()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            chooseImage(by: .photoLibrary)
        } else {
            view.endEditing(true)
        }
    }
    
    func setStyleApp() {
        tableView.backgroundColor = UIColor(patternImage: UIImage())
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.backgroundColor = UIColor(patternImage: UIImage())
        tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.backgroundColor = UIColor(patternImage: UIImage())
       
        nameGroup.backgroundColor = tintColor.withAlphaComponent(0.3)
        
         navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func displayErrore(){
        let aContr = UIAlertController(title: nil, message: NSLocalizedString("This group is already in the application", comment: "This group is already in the application"), preferredStyle: .alert)
        let aAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        aContr.addAction(aAction)
        
        present(aContr, animated: true, completion: nil)
    }
    
    private func getGroupForSave() -> Group {
        let group = Group()
        group.name = nameGroup.text!
        group.isUser = true
        group.isFavorite = self.group!.isFavorite
        group.imgData = imageView.image?.pngData()
        return group
    }
    
    // MARK: - Table view data source
    
    @objc func emptyFieldListener() { // tgis
        if(nameGroup.text!.isEmpty) {
            saveBtn.isEnabled = false
            title = NSLocalizedString("New group", comment: "New group")
            
        } else {
            saveBtn.isEnabled = true
            title = nameGroup.text!.capitalized
        }
    }

    private func setupGroup() {
        let image: UIImage
        imageView.backgroundColor = UIColor(patternImage: UIImage())
        
        if (group?.imgData == nil) {
            image = UIImage(named: "plus")!
        } else {
            image = UIImage(data: group!.imgData!)!
        }
        
        imageView.image = image
        nameGroup.text = group?.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2 // запас для акордов
    }
}

extension AddNewGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage(by source: UIImagePickerController.SourceType ) {
        let uIPC = UIImagePickerController()
        uIPC.delegate = self
        uIPC.allowsEditing = true
        uIPC.sourceType = source
       
        present(uIPC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
        isChageImage = true
    }
}
