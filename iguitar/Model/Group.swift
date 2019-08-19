//
//  Group.swift
//  iguitar
//
//  Created by Up Devel on 19/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import RealmSwift

class Group: CommomWithId {
    @objc dynamic var name = ""
    @objc dynamic var descriptionGroup = ""
    @objc dynamic var isUser = false
    @objc dynamic var imgData: Data?
    @objc dynamic var isFavorite = false
    var listSongs = List<Song>()
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

