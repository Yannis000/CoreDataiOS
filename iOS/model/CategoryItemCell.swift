//
//  CategoryItemCell.swift
//  iOS
//
//  Created by lpiem on 08/03/2022.
//

import Foundation
import UIKit


protocol CategoryItemCellDelegate: AnyObject{
    func categoryItemCell(_ cell: CategoryItemCell, didEditFor: Category)
}

class CategoryItemCell: UITableViewCell{


    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var date: UILabel!
    
    var category: Category!
    
    var delegate: CategoryItemCellDelegate!

    @IBAction func editItem(_ sender: Any) {
        self.delegate.categoryItemCell(self, didEditFor: category)
    }
    
    func configure(category: Category){
        self.category = category
        title.text = category.name
        date.text = DateFormatter.localizedString(from: category.creationDate!, dateStyle: .short, timeStyle: .short)
    }
    
}
