protocol CoreDataManagerProtocol {
    func create(event: Event)
    func fetchEvents() -> [Event]
    func fetchEvent(for date: Date) -> [Event]
    func update(event: Event)
    func delete(event: Event)
}
import Foundation
import CoreData

public final class CoreDataManager: CoreDataManagerProtocol {
    
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SlonikLendar")
        container.loadPersistentStores { description, error in
            if let error = error as? NSError {
                fatalError("Unresolved error: \(error.userInfo)")
            }
        }
        return container
    }()
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error.userInfo)")
            }
        }
    }
    //MARK: - CRUD
    func create(event: Event) {
        let coreDataEvent = CoreDataEvent(context: context)
        coreDataEvent.id = event.id
        coreDataEvent.name = event.name
        coreDataEvent.startDate = event.startDate
        coreDataEvent.endDate = event.endDate
        coreDataEvent.isAllDay = event.isAllDay
        coreDataEvent.notifications = event.notifications
        
        saveContext()
    }
    
    func fetchEvents() -> [Event] {
        let fetchRequest: NSFetchRequest<CoreDataEvent> = CoreDataEvent.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result.map { coreDataEvent in
                let id = coreDataEvent.id
                return Event(
                    id: id,
                    name: coreDataEvent.name,
                    startDate: coreDataEvent.startDate,
                    endDate: coreDataEvent.endDate,
                    isAllDay: coreDataEvent.isAllDay,
                    notifications: coreDataEvent.notifications
                )
            }
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error.userInfo)")
        }
    }
    
    func fetchEvent(for date: Date) -> [Event] {
        let fetchRequest: NSFetchRequest<CoreDataEvent> = CoreDataEvent.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)
        let predicate1 = NSPredicate(format: "startDate < %@", endOfDay! as any CVarArg)
        let predicate2 = NSPredicate(format: "endDate > %@", startOfDay as CVarArg)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        do {
            let result = try context.fetch(fetchRequest)
            return result.map { coreDataEvent in
                Event(id: coreDataEvent.id, name: coreDataEvent.name, startDate: coreDataEvent.startDate, endDate: coreDataEvent.endDate, isAllDay: coreDataEvent.isAllDay, notifications: coreDataEvent.notifications)
            }
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error.userInfo)")
        }
    }
    
    func update(event: Event) {
        let fetchRequest: NSFetchRequest<CoreDataEvent> = CoreDataEvent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", event.id as CVarArg)
        do {
            guard let result = try context.fetch(fetchRequest).first else { return }
            result.startDate = event.startDate
            result.endDate = event.endDate
            result.isAllDay = event.isAllDay
            result.name = event.name
            result.notifications = event.notifications
            
            saveContext()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error.userInfo)")
        }
    }
    
    func delete(event: Event) {
        let fetchRequest: NSFetchRequest<CoreDataEvent> = CoreDataEvent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", event.id as CVarArg)
        guard let result = try? context.fetch(fetchRequest).first else { return }
        context.delete(result as NSManagedObject)
        saveContext()
    }
    
    
}
