import Foundation
struct State {
    let years: [YearModel]
}

protocol PageViewModelProtocol {
    var onUpdate: ((State) -> Void)? { get set }
    var onAddEventRequest: (() -> ())? { get set }
    func makeYears(lowerLimit: Int, upperLimit: Int)
    func addButtonTaped()
}

final class PageViewModel: PageViewModelProtocol {
    
    private let calendar: Calendar
    private let helper: CalendarHelperProtocol
    
    init(calendar: Calendar = .current, helper: CalendarHelperProtocol = CalendarHelper()) {
        self.calendar = calendar
        self.helper = helper
    }
    
    var onUpdate: ((State) -> Void)?
    
    var onAddEventRequest: (() -> ())?
    
    func makeYears(lowerLimit: Int, upperLimit: Int) {
        var years = [YearModel]()
        for year in lowerLimit...upperLimit {
            guard let yearDate = calendar.date(from: DateComponents(year: year)) else { return }
            let months = helper.makeMonths(for: yearDate)
            years.append(YearModel(year: year, months: months))
        }
        onUpdate?(State(years: years))
    }
    
    func addButtonTaped() {
        onAddEventRequest?()
    }
}
