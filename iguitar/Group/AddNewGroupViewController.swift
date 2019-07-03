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
               _ = groupDao.create(newItem: saveGroup)
        }
        
       dismiss(animated: true, completion: nil)
    }
    
    private func checkSameByName(name: String) -> Bool {
        
        let group = groupDao.getBy(name: name)!
        return group.count > 0
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBAction func choosePhotoGroup(_ sender: Any) {
    
        chooseImage(by: .photoLibrary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameGroup.addTarget(self, action: #selector(emptyField), for: .editingChanged)
        
        saveBtn.isEnabled = false
        
        if(group != nil) {
            isUpdate = true

        }else {
            group = Group()
        }
     
      setupGroup()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func displayErrore(){
      
        let aContr = UIAlertController(title: nil, message: "Такая группа уже есть в приложении", preferredStyle: .alert)
        let aAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        aContr.addAction(aAction)
        
            present(aContr, animated: true, completion: nil)
    }
    
    private func getGroupForSave() -> Group {
        let group = Group()
        group.name = nameGroup.text!
        group.imgData = imageView.image?.jpegData(compressionQuality: 0.75)
        return group
    }
    
    // MARK: - Table view data source
    
    @objc func emptyField() { // tgis
        if(nameGroup.text!.isEmpty) {
            saveBtn.isEnabled = false
            title = "Новая группа"
            
        } else {
            saveBtn.isEnabled = true
            title = nameGroup.text!
        }
    }

    private func setupGroup() {
        let image: UIImage
        
        if (group?.imgData == nil) {
            image = UIImage(named: "Photo")!
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
