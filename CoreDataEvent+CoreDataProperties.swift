//
//  CoreDataEvent+CoreDataProperties.swift
//  SlonikLendarr
//
//  Created by Egor on 16.01.2026.
//
//

public import Foundation
public import CoreData


public typealias CoreDataEventCoreDataPropertiesSet = NSSet

extension CoreDataEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataEvent> {
        return NSFetchRequest<CoreDataEvent>(entityName: "CoreDataEvent")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var startDate: Date
    @NSManaged public var endDate: Date
    @NSManaged public var isAllDay: Bool
    @NSManaged public var notifications: Bool

}

extension CoreDataEvent : Identifiable {

}
