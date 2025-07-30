import UIKit


/// Affiche les détails d’un utilisateur sous forme de liste clé / valeur, comme LabeledContent SwiftUI.
class UserDetailViewController: UIViewController {
    let user: UserEntity
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // Liste des champs à afficher : (label, closure pour obtenir la valeur)
    private lazy var fields: [UserDetailField] = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return [
            UserDetailField(label: "Civilité", value: user.title ?? "-"),
            UserDetailField(label: "Prénom", value: user.firstName ?? "-"),
            UserDetailField(label: "Nom", value: user.lastName ?? "-"),
            UserDetailField(label: "Email", value: user.email ?? "-"),
            UserDetailField(label: "Téléphone", value: user.phone ?? "-"),
            UserDetailField(label: "Genre", value: user.gender ?? "-"),
            UserDetailField(label: "Âge", value: user.age > 0 ? String(user.age) : "-"),
            UserDetailField(label: "Date de naissance", value: user.birthDate != nil ? dateFormatter.string(from: user.birthDate!) : "-")
        ]
    }()

    // MARK: - Initialisation
    init(user: UserEntity) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, utilisez init(user:) à la place")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Détail utilisateur"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fields.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "DetailCell")
        let field = fields[indexPath.row]
        cell.textLabel?.text = field.label
        cell.detailTextLabel?.text = field.value
        cell.selectionStyle = .none
        return cell
    }
}

extension UserDetailViewController {
    struct UserDetailField {
        let label: String
        let value: String
    }
}

#if canImport(SwiftUI)
import SwiftUI

private struct UserDetailViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        // Crée un UserEntity factice en mémoire pour la preview
        let context = CoreDataManager.shared.viewContext
        let sample = UserEntity.makeSample(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            firstName: "Alice",
            lastName: "Durand",
            email: "alice.durand@example.com",
            phone: "+33123456789",
            title: "Mme",
            gender: "F",
            age: 29,
            birthDate: Date(timeIntervalSince1970: 529344000),
            registredDate: Date(),
            in: context
        )
        let vc = UserDetailViewController(user: sample)
        return UINavigationController(rootViewController: vc)
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview("UserDetailViewController") {
    UserDetailViewControllerPreview()
        .ignoresSafeArea()
}
#endif

