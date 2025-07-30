import Foundation
import CoreData



// MARK: - CoreDataManager

/// Fournit un accès au conteneur persistant et au contexte principal.
class CoreDataManager {
    
    // MARK: Singleton
    
    /// Instance partagée du gestionnaire Core Data (singleton).
    static let shared = CoreDataManager()

    // MARK: Variables
    
    /// Conteneur persistant Core Data pour le modèle lydiapp.
    let persistentContainer: NSPersistentContainer

    /// Dernière erreur de loading du store, si existante
    private(set) var lastLoadingError: CoreDataError?

    /// Contexte principal pour effectuer les opérations sur les objets Core Data.
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: Init
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "lydiapp")
        persistentContainer.loadPersistentStores { description, error in
            // Gestion plus aboutie de l'erreur ?
            guard let error else { return }
            self.lastLoadingError = CoreDataError.failedToLoadPersistentStores(error)
        }
    }

    // MARK: Functions
    
    /// Sauvegarde le contexte principal si des modifications ont été effectuées.
    /// - Throws: Une erreur de type CoreDataError en cas d'échec de la sauvegarde.
    func saveContext() throws {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw CoreDataError.saveContext(error)
            }
        }
    }
}

// MARK: - User

extension CoreDataManager {

    func createUser(id: UUID = UUID(), firstName: String, lastName: String, email: String, phone: String, title: String, gender: String, age: Int16, birthDate: Date, registredDate: Date) throws -> UserEntity {
        let user = UserEntity(context: viewContext)
        user.id = id
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.phone = phone
        user.title = title
        user.gender = gender
        user.age = age
        user.birthDate = birthDate
        user.registredDate = registredDate
        try saveContext()
        return user
    }
}
