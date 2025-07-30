struct User: Decodable {
    let name: Name
    let email: String
    let phone: String
    let login: Login
    let dob: DOB
    let gender: String
    let picture: Picture?

    struct Name: Decodable {
        let title: String
        let first: String
        let last: String
    }
    struct Login: Decodable {
        let uuid: String
    }
    struct DOB: Decodable {
        let date: String  // ISO8601 string
        let age: Int
    }
    struct Picture: Decodable {
        let large: String?
        let medium: String?
        let thumbnail: String?
    }
    
    var description: String {
        "\(name.title) \(name.first) \(name.last), \(gender), \(dob.age) ans, email: \(email), tél: \(phone)"
    }
    
    var completeDescription: String {
        var lines: [String] = []
        lines.append("")
        lines.append("Nom complet : \(name.title) \(name.first) \(name.last)")
        lines.append("Sexe : \(gender)")
        lines.append("Âge : \(dob.age) ans")
        lines.append("Date de naissance : \(dob.date)")
        lines.append("Email : \(email)")
        lines.append("Téléphone : \(phone)")
        lines.append("Identifiant : \(login.uuid)")
        if let photo = picture?.large {
            lines.append("Photo : \(photo)")
        }
        return lines.joined(separator: "\n")
    }
}

struct RandomUserResponse: Decodable {
    let results: [User]
}
