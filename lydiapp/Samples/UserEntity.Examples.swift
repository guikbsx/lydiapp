import Foundation
import CoreData

// MARK: - User Entity samples
extension UserEntity {
    
    static func makeSample(id: UUID, firstName: String, lastName: String, email: String, phone: String, title: String, gender: String, age: Int16, birthDate: Date, registredDate: Date, in context: NSManagedObjectContext) -> UserEntity {
        let user = UserEntity(context: context)
        user.id = id
        user.firstName = firstName
        user.lastName = lastName
        user.email = email
        user.phone = phone
        user.title = title
        user.gender = gender
        user.age = age
        user.birthDate = birthDate
        user.registredDate = registredDate
        return user
    }
    
    static func samples(in context: NSManagedObjectContext) -> [UserEntity] {
        let dateFormatter = ISO8601DateFormatter()
        return [
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                firstName: "Alice",
                lastName: "Durand",
                email: "alice.durand@example.com",
                phone: "+33123456789",
                title: "Mme",
                gender: "F",
                age: 29,
                birthDate: dateFormatter.date(from: "1996-05-23T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2021-09-15T12:00:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                firstName: "Jean",
                lastName: "Martin",
                email: "jean.martin@example.com",
                phone: "+33612345678",
                title: "M.",
                gender: "M",
                age: 34,
                birthDate: dateFormatter.date(from: "1991-02-10T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2020-07-01T09:30:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                firstName: "Fatou",
                lastName: "Sow",
                email: "fatou.sow@example.com",
                phone: "+221782345678",
                title: "Mme",
                gender: "F",
                age: 41,
                birthDate: dateFormatter.date(from: "1984-11-12T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2018-03-22T15:45:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                firstName: "Hiroshi",
                lastName: "Yamamoto",
                email: "hiroshi.yamamoto@example.jp",
                phone: "+819012345678",
                title: "M.",
                gender: "M",
                age: 53,
                birthDate: dateFormatter.date(from: "1972-04-16T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2017-11-05T08:20:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                firstName: "Sophie",
                lastName: "Schmidt",
                email: "sophie.schmidt@example.de",
                phone: "+4915123456789",
                title: "Mme",
                gender: "F",
                age: 26,
                birthDate: dateFormatter.date(from: "1999-08-30T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2022-01-10T16:00:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                firstName: "Luca",
                lastName: "Rossi",
                email: "luca.rossi@example.it",
                phone: "+393331234567",
                title: "M.",
                gender: "M",
                age: 22,
                birthDate: dateFormatter.date(from: "2003-07-19T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2023-04-11T18:15:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                firstName: "Mia",
                lastName: "Nilsen",
                email: "mia.nilsen@example.no",
                phone: "+4798765432",
                title: "Ms.",
                gender: "F",
                age: 31,
                birthDate: dateFormatter.date(from: "1994-03-11T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2019-06-28T13:05:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                firstName: "Carlos",
                lastName: "García",
                email: "carlos.garcia@example.es",
                phone: "+34654321098",
                title: "Sr.",
                gender: "M",
                age: 38,
                birthDate: dateFormatter.date(from: "1987-12-02T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2021-10-20T11:40:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                firstName: "Layla",
                lastName: "Ali",
                email: "layla.ali@example.ae",
                phone: "+971501234567",
                title: "Ms.",
                gender: "F",
                age: 44,
                birthDate: dateFormatter.date(from: "1981-09-15T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2020-02-17T14:25:00Z")!,
                in: context
            ),
            makeSample(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!,
                firstName: "Noah",
                lastName: "Smith",
                email: "noah.smith@example.com",
                phone: "+14085551234",
                title: "Mr.",
                gender: "M",
                age: 27,
                birthDate: dateFormatter.date(from: "1998-10-05T00:00:00Z")!,
                registredDate: dateFormatter.date(from: "2024-01-12T10:10:00Z")!,
                in: context
            )
        ]
    }
}

extension UserEntity {
    /// Met à jour une entité existante avec les valeurs d’un RandomUser
    func update(with randomUser: User) {
        self.firstName = randomUser.name.first
        self.lastName = randomUser.name.last
        self.email = randomUser.email
        self.phone = randomUser.phone
        self.title = randomUser.name.title
        self.gender = randomUser.gender
        self.age = Int16(randomUser.dob.age)
        let dateFormatter = ISO8601DateFormatter()
        if let parsedDate = dateFormatter.date(from: randomUser.dob.date) {
            self.birthDate = parsedDate
        }
    }

    /// Recherche une UserEntity par son UUID dans le contexte donné
    static func fetch(byUUID uuid: String, in context: NSManagedObjectContext) -> UserEntity? {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid)
        fetchRequest.fetchLimit = 1
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
}
