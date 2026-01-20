import Foundation
import CoreData
@testable import SlonikLendar
class CoreDataInMemoryPersistantContainer {
    static func makeContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "SlonikLendar")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        return container
    }
}
