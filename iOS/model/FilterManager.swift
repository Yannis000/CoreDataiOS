//
//  FilterManager.swift
//  iOS
//
//  Created by lpiem on 16/02/2022.
//

import Foundation
import UIKit

class FilterManager: NSObject {
    
    static let sharedFilterManager = FilterManager()
    
    var filter: FilterType = FilterType.dateM
    var delegate: FilterManagerDelegate?
    
    var dateCreaItem: UIAction { return UIAction(title: "Par date de création", image: UIImage(systemName: "person.fill")) { (action) in
        if(self.filter != FilterType.dateC){
            self.filter = FilterType.dateC
            self.delegate?.filterHasChange()
        }
        
    }}
    
    var dateModifItem: UIAction { return UIAction(title: "Par date de modification", image: UIImage(systemName: "person.fill")) { (action) in
        if(self.filter != FilterType.dateM){
            self.filter = FilterType.dateM
            self.delegate?.filterHasChange()
        }
    }}

    var nameItem: UIAction { return UIAction(title: "Par nom", image: UIImage(systemName: "person.badge.plus")) { (action) in
        if(self.filter != FilterType.name){
            self.filter = FilterType.name
            self.delegate?.filterHasChange()
        }
    }}

    var favItem: UIAction { return UIAction(title: "Favoris", image: UIImage(systemName: "person.fill.xmark.rtl")) { (action) in
        if(self.filter != FilterType.dateC){
            self.filter = FilterType.dateC
            self.delegate?.filterHasChange()
        }
    }}
}

protocol FilterManagerDelegate : AnyObject {
    func filterHasChange()
}

enum FilterType {
    case name
    case dateC
    case dateM
    case fav
}
