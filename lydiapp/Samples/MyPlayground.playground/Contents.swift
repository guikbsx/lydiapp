import Foundation

let service = UserService()
Task {
    do {
        let users = try await service.fetchUsers()
        for user in users {
            print(user.description)
        }
    } catch let error as UserServiceError {
        print("Erreur : \(error.errorDescription ?? error.localizedDescription)")
    } catch {
        print("Erreur inattendue : \(error.localizedDescription)")
    }
}
