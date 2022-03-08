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
    
    var category: Category!
    
    var delegate: CategoryItemCellDelegate!

    @IBAction func editItem(_ sender: Any) {
        self.delegate.categoryItemCell(self, didEditFor: category)
    }
    
    
}
