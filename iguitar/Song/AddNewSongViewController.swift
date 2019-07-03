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
            let checkSame = checkSameByName(name: saveSong.name)
            saveSong.id = song!.id
            
            if(checkSame){
                displayErrore()
                return
            }
            
            songDao.update(oldItem: saveSong)
            /// посмотреть тчо быдкт gecnbnm пустить цикл для сохранения акордов
            
            
        } else {
            let checkSame = checkSameByName(name: saveSong.name)
            
            if(checkSame){
                displayErrore()
                return
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
        setAckordsFor(song: song)
        
        return song
    }
    
    private func setAckordsFor(song: Song) {
    
        let line =  ackords.text!
        
        if (!line.isEmpty) {return}
        
        var ackkordArr = [Ackord]()
        
        let ackordsSplit = line.split(separator: ",")
        
        for ack in ackordsSplit {
            
            let nameAckkord = String(ack)
            
            let ackord = chekAckordBy(name: nameAckkord)
            
            ackkordArr.append(ackord)
            
            song.ackords.append(ackord)
        }
    
    }
    
    private func chekAckordBy(name: String) -> Ackord {
        
       let ackords =  ackordDao.getBy(name: name.lowercased())
        
        if (ackords!.count > 0) {
            return ackords![0]
        } else {
            let ackord = Ackord()
            ackord.name = name
            
            return ackord
        }
        
    }
    
    private func checkSameByName(name: String) -> Bool {
        
        let songs = songDao.getBy(name: name)!
        return songs.count > 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songName.addTarget(self, action: #selector(emptyField), for: .editingChanged)
        
        saveBtn.isEnabled = false
        
        if(song != nil) {
            isUpdate = true
            
        }else {
            song = Song()
        }
        
        setupSong()
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
        
        ackords.text = line
    }
    
    @objc func emptyField() { // tgis
        
        if(songName.text!.isEmpty) {
            saveBtn.isEnabled = false
            title = "Новая песня"
            
        } else {
            saveBtn.isEnabled = true
            title = songName.text!
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
