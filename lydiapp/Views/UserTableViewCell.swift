import UIKit

class UserTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UserTableViewCell"
    
    let avatar = AsyncImageView(frame: .zero)
    let titleLabel = UILabel()
    let detailLabel = UILabel()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        avatar.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(avatar)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with user: UserEntity) {
        titleLabel.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        if let email = user.email {
            detailLabel.text = email
        }
        if let urlString = user.thumbnail, let url = URL(string: urlString) {
            avatar.load(from: url)
        }
    }
}
