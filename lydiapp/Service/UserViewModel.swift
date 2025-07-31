import Foundation
import Observation
import CoreData

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

    /// The list of users, initially loaded from local storage.
    private(set) var users: [UserEntity] = {
        let context = CoreDataManager.shared.viewContext
        let request = UserEntity.fetchRequest()
        request.returnsObjectsAsFaults = false
        guard let users = try? context.fetch(request) else { return [] }
        return users
    }()
    
    var service: UserService = .init()
    var sortOption: SortOption = .lastName {
        didSet {
            sortUsers(options: sortOption)
        }
    }
    
    var usersTask: Task<Void, Never>? = nil {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private var currentPage: Int = 1
    private var isLoadingMore: Bool = false
    
    var error: ErrorState? = nil
    
    /// Charge des utilisateurs aléatoires si aucune donnée n'est présente en base et met à jour le tableau.
    func loadUsers() {
        guard users.isEmpty else {
            sortUsers(options: sortOption)
            return
        }
        
        usersTask = Task {
            error = nil
            do {
                let fetched = try await service.fetchAndSaveUsers(page: 1)
                self.users = fetched
                self.currentPage = 1
                self.isLoadingMore = false
            } catch {
                handleError(error)
                self.isLoadingMore = false
            }
        }
    }
    
    /// Charge la page suivante d’utilisateurs et ajoute au tableau existant.
    /// L'appel est immédiat et la tâche de chargement est gérée en interne.
    func loadMoreUsers() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        
        let nextPage = currentPage + 1
        usersTask = Task {
            error = nil
            do {
                let fetched = try await service.fetchAndSaveUsers(page: nextPage)
                self.users.append(contentsOf: fetched)
                self.currentPage = nextPage
                self.isLoadingMore = false
            } catch {
                handleError(error)
                self.isLoadingMore = false
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
                self.isLoadingMore = false
                print("--- finish reload users")
            } catch {
                handleError(error)
                self.isLoadingMore = false
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
    
    private func sortUsers(options: SortOption) {
        switch options {
        case .firstName:
            users.sort { ($0.firstName ?? "") < ($1.firstName ?? "") }
        case .lastName:
            users.sort { ($0.lastName ?? "") < ($1.lastName ?? "") }
        }

    }
}

