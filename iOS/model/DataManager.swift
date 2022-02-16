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
            var result = try container.viewContext.fetch(fetchRequest)
            switch (FilterManager.sharedFilterManager.filter){
            case FilterType.date:
                result.sort(by: { $0.creationDate!.compare($1.creationDate!) == .orderedAscending})
            case FilterType.name:
                result.sort(by: { $0.name!.compare($1.name!) == .orderedAscending})
            case FilterType.fav:
                break
            }
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
    
    func fetchLandmarks(searchQuery: String? = nil, category: Category) -> [Landmark] {
        let fetchRequest = Landmark.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [#keyPath(Landmark.category), category])
        
        var predicates: [NSPredicate] = []
        predicates.append(predicate)
        
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@",
                                        argumentArray: [#keyPath(Landmark.title), searchQuery])
            predicates.append(predicate)
        }
        fetchRequest.predicate = NSCompoundPredicate(
            type: .and,
            subpredicates: predicates
        )
        do{
            var result = try container.viewContext.fetch(fetchRequest)
            switch (FilterManager.sharedFilterManager.filter){
            case FilterType.date:
                result.sort(by: { $0.creationDate!.compare($1.creationDate!) == .orderedAscending})
            case FilterType.name:
                result.sort(by: { $0.title!.compare($1.title!) == .orderedAscending})
            case FilterType.fav:
                result = result.filter{ $0.isFavorite == true }
            }
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func createLandmark(title: String, date: Date = Date(), lat: Double?, long: Double?, desc: String? = "", image: Data, cat: Category){
        let landmark = Landmark(context: container.viewContext)
        landmark.title = title
        landmark.creationDate = date
        landmark.modificationDate = date
        landmark.isFavorite = false
        landmark.desc = desc
        landmark.coordinate = createCoordonate(latitude: 0.0, longitude: 0.0)
        landmark.category = cat
        landmark.image = image
        saveContext()
    }
    
    func createCoordonate(latitude: Double, longitude: Double) -> Coordinate {
        let coordinate = Coordinate(context: container.viewContext)
        coordinate.latitude = latitude
        coordinate.longitude = longitude
        saveContext()
        return coordinate
    }
    
    func deleteLandmark(landmark: Landmark){
        container.viewContext.delete(landmark)
        saveContext()
    }
    
}
