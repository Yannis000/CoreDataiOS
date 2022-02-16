//
//  PlaceDetailsViewController.swift
//  iOS
//
//  Created by lpiem on 16/02/2022.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    var landmark: Landmark!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateCrea: UILabel!
    @IBOutlet weak var dateModif: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let landmark = landmark {
            self.title = landmark.title
            if let image = landmark.image{
                imageView.image = UIImage(data: image)
            }
            latitude.text = landmark.coordinate?.latitude.description
            longitude.text = landmark.coordinate?.longitude.description
            desc.text = landmark.desc
            dateCrea.text = DateFormatter.localizedString(from: landmark.creationDate!, dateStyle: .short, timeStyle: .short)
            dateModif.text = DateFormatter.localizedString(from: landmark.modificationDate!, dateStyle: .short, timeStyle: .short)
        }
    }


}
