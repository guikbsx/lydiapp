import Foundation
import CoreData

// MARK: - UserService

struct UserService {

    /**
     Récupère une page d'utilisateurs aléatoires.
     - Parameters:
       - results: Nombre d'utilisateurs par page
       - page: Numéro de la page (à partir de 1)
     - Throws: RandomUserServiceError si l'appel échoue ou si la réponse est invalide
     - Returns: `[RandomUser]`
     */
    private func fetchUsers(results: Int = 10, page: Int = 1) async throws -> [User] {
        let urlString = "https://randomuser.me/api/?results=\(results)&page=\(page)"
        guard let url = URL(string: urlString) else { throw UserServiceError.badURL }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                throw UserServiceError.badHTTPStatus(code: code)
            }
            
            do {
                let decoded = try JSONDecoder().decode(RandomUserResponse.self, from: data)
                return decoded.results
            } catch {
                throw UserServiceError.decoding(error)
            }
        } catch let error as UserServiceError {
            throw error
        } catch {
            throw UserServiceError.unknown(error)
        }
    }
    
    /**
     Récupère des utilisateurs aléatoires et les sauvegarde dans Core Data.
     - Parameters:
       - results: Nombre d'utilisateurs par page
       - page: Numéro de la page (à partir de 1)
     - Throws: RandomUserServiceError ou CoreDataError en cas d'échec
     - Returns: `[UserEntity]`
     */
    func fetchAndSaveUsers(results: Int = 10, page: Int = 1) async throws -> [UserEntity] {
        let users = try await fetchUsers(results: results, page: page)
        let context = CoreDataManager.shared.viewContext
        var savedEntities: [UserEntity] = []
        for user in users {
            if let existing = UserEntity.fetch(byUUID: user.login.uuid, in: context) {
                existing.update(with: user)
                savedEntities.append(existing)
            } else {
                let entity = UserEntity(from: user, context: context)
                savedEntities.append(entity)
            }
        }
        try CoreDataManager.shared.saveContext()
        return savedEntities
    }
}
