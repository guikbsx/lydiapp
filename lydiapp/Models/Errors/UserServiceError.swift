import Foundation

/// Erreurs possibles lors de la récupération d'utilisateurs aléatoires
enum UserServiceError: Error, LocalizedError, Identifiable {

    /// L'URL fournie est invalide.
    case badURL
    /// Le serveur a retourné un code HTTP inattendu (hors 200...299).
    case badHTTPStatus(code: Int)
    /// Une erreur est survenue lors du décodage des données.
    case decoding(Error)
    /// Une erreur inconnue est survenue.
    case unknown(Error)
    
    var id: String {
        switch self {
        case .badURL:
            return "badURL"
        case .badHTTPStatus(let code):
            return "badHTTPStatus_\(code)"
        case .decoding(let error):
            return "decoding_\(error.localizedDescription)"
        case .unknown(let error):
            return "unknown_\(error.localizedDescription)"
        }
    }

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "L'URL fournie est invalide."
        case .badHTTPStatus(let code):
            return "Le serveur a retourné un code HTTP inattendu : \(code)."
        case .decoding(let error):
            return "Erreur lors du décodage des données : \(error.localizedDescription)"
        case .unknown(let error):
            return "Erreur inconnue : \(error.localizedDescription)"
        }
    }
}
