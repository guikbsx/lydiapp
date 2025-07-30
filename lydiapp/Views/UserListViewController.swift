import Foundation
import UIKit

class UserListViewController: UIViewController {
    let loadingLabel = UILabel()

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let viewModel: UserViewModel

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
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Utilisateurs"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    @objc
    private func refreshUserList(_ sender: UIRefreshControl) {
        Task { await viewModel.reloadUsers() }
    }
}

// MARK: - UITableViewDataSource

extension UserListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = viewModel.users[indexPath.row]
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

// TO DELETE
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
