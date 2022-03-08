//
//  LandmarkItemCell.swift
//  iOS
//
//  Created by lpiem on 16/02/2022.
//

import Foundation
import UIKit

protocol LandmarkItemCellDelegate : AnyObject {
    func landmarkItemCell(_ cell: LandmarkItemCell, didChangeFavoriteFor: Landmark)
}

class LandmarkItemCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var favorite: UIImageView!
    @IBOutlet weak var landmarkImage: UIImageView!
    
    var landmark: Landmark!
    
    var delegate : LandmarkItemCellDelegate!
    
    @IBAction func addToFav(_ sender: Any) {
        self.delegate.landmarkItemCell(self, didChangeFavoriteFor: landmark)
    }
    
    func configure(landmark: Landmark){
        self.landmark = landmark
        title.text = landmark.title
        desc.text = landmark.desc
        if let image = landmark.image {
            landmarkImage.image = UIImage(data: image)
        } else {
            landmarkImage.image = UIImage(systemName: "photo")
        }
        favorite.image = landmark.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
}
