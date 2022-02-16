//
//  LandmarkItemCell.swift
//  iOS
//
//  Created by lpiem on 16/02/2022.
//

import Foundation
import UIKit

class LandmarkItemCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var favorite: UIImageView!
    @IBOutlet weak var landmarkImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
}
