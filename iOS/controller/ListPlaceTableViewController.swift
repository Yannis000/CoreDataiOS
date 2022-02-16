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

    @IBOutlet weak var btnFiltres: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = currentCategory.name
        self.landmarks = DataManager.sharedDataManager.fetchLandmarks(category: currentCategory)
        FilterManager.sharedFilterManager.delegate = self
        var menu: UIMenu {
            return UIMenu(title: "Filtrer", options: .displayInline, children: [FilterManager.sharedFilterManager.dateItem,
                                                                                FilterManager.sharedFilterManager.nameItem,
                                                                                FilterManager.sharedFilterManager.favItem])
        }
        btnFiltres.menu = menu
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addPlace"){
            let navViewController = segue.destination as! UINavigationController
            let destination = navViewController.topViewController as! AddEditPlaceViewController
            destination.currentCategory = currentCategory
            destination.entete = "Add"
            destination.delegate = self
        }else if(segue.identifier == "detailsPlace"){
            let destination = segue.destination as! PlaceDetailsViewController
            let cell = sender as! UITableViewCell
            destination.landmark = landmarks[tableView.indexPath(for: cell)!.row]
        }
    }
    
    //tableView Datasource and Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let place = landmarks[indexPath.row]
        cell.textLabel?.text = place.title
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: place.creationDate!, dateStyle: .short, timeStyle: .short)
        
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

    func addEditPlaceViewControllerAdd(_ controller: AddEditPlaceViewController, title: String?, lat: Double?, long: Double?, description: String?) {
        DataManager.sharedDataManager.createLandmark(title: title ?? "", lat: lat, long: long, desc: description ?? "", cat: self.currentCategory)
        self.landmarks = DataManager.sharedDataManager.fetchLandmarks(category: self.currentCategory)
        self.tableView.reloadData()
        dismiss(animated: true)
    }
}

extension ListPlaceTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        landmarks = DataManager.sharedDataManager.fetchLandmarks(searchQuery: searchQuery, category: self.currentCategory)
        tableView.reloadData()
    }
}

extension ListPlaceTableViewController: FilterManagerDelegate {
    func filterHasChange() {
        landmarks = DataManager.sharedDataManager.fetchLandmarks(category: self.currentCategory)
        tableView.reloadData()
    }
}
