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
        loadData()
    }
    
    func loadData(){
        if let landmark = landmark {
            self.title = landmark.title
            latitude.text = landmark.coordinate?.latitude.description
            longitude.text = landmark.coordinate?.longitude.description
            desc.text = landmark.desc
            dateCrea.text = DateFormatter.localizedString(from: landmark.creationDate!, dateStyle: .short, timeStyle: .short)
            dateModif.text = DateFormatter.localizedString(from: landmark.modificationDate!, dateStyle: .short, timeStyle: .short)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "editPlace"){
            let navViewController = segue.destination as! UINavigationController
            let destination = navViewController.topViewController as! AddEditPlaceViewController
            destination.currentCategory = landmark.category
            destination.entete = "Edit"
            destination.landmark = landmark
            destination.delegate = self
        }
    }


}

extension PlaceDetailsViewController : AddEditPlaceViewControllerDelegate{
    func addEditPlaceViewControllerEdit(_ controller: AddEditPlaceViewController,
                                        landmark: Landmark,
                                        title: String?,
                                        lat: Double?,
                                        long: Double?,
                                        description: String?,
                                        image: Data) {
        DataManager.sharedDataManager.editLandmark(landmark: landmark,
                                                   title: title ?? "",
                                                   lat: lat,
                                                   long: long,
                                                   desc: description ?? "",
                                                   image: image)
        loadData()
        dismiss(animated: true)
    }
    
    func addEditPlaceViewControllerDidCancel(_ controller: AddEditPlaceViewController) {
        dismiss(animated: true)
    }

    func addEditPlaceViewControllerAdd(_ controller: AddEditPlaceViewController, title: String?, lat: Double?, long: Double?, description: String?, image: Data) {
    }
}
