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
    
    var service: UserService = .init()
    
    var usersTask: Task<Void, Never>? = nil {
        didSet { oldValue?.cancel() }
    }
    
    private var currentPage: Int = 1
    
    var error: ErrorState? = nil
    
    /// Charge les utilisateurs aléatoires et met à jour le tableau.
    func loadUsers() {
        usersTask = Task {
            error = nil
            do {
                let fetched = try await service.fetchAndSaveUsers(page: 1)
                self.users = fetched
                self.currentPage = 1
            } catch {
                handleError(error)
            }
        }
    }
    
    /// Charge la page suivante d’utilisateurs et ajoute au tableau existant.
    /// L'appel est immédiat et la tâche de chargement est gérée en interne.
    func loadMoreUsers() {
        let nextPage = currentPage + 1
        usersTask = Task {
            error = nil
            do {
                let fetched = try await service.fetchAndSaveUsers(page: nextPage)
                self.users.append(contentsOf: fetched)
                self.currentPage = nextPage
            } catch {
                handleError(error)
            }
        }
    }
    
    /// Recharge la première page d’utilisateurs.
    /// L'appel est immédiat et la tâche de chargement est gérée en interne.
    func reloadUsers() async {
        usersTask = Task {
            error = nil
            do {
                let fetched = try await service.fetchAndSaveUsers(page: 1)
                self.users = fetched
                self.currentPage = 1
                print("--- finish reload users")
            } catch {
                handleError(error)
            }
            usersTask = nil
        }
    }
    
    /// Annule la tâche en cours de chargement des utilisateurs si elle existe.
    func cancelUsersTask() {
        usersTask?.cancel()
        usersTask = nil
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
    
    // Pour tester
    func sample() {
        users = UserEntity.samples(in: CoreDataManager.shared.viewContext)
    }
    
    deinit {
        cancelUsersTask()
    }
}
