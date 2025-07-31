import Foundation
import UIKit

// MARK: - UserListViewController

class UserListViewController: UIViewController {

    let loadingLabel = UILabel()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let viewModel: UserViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredUsers: [UserEntity] = []
    private var isSearchActive: Bool { return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true) }

    init(viewModel: UserViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(viewModel:) instead")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !viewModel.users.isEmpty {
            loadingLabel.removeFromSuperview()
        }
        handleError()
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    private func handleError() {
        if let error = viewModel.error, presentedViewController == nil {
            let alert = UIAlertController(
                title: "Erreur",
                message: error.errorDescription ?? "Une erreur inconnue est survenue.",
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default
                ) { [weak self] _ in
                self?.viewModel.error = nil
                })
            present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            primaryAction: nil,
            menu: makeSortMenu()
        )

        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Contact, mail, téléphone..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setupTableView()
        viewModel.loadUsers()
    }

    private func setupTableView() {
        // Cell
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            UserTableViewCell.self,
            forCellReuseIdentifier: UserTableViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Loading Label
        if viewModel.users.isEmpty {
            loadingLabel.text = "Chargement en cours..."
            loadingLabel.font = .preferredFont(forTextStyle: .headline)
            loadingLabel.textAlignment = .center
            loadingLabel.textColor = .secondaryLabel
            loadingLabel.numberOfLines = 0
            loadingLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loadingLabel)
            NSLayoutConstraint.activate([
                loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                loadingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
                loadingLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor)
            ])
        }

        // Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshUserList(_:)), for: .valueChanged)
        
        // Footer spinner
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        tableView.tableFooterView = spinner
    }
    
    private func makeSortMenu() -> UIMenu {
        let actions = SortOption.allCases.map { option in
            UIAction(title: option.rawValue, state: option == viewModel.sortOption ? .on : .off) { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.sortOption = option
                self.navigationItem.rightBarButtonItem?.menu = self.makeSortMenu()
            }
        }
        return UIMenu(title: "Trier par", children: actions)
    }
    
    @objc
    private func refreshUserList(_ sender: UIRefreshControl) {
        Task { await viewModel.reloadUsers() }
    }
}

// MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? filteredUsers.count : viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = isSearchActive ? filteredUsers[indexPath.section] : viewModel.users[indexPath.section]
        cell.configure(with: user, highlightFirstName: viewModel.sortOption == .firstName)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = (isSearchActive ? filteredUsers : viewModel.users)[indexPath.section]
        let detailVC = UserDetailViewController(user: selectedUser)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight * 1.2 {
            viewModel.loadMoreUsers()
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

private struct UserListViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewModel = UserViewModel()
//        viewModel.sample()
        let userListVC = UserListViewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: userListVC)
        return navigation
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview("UserListViewController") {
    UserListViewControllerPreview()
        .ignoresSafeArea()
}
#endif

private extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension UserListViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SortOption.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SortOption.allCases[safe: row]?.rawValue
    }
}

// MARK: - UISearchResultsUpdating

extension UserListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(), !text.isEmpty else {
            filteredUsers = []
            tableView.reloadData()
            return
        }
        filteredUsers = viewModel.users.filter { user in
            (user.firstName?.lowercased().contains(text) ?? false)
            || (user.lastName?.lowercased().contains(text) ?? false)
            || (user.email?.lowercased().contains(text) ?? false)
            || (user.phone?.lowercased().contains(text) ?? false)
        }
        tableView.reloadData()
    }
}
