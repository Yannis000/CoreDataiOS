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
            case FilterType.dateC:
                result.sort(by: { $0.creationDate!.compare($1.creationDate!) == .orderedDescending})
            case FilterType.dateM:
                result.sort(by: { $0.modificationDate!.compare($1.modificationDate!) == .orderedDescending})
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
    
    func editCategory(category: Category, name: String?, date : Date = Date()){
        category.name = name ?? category.name
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
            case FilterType.dateC:
                result.sort(by: { $0.creationDate!.compare($1.creationDate!) == .orderedDescending})
            case FilterType.dateM:
                result.sort(by: { $0.modificationDate!.compare($1.modificationDate!) == .orderedDescending})
            case FilterType.name:
                result.sort(by: { $0.title!.compare($1.title!) == .orderedAscending})
            case FilterType.fav:
                result.sort { $0.isFavorite && !$1.isFavorite }
            }
            return result
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchAllLandmarks() -> [Landmark] {
        let fetchRequest = Landmark.fetchRequest()
        do{
            let result = try container.viewContext.fetch(fetchRequest)
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
        landmark.coordinate = createCoordonate(latitude: lat ?? 0.0, longitude: long ?? 0.0)
        landmark.category = cat
        landmark.image = image
        saveContext()
    }
    
    func editLandmark(landmark: Landmark, title: String? = nil, date: Date = Date(), lat: Double? = nil, long: Double? = nil, desc: String? = nil, image: Data? = nil){
        landmark.title = title ?? landmark.title
        landmark.modificationDate = date
        landmark.desc = desc ?? landmark.desc
        landmark.coordinate = createCoordonate(latitude: lat ?? (landmark.coordinate?.latitude ?? 0.0), longitude: long ?? (landmark.coordinate?.longitude ?? 0.0))
        landmark.image = image ?? landmark.image
        saveContext()
    }
    
    func toggleFavorite(landmark: Landmark){
        landmark.isFavorite.toggle()
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
