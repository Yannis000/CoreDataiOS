//
//  DataManager.swift
//  iOS
//
//  Created by lpiem on 09/02/2022.
//

import UIKit
import CoreData
class DataManager: NSObject {

    static let sharedDataManager = DataManager()
    
    var container: NSPersistentContainer{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // Core Data
    
    func saveContext(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func fetchCategories(searchQuery: String? = nil) -> [Category] {
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
    
    func deleteCategory(category: Category){
        container.viewContext.delete(category)
        saveContext()
    }
    
    func createCategory(title: String, date: Date = Date()){
        let category = Category(context: container.viewContext)
        category.name = title
        category.creationDate = date
        category.modificationDate = date
        saveContext()
    }
}
