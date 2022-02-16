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
    
    var filter: FilterType = FilterType.date
    var delegate: FilterManagerDelegate?
    
    var dateItem: UIAction { return UIAction(title: "Par date", image: UIImage(systemName: "person.fill")) { (action) in

        self.filter = FilterType.date
        self.delegate?.filterHasChange()
    }}

    var nameItem: UIAction { return UIAction(title: "Par nom", image: UIImage(systemName: "person.badge.plus")) { (action) in

        self.filter = FilterType.name
        self.delegate?.filterHasChange()
    }}

    var favItem: UIAction { return UIAction(title: "Favoris", image: UIImage(systemName: "person.fill.xmark.rtl")) { (action) in
        self.filter = FilterType.date
        self.delegate?.filterHasChange()
    }}
}

protocol FilterManagerDelegate : AnyObject {
    func filterHasChange()
}

enum FilterType {
    case name
    case date
    case fav
}
