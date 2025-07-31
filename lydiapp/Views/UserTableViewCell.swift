import UIKit

class UserTableViewCell: UITableViewCell {
    static let reuseIdentifier = "UserTableViewCell"
    
    let avatar = AsyncImageView(frame: .zero)
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))

        
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
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill


        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .preferredFont(forTextStyle: .subheadline)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0
        contentView.addSubview(detailLabel)
        
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = .tertiaryLabel
        chevron.contentMode = .scaleAspectFit
        contentView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            avatar.widthAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -8),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -8),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            chevron.widthAnchor.constraint(equalToConstant: 16),
            chevron.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.cornerRadius = avatar.bounds.height / 2
        avatar.clipsToBounds = true
    }
    
    func configure(with user: UserEntity, highlightFirstName: Bool) {
        let first = user.firstName ?? ""
        let last = user.lastName ?? ""
        
        let boldFont = UIFont.preferredFont(forTextStyle: .headline)
        let regularFont = UIFont.preferredFont(forTextStyle: .body)

        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(string: first, attributes: [.font: highlightFirstName ? boldFont : regularFont]))
        attributed.append(NSAttributedString(string: " "))
        attributed.append(NSAttributedString(string: last, attributes: [.font: highlightFirstName ? regularFont : boldFont]))

        titleLabel.attributedText = attributed

        if let email = user.email {
            detailLabel.text = email
        }
        if let urlString = user.thumbnail, let url = URL(string: urlString) {
            avatar.load(from: url)
        }
    }
}

