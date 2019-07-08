////
////  FavoriteSongViewController.swift
////  iguitar
////
////  Created by Up Devel on 24/06/2019.
////  Copyright © 2019 Up Devel. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class FavoriteSongViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    @IBOutlet weak var tableView: UITableView!
//
//    private var song: Results<Song>?
//    private let songDao =  RealmDao<Song>()
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  song == nil ? 0 : song!.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongViewCell
//        
//        cell.textLabel?.text = song![indexPath.row].name
//
//        return cell
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupSongs()
//        setupNavigationBar()
//
//        // Do any additional setup after loading the view.
//
//    }
//
//    private func setupSongs() {
//           let favoriteSongs = self.songDao.getFavorite()
//        self.song = favoriteSongs
//
//        //  self.tableView.reloadData()
//
////        DispatchQueue(label: "background").async {
////
////
////                let favoriteSongs = self.songDao.getFavorite()
////                self.song = favoriteSongs
////
////               // self.tableView.reloadData()
////
////        }
//    }
//
//    private func setupNavigationBar() {
//
//        let top = navigationController?.navigationBar.topItem
//        top?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем кнопку кансел и все что идет после стрелочки кнопки назад
//        navigationItem.leftBarButtonItem = nil
//
//        title = "Избранные песни"
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if  segue.identifier != "showSong" {return}
//
//        guard let index =  tableView.indexPathForSelectedRow?.row else { return }
//        let  faVsong = song![index]
//
//        let groupVC = segue.destination as! SongViewController
//        groupVC.song = faVsong
//    }
//
//
//}
