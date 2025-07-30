import UIKit
import CoreData

print("start")

let context = CoreDataManager.shared.viewContext

_ = UserEntity.samples(in: context)

do {
    try context.save()
    print("✅ Users saved to Core Data!")
} catch {
    print("❌ Failed to save users: \(error)")
}
