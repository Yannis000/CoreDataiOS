//
//  ViewController.swift
//  iOS
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    
    //Properties
    
    private var categories: [Category] = []
    
    private var container: NSPersistentContainer{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // Core Data
    
    private func saveContext(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    private func fetchCategories(searchQuery: String? = nil) -> [Category] {
        let fetchRequest = Category.fetchRequest()
        
        let sortDescription = NSSortDescriptor(keyPath: \Category.name ,ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@",
                                        argumentArray: [#keyPath(Category.name), searchQuery])
            fetchRequest.predicate = predicate
        }
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    private func deleteCategory(category: Category){
        container.viewContext.delete(category)
        saveContext()
    }
    
    private func createCategory(title: String, date: Date = Date()){
        let category = Category(context: container.viewContext)
        category.name = title
        category.creationDate = date
        category.modificationDate = date
        saveContext()
    }
    
    //Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        categories = fetchCategories()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //tableViw Datasource and Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = DateFormatter.localizedString(from: category.creationDate!, dateStyle: .short, timeStyle: .short)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = categories[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Supprimer") { [weak self] _, _, completion in
            guard let self = self else {
                return
            }
            self.deleteCategory(category: category)
            self.categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeACtionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeACtionConfiguration
    }
    
    //User Interactions
    @IBAction func addNewCategory(_ sender: Any) {
        let alertController = UIAlertController(title: "Nouvelle catégorie",
        message: "Ajouter une catégorie a ma liste",
                                                preferredStyle: .alert)
        alertController.addTextField{
            textField in textField.placeholder = "Nom..."
        }
        
        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: .cancel,
                                         handler: nil)
        let saveAction = UIAlertAction(title: "Sauvegarder",
                                       style: .default) { [weak self] _ in
            guard let self = self,
                  let textField = alertController.textFields?.first else {
                return
            }
            self.createCategory(title: textField.text!)
            self.categories = self.fetchCategories()
            self.tableView.reloadData()
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    

    
}

extension CategoryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        categories = fetchCategories(searchQuery: searchQuery)
        tableView.reloadData()
    }

}

