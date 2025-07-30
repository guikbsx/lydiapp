import UIKit

class AsyncImageView: UIImageView {
    
    private var currentURL: URL?
    private var currentTask: Task<Void, Never>?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        backgroundColor = UIColor.systemGray5
        contentMode = .scaleAspectFill
        clipsToBounds = true
        layer.cornerRadius = 8
    }

    /// Charge l'image depuis une URL de manière asynchrone
    /// - Parameter url: L'URL distante
    /// - Parameter errorImage: Une image à afficher en cas d'erreur
    func load(from url: URL) {
        // Annule toute tâche précédente
        currentTask?.cancel()
        currentURL = url
        image = nil

        currentTask = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled, currentURL == url else { return }
                
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                } else {
                    self.image = Self.defaultErrorImage()
                }
            } catch {
                guard !Task.isCancelled else { return }
                self.image = Self.defaultErrorImage()
            }
        }
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        currentTask?.cancel()
//        image = nil
//        backgroundColor = .systemGray5
//    }

    private static func defaultErrorImage() -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        return UIImage(systemName: "xmark.octagon.fill", withConfiguration: config)?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    }
}
