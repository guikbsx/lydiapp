import Foundation

enum CoreDataError: Error, LocalizedError, Identifiable {

    /// Erreur lors du chargement Persistent Stores.
    case failedToLoadPersistentStores(Error)
    /// Erreur lors de la sauvegarde Core Data.
    case saveContext(Error)
    
    var id: String {
        switch self {
        case .failedToLoadPersistentStores(let error):
            return "failedToLoadPersistentStores_\(error.localizedDescription)"
        case .saveContext(let error):
            return "saveContext_\(error.localizedDescription)"
        }
    }

    var errorDescription: String? {
        switch self {
        case .failedToLoadPersistentStores(let error):
            return "Failed to load Persistent Stores: \(error.localizedDescription)"
        case .saveContext(let error):
            return "Failed to save context: \(error.localizedDescription)"
        }
    }
}
