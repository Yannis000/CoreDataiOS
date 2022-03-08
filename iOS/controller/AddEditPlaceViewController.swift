//
//  AddEditPlaceViewController.swift
//  iOS
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import PhotosUI

class AddEditPlaceViewController: UIViewController, PHPickerViewControllerDelegate, UITextViewDelegate{

    var currentCategory: Category!
    var entete: String = ""
    var landmark: Landmark?
    
    var config = PHPickerConfiguration()
    
    var delegate: AddEditPlaceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = entete
        self.imageView.image = UIImage(systemName: "photo")
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        desc.layer.borderWidth = 0.1
        desc.layer.cornerRadius = 8
        desc.layer.borderColor = UIColor.gray.cgColor
        desc.delegate = self
        // Do any additional setup after loading the view.
        if(entete == "Edit"){
            placeTitle.text = landmark?.title
            latitude.text = landmark?.coordinate?.latitude.description
            longitude.text = landmark?.coordinate?.longitude.description
            desc.text = landmark?.desc
            if let image = landmark?.image {
                imageView.image = UIImage(data: image)
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text.isEmpty){
            descPlaceholder.isHidden = false
        }else {
            descPlaceholder.isHidden = true
        }
    }

    @IBAction func addImage(_ sender: Any) {
        
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var placeTitle: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var descPlaceholder: UILabel!
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
        guard let image = self.imageView.image?.pngData() else{
            return
        }
        if(landmark == nil){
            self.delegate?.addEditPlaceViewControllerAdd(self, title: title, lat: Double(lat), long: Double(long), description: description, image: image)
        } else {
            self.delegate?.addEditPlaceViewControllerEdit(self, landmark: landmark!, title: title, lat: Double(lat), long: Double(long), description: description, image: image)
        }
        
    }
}

protocol AddEditPlaceViewControllerDelegate : AnyObject {
    func addEditPlaceViewControllerDidCancel(_ controller: AddEditPlaceViewController)
    func addEditPlaceViewControllerAdd(_ controller: AddEditPlaceViewController, title: String?, lat: Double?, long: Double?, description: String?, image: Data)
    func addEditPlaceViewControllerEdit(_ controller: AddEditPlaceViewController, landmark: Landmark, title: String?, lat: Double?, long: Double?, description: String?, image: Data)
}

extension AddEditPlaceViewController{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        guard !results.isEmpty else { return }
        let imageResult = results[0]
        if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = selectedImage as? UIImage
                    }
                }
            }
        }

    }
}


