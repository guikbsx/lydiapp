import Foundation
import UIKit

class UserListViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
//    private let refreshControl = UIRefreshControl()
    let viewModel: UserViewModel

    init(viewModel: UserViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(viewModel:) instead")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
        
        // Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshUserList(_:)), for: .valueChanged)
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
        
        return UINavigationController(rootViewController: userListVC)
    }
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}

#Preview("UserListViewController") {
    UserListViewControllerPreview()
        .ignoresSafeArea()
}
#endif


