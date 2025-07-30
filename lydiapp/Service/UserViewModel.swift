import Foundation
import Observation

@Observable
final class UserViewModel {

    private(set) var users: [UserEntity] = []
    
    // Le service utilisé pour charger les utilisateurs (injection possible)
    var service: UserService = .init()
    
    /// Charge les utilisateurs aléatoires asynchrone et met à jour le tableau observable
    func loadUsers(results: Int = 10, page: Int = 1) async throws {
        do {
            let fetched = try await service.fetchAndSaveUsers(results: results, page: page)
            self.users = fetched
        } catch {
            // TODO: Catch les différents types d'erreurs .Error ici.
            throw error
        }
    }
}
