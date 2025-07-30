import Foundation

enum CoreDataError: Error {
    /// Erreur lors du chargement Persistent Stores.
    case failedToLoadPersistentStores(Error)
    /// Erreur lors de la sauvegarde Core Data.
    case saveContext(Error)
}
