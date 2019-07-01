//
//  AddNewItemProtocol.swift
//  iguitar
//
//  Created by Up Devel on 28/06/2019.
//  Copyright © 2019 Up Devel. All rights reserved.
//

import Foundation
import UIKit

protocol AddNewItemProtocol {
    associatedtype T
    var delegate: UIViewController? {get set}
    var iten: T? {get set}
    var dao: RealmDao<CommomWithId>? {set get}
    func getItemForSave() -> T
   func setupItem()
    func setupDao()

}

extension AddNewItemProtocol {
    func displayError(text: String) {
        let aContr = UIAlertController(title: nil, message: "Такая группа уже есть в приложении", preferredStyle: .alert)
        let aAction = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        aContr.addAction(aAction)
        
        delegate?.present(aContr, animated: true, completion: nil)
    }
    
    func cancel() {
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    func checkSameByName(name: String) -> Bool {
        
        let items = dao?.getBy(name: name)
        return items!.count > 0
    }
 
}

