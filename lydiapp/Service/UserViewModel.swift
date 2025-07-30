import Foundation
import Observation

@Observable
final class UserViewModel {
    
    enum ErrorState: LocalizedError, Identifiable {
        case user(UserServiceError)
        case coreData(CoreDataError)
        case unknown(Error)
        
        var id: String {
            switch self {
            case .user:
                return "user-\(errorDescription ?? "")"
            case .coreData:
                return "coreData-\(errorDescription ?? "")"
            case .unknown:
                return "unknown-\(errorDescription ?? "")"
            }
        }
        
        var errorDescription: String? {
            switch self {
            case .user(let error): return error.errorDescription
            case .coreData(let error): return error.errorDescription
            case .unknown(let error): return error.localizedDescription
            }
        }
        
    }

    private(set) var users: [UserEntity] = []
    
    // Le service utilisé pour charger les utilisateurs (injection possible)
    var service: UserService = .init()
    
    private var currentPage: Int = 1
    
    var error: ErrorState? = nil
    
    /// Charge les utilisateurs aléatoires et met à jour le tableau observable
    func loadUsers() async {
        error = nil
        do {
            let fetched = try await service.fetchAndSaveUsers(page: 1)
            self.users = fetched
        } catch {
            handleError(error)
        }
    }
    
    /// Charge la page suivante d’utilisateurs et ajoute au tableau existant
    func loadMoreUsers() async {
        error = nil
        let nextPage = currentPage + 1
        do {
            let fetched = try await service.fetchAndSaveUsers(page: nextPage)
            self.users.append(contentsOf: fetched)
            self.currentPage = nextPage
        } catch {
            handleError(error)
        }
    }
    
    /// Recharge la première page d’utilisateurs
    func reloadUsers() async {
        error = nil
        do {
            let fetched = try await service.fetchAndSaveUsers(page: 1)
            self.users = fetched
            self.currentPage = 1
        } catch {
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        switch error {
        case let error as UserServiceError:
            self.error = .user(error)
        case let error as CoreDataError:
            self.error = .coreData(error)
        default:
            self.error = .unknown(error)
        }
    }
}
