//
//  FavoritesWorker.swift
//  SampleApp-UIKit
//
//  Created by Filipe Mota on 21/2/24.
//

import UIKit
import CoreData

enum FavoriteOperation {
    case add
    case remove
    
    func successAlertMessage() -> String {
        switch self {
        case .add: return NSLocalizedString("favorite_added", comment: "")
        case .remove: return NSLocalizedString("favorite_removed", comment: "")
        }
    }
    
    func errorAlertMessage() -> String {
        switch self {
        case .add: return NSLocalizedString("error_add_favorite", comment: "")
        case .remove: return NSLocalizedString("error_removed_favorite", comment: "")
        }
    }
}

enum ModelError: Error {
    case addFavoriteError
    case removeFavoriteError
    case modelError
    case unknownError
    
    func errorMessage() -> String {
        switch self {
        case .addFavoriteError:
            return NSLocalizedString("error_add_favorite", comment: "")
        case .removeFavoriteError:
            return NSLocalizedString("error_removed_favorite", comment: "")
        case .modelError:
            return NSLocalizedString("error_model", comment: "")
        case .unknownError:
            return NSLocalizedString("error_unknown", comment: "")
        }
    }
}

final class FavoritesWorker {
    
    func getAllFavorites() throws -> [FavoriteItem] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw ModelError.unknownError }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        return try managedContext.fetch(fetchRequest)
    }
    
    func getFavorite(photoId: String) throws -> [FavoriteItem] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw ModelError.unknownError }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favId LIKE %@", photoId)
        
        let objects = try managedContext.fetch(fetchRequest)
        assert(objects.count < 2, "Should be only one object with id \(photoId)")
        return objects
    }
    
    func isFavorite(photoId: String) -> Bool {
        do {
            return try getFavorite(photoId: photoId).count == 1
        } catch {
            return false
        }
    }
    
    func saveFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(ModelError.unknownError))
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let favoriteEntity = NSEntityDescription.entity(forEntityName: "FavoriteItem", in: managedContext) else {
            completion(.failure(ModelError.modelError))
            return
        }
        let favoriteObject = NSManagedObject(entity: favoriteEntity, insertInto: managedContext)
        favoriteObject.setValue(favorite.id, forKey: "favId")
        favoriteObject.setValue(favorite.width, forKey: "width")
        favoriteObject.setValue(favorite.height, forKey: "height")
        favoriteObject.setValue(favorite.alt_description, forKey: "alt_description")
        favoriteObject.setValue(favorite.description, forKey: "desc")
        favoriteObject.setValue(favorite.likes, forKey: "likes")
        favoriteObject.setValue(favorite.imgUrl, forKey: "imageUrl")
        favoriteObject.setValue(favorite.thumbUrl, forKey: "thumbUrl")
        favoriteObject.setValue(favorite.userName, forKey: "userName")
        favoriteObject.setValue(favorite.equipment, forKey: "equipment")
        favoriteObject.setValue(favorite.location, forKey: "location")
        
        do {
            try managedContext.save()
            completion(.success(.add))
        } catch {
            completion(.failure(ModelError.addFavoriteError))
            return
        }
        
    }
    
    func deleteFavorite(photoId: String, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(ModelError.unknownError))
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteItem")
        deleteFetch.predicate = NSPredicate(format: "favId LIKE %@", photoId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            completion(.success(.remove))
        } catch {
            completion(.failure(ModelError.removeFavoriteError))
        }
    }
}
