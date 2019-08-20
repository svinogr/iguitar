//
//  AddNewSongViewController.swift
//  iguitar
//
//  Created by Up Devel on 28/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import UIKit

class AddNewSongViewController: UITableViewController {
    var song: Song?
    var isUpdate = false
    let songDao = SongDao()
    let ackordDao = AckordDao()
    
    @IBOutlet weak var songName: UITextField!
    @IBOutlet weak var ackords: UITextField!
    @IBOutlet weak var textSong: UITextView!
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        let saveSong = getSongForSave()
        
        if(isUpdate) {
          let checkSame = checkSameByName(nameOf: saveSong)
            saveSong.id = song!.id

           let  chackUpdateName = saveSong.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == song?.name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            if(checkSame && !chackUpdateName){
                displayErrore()
                return
            }
     
            for ackord in saveSong.ackords {
                if (ackord.id == 0) {
                   _ =  ackordDao.create(newItem: ackord)
                }
            }
          
               songDao.update(oldItem: saveSong)
        } else {
            let checkSame = checkSameByName(nameOf: saveSong)
            
            if(checkSame){
                displayErrore()
                return
            }
            
            saveSong.isUser = true
            
            for ackord in saveSong.ackords {
                if (ackord.id == 0) {
                  _ =  ackordDao.create(newItem: ackord)
                }
            }
            _ = songDao.create(newItem: saveSong)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    
    private func getSongForSave() -> Song {
        let song = Song()
        song.name = songName.text!
        song.text = textSong.text!
        song.parentId = self.song!.parentId
        song.isUser = self.song!.isUser
        setAckordsFor(song: song)
        
        return song
    }
    
    private func setAckordsFor(song: Song) {
        let line =  ackords.text!
        
        if (line.isEmpty) {return}
        
       // var ackkordArr = [Ackord]()
        
        let ackordsSplit = line.split(separator: ",")
        
        var setAck = Set<String>()
        
        for ackSplit in ackordsSplit {
            setAck.insert(String(ackSplit).lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        for ack in setAck {
            let nameAckkord = String(ack)
            
            let ackord = chekAckordBy(name: nameAckkord)
      
            song.ackords.append(ackord)
        }
    }
    
    private func chekAckordBy(name: String) -> Ackord {
        let ack = Ackord()
        ack.name = name
        let check =  ackordDao.checkBy(nameOf: ack)
        
        if (check) {
            return ackordDao.getBy(name: name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))![0]
        } else {
            let ackord = Ackord()
            ackord.name = name
            
            return ackord
        }
    }
    
    private func checkSameByName(nameOf: Song) -> Bool {
        return songDao.checkBy(nameOf: nameOf)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                  view.endEditing(true)
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        songName.addTarget(self, action: #selector(emptyFieldListener), for: .editingChanged)
        
        saveBtn.isEnabled = false
        
        if(isUpdate) {
            ackords.addTarget(self, action: #selector(updateFieldListener), for: .editingChanged)
            textSong.delegate = self
        }

        setupSong()
        setStyleApp()
    }
    
    func setStyleApp() {
        tableView.backgroundColor = UIColor(patternImage: UIImage())
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "woodBackground")!)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationItem.leftBarButtonItem?.tintColor = tintColor
        navigationItem.rightBarButtonItem?.tintColor = tintColor
        tableView.cellForRow(at: IndexPath(item: 0, section: 0))?.backgroundColor = UIColor(patternImage: UIImage())
        tableView.cellForRow(at: IndexPath(item: 1, section: 0))?.backgroundColor = UIColor(patternImage: UIImage())
        tableView.cellForRow(at: IndexPath(item: 2, section: 0))?.backgroundColor = UIColor(patternImage: UIImage())
        
        songName.backgroundColor = tintColor.withAlphaComponent(0.3)
        ackords.backgroundColor = tintColor.withAlphaComponent(0.3)
        textSong.backgroundColor = tintColor.withAlphaComponent(0.3)
        textSong.layer.cornerRadius = 6 // подобрано вручную- пересчитать
        textSong.clipsToBounds = true
        
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc func updateFieldListener() {
        if(!songName.text!.isEmpty) {
            saveBtn.isEnabled = true}
    }
    
    func setupSong() {
        songName.text = song?.name
        setAckordsForView()
        textSong.text = song?.text
    }
    
    private func setAckordsForView() {
        var line = ""
        
        for i in 0..<song!.ackords.count {
            
            line.append((song?.ackords[i].name)!)
            if(i < song!.ackords.count - 1) {
                line.append(",")
            }
        }
        
        ackords.text = line.ackordUpCase
    }
    
    @objc func emptyFieldListener() { // tgis
        if(songName.text!.isEmpty) {
            saveBtn.isEnabled = false
            title = "Новая песня"
        } else {
            saveBtn.isEnabled = true
            title = songName.text!.capitalized
        }
    }
    
    private func displayErrore(){
        let aContr = UIAlertController(title: nil, message: "Такое название песни уже есть в приложении", preferredStyle: .alert)
        let aAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        aContr.addAction(aAction)
        
        present(aContr, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

}

extension AddNewSongViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateFieldListener()
    }
}
