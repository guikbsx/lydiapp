import UIKit

class UserTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UserTableViewCell"
    
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with user: UserEntity) {
        let ageString = user.age > 0 ? "(\(user.age))" : ""
        titleLabel.text = "\(user.title ?? "") \(user.firstName ?? "") \(user.lastName ?? "") \(ageString)"
        var details = [String]()
        details.append("Email : \(user.email ?? "inconnu")")
        details.append("Tél : \(user.phone ?? "inconnu")")
        details.append("Sexe : \(user.gender ?? "inconnu")")
        if let birthDate = user.birthDate {
            let df = DateFormatter()
            df.dateStyle = .short
            details.append("Né(e) le : \(df.string(from: birthDate))")
        }
        detailLabel.text = details.joined(separator: "  •  ")
    }
}
