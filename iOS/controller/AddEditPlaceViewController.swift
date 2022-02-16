//
//  AddEditPlaceViewController.swift
//  iOS
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class AddEditPlaceViewController: UIViewController {

    var currentCategory: Category!
    var entete: String = ""
    var landmark: Landmark!
    var delegate: AddEditPlaceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = entete
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var placeTitle: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.addEditPlaceViewControllerDidCancel(self)
    }
    @IBAction func savePlace(_ sender: Any) {
        guard let title = self.placeTitle.text else {
            return
        }
        guard let lat = self.latitude.text else {
            return
        }
        guard let long = self.longitude.text else {
            return
        }
        guard let description = self.desc.text else {
            return
        }
        self.delegate?.addEditPlaceViewControllerAdd(self, title: title, lat: Double(lat), long: Double(long), description: description)
    }
}

protocol AddEditPlaceViewControllerDelegate : AnyObject {
    func addEditPlaceViewControllerDidCancel(_ controller: AddEditPlaceViewController)
    func addEditPlaceViewControllerAdd(_ controller: AddEditPlaceViewController, title: String?, lat: Double?, long: Double?, description: String?)
}

