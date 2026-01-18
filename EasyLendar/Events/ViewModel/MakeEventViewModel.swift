import Foundation

protocol MakeEventViewModelProtocol {
    func startDateTime(startDate: Date, startTime: Date) -> Date
    func endDateTime(endDate: Date, endTime: Date) -> Date
    func save(event: Event)
    func delete(event: Event)
    func update(event: Event)
}

final class MakeEventViewModel: MakeEventViewModelProtocol {
    private let coreDataManager: CoreDataManager
    private let notificationManager: NotificationManagerProtocol? = NotificationManager.shared
    
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager()) {
        self.coreDataManager = coreDataManager as! CoreDataManager
    }
    
    func startDateTime(startDate: Date, startTime: Date) -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: startDate
        )
        
        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: startTime
        )
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        return calendar.date(from: components)!
    }
    
    func endDateTime(endDate: Date, endTime: Date) -> Date {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents(
            [.year, .month, .day],
            from: endDate
        )
        
        let timeComponents = calendar.dateComponents(
            [.hour, .minute],
            from: endTime
        )
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        
        return calendar.date(from: components)!
    }
    
    func save(event: Event) {
        if event.notifications {
            notificationManager?.addNotification(event: event)
        }
        coreDataManager.create(event: event)
    }
    func delete(event: Event) {
        coreDataManager.delete(event: event)
    }
    func update(event: Event) {
        notificationManager?.removeNotification(event: event)
        coreDataManager.update(event: event)
    }
}
