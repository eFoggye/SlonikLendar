public import Foundation
public import CoreData


public typealias CoreDataEventCoreDataPropertiesSet = NSSet

extension CoreDataEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataEvent> {
        return NSFetchRequest<CoreDataEvent>(entityName: "CoreDataEvent")
    }

    @NSManaged public var endDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var isAllDay: Bool
    @NSManaged public var name: String
    @NSManaged public var notifications: Bool
    @NSManaged public var startDate: Date

}

extension CoreDataEvent : Identifiable {

}
