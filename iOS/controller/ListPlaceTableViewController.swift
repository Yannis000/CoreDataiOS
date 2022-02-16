//
//  ListPlaceTableViewController.swift
//  iOS
//
//  Created by lpiem on 09/02/2022.
//

import UIKit

class ListPlaceTableViewController: UITableViewController {
    
    var currentCategory: Category!
    
    var landmarks: [Landmark] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentCategory.name
        self.landmarks = DataManager.sharedDataManager.fetchLandmarks(category: currentCategory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addPlace"){
            let navViewController = segue.destination as! UINavigationController
            let destination = navViewController.topViewController as! AddEditPlaceViewController
            destination.currentCategory = currentCategory
            destination.entete = "Add"
            destination.delegate = self
        }
    }
    
    //tableView Datasource and Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LandmarkItemCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! LandmarkItemCell
        let place = landmarks[indexPath.row]
        cell.title.text = place.title
        cell.desc.text = "Description"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = landmarks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [weak self] _, _, completion in
            guard let self = self else {
                return
            }
            DataManager.sharedDataManager.deleteLandmark(landmark: place)
            self.landmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeACtionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeACtionConfiguration
    }
    
    
}

extension ListPlaceTableViewController : AddEditPlaceViewControllerDelegate{
    func addEditPlaceViewControllerDidCancel(_ controller: AddEditPlaceViewController) {
        dismiss(animated: true)
    }

    func addEditPlaceViewControllerAdd(_ controller: AddEditPlaceViewController, title: String?) {
        DataManager.sharedDataManager.createLandmark(title: title ?? "", cat: self.currentCategory)

        self.landmarks = DataManager.sharedDataManager.fetchLandmarks(category: self.currentCategory)
        self.tableView.reloadData()
        dismiss(animated: true)
    }
}
