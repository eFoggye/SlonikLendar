import Foundation
class DayEventsViewModel {
    let coreDataManager = CoreDataManager()
    private var day: DayModel = DayModel(date: Date(), day: 0, isToday: false, isCurrentMonth: false, isItInThismonth: false)
    private(set) var events: [Event] = []
    var onUpdate: (() -> Void)?
    init(day: DayModel) {
        self.day = day
    }
    func load() {
        self.events = coreDataManager.fetchEvent(for: day.date)
        onUpdate?()
    }
    public func makeTitle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let date = dateFormatter.string(from: day.date)
        return date
    }
    public func yPosition(date: Date) -> Int {
        let hourComponent = Calendar.current.component(.hour, from: date)
        let minuteComponent = Calendar.current.component(.minute, from: date)
        return hourComponent*60+minuteComponent
    }
    func height(event: Event) -> Int {
        let startY = yPosition(date: event.startDate)
        let endY = yPosition(date: event.endDate)
        let height = endY - startY
        return height
    }
}
