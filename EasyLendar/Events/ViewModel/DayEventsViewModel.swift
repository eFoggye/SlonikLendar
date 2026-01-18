import Foundation

protocol DayEventsViewModelProtocol {
    var events: [Event] { get }
    var onUpdate: (() -> Void)? { get set }
    func load()
    func makeTitle() -> String
    func yPosition(date: Date) -> CGFloat
    func height(event: Event) -> CGFloat
}

final class DayEventsViewModel: DayEventsViewModelProtocol {
    let coreDataManager: CoreDataManagerProtocol
    
    private var day: DayModel = DayModel(date: Date(), day: 0, isToday: false, isCurrentMonth: false, isItInThismonth: false)
    private(set) var events: [Event] = []
    
    var onUpdate: (() -> Void)?
    
    init(day: DayModel, coreDataManager: CoreDataManagerProtocol = CoreDataManager()) {
        self.day = day
        self.coreDataManager = coreDataManager
    }
    convenience init() {
        self.init(day: DayModel(date: Date(), day: 0, isToday: false, isCurrentMonth: false, isItInThismonth: false))
    }
    
    func load() {
        self.events = coreDataManager.fetchEvent(for: day.date)
        onUpdate?()
    }
    
    func makeTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let date = dateFormatter.string(from: day.date)
        return date
    }
    
    func yPosition(date: Date) -> CGFloat {
        let hourComponent = Calendar.current.component(.hour, from: date)
        let minuteComponent = Calendar.current.component(.minute, from: date)
        return CGFloat(hourComponent*60+minuteComponent+60)
    }
    
    func height(event: Event) -> CGFloat {
        let startY = yPosition(date: event.startDate)
        let endY = yPosition(date: event.endDate)
        let height = endY - startY
        return height
    }
}
