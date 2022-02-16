//
//  AddEditPlaceViewController.swift
//  iOS
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import PhotosUI

class AddEditPlaceViewController: UIViewController, PHPickerViewControllerDelegate {

    var currentCategory: Category!
    var entete: String = ""
    
    var config = PHPickerConfiguration()
    
    var delegate: AddEditPlaceViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = entete
        self.imageView.image = UIImage(systemName: "plus")
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        // Do any additional setup after loading the view.
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
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cancel(_ sender: Any) {
        self.delegate?.addEditPlaceViewControllerDidCancel(self)
    }
    
    @IBAction func savePlace(_ sender: Any) {
        guard let title = self.placeTitle.text else {
            return
        }
        guard let image = self.imageView.image?.pngData() else{
            return
        }
        guard let desc = self.desc.text else{
            return
        }
        self.delegate?.addEditPlaceViewControllerAdd(self, title: title, desc: desc, image: image)
    }
}

protocol AddEditPlaceViewControllerDelegate : AnyObject {
    func addEditPlaceViewControllerDidCancel(_ controller: AddEditPlaceViewController)
    func addEditPlaceViewControllerAdd(_ controller: AddEditPlaceViewController, title: String?, desc: String?, image: Data)
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


