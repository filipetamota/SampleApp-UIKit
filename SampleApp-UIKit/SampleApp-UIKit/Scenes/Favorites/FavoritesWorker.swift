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
        case .add: return NSLocalizedString("error_adding_favorite", comment: "")
        case .remove: return NSLocalizedString("error_removing_favorite", comment: "")
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
            return NSLocalizedString("error_adding_favorite", comment: "")
        case .removeFavoriteError:
            return NSLocalizedString("error_removing_favorite", comment: "")
        case .modelError:
            return NSLocalizedString("error_model", comment: "")
        case .unknownError:
            return NSLocalizedString("error_unknown", comment: "")
        }
    }
}

final class FavoritesWorker {
    var context: NSManagedObjectContext?
    
    func getAllFavorites() throws -> [FavoriteItem] {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        return try context!.fetch(fetchRequest)
    }
    
    func getFavorite(photoId: String) throws -> FavoriteItem? {
        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "favId LIKE %@", photoId)
        
        let object = try context!.fetch(fetchRequest).first
        return object
    }
    
    func isFavorite(photoId: String) -> Bool {
        do {
            return try getFavorite(photoId: photoId) != nil
        } catch {
            return false
        }
    }
    
    func saveFavorite(favorite: DetailResult, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {
        guard let favoriteEntity = NSEntityDescription.entity(forEntityName: "FavoriteItem", in: context!) else {
            completion(.failure(ModelError.modelError))
            return
        }
        let favoriteObject = NSManagedObject(entity: favoriteEntity, insertInto: context!)
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
            try context!.save()
            completion(.success(.add))
        } catch {
            completion(.failure(ModelError.addFavoriteError))
            return
        }
        
    }
    
    func deleteFavorite(photoId: String, completion: @escaping (Result<FavoriteOperation, ModelError>) -> Void) {

        let fetchRequest: NSFetchRequest<FavoriteItem> = FavoriteItem.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "favId LIKE %@", photoId)

        do {
            let result = try context!.fetch(fetchRequest)
            for object in result {
                context!.delete(object)
            }
            try context!.save()
            completion(.success(.remove))
        } catch {
            completion(.failure(ModelError.removeFavoriteError))
        }
    }
}
