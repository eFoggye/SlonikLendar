import Foundation
final class CalendarHelper {
    private let calendar: Calendar
    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }
    func russianNameOfMonth(month: MonthModel) -> String {
        let date = month.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL"
        return formatter.string(from: date).capitalized
    }
    func startOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        if let start = calendar.date(from: components) {
            return start
        }
        return date
    }
    func numberOfDay (in month: MonthModel) -> Int {
        if let daysCount = calendar.range(of: .day, in: .month, for: month.date) {
            return daysCount.count
        }
        return 0
    }
    func makeDays (for month: MonthModel) -> [DayModel] {
        let startOfMonth = startOfMonth(for: month.date)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let emptyDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        guard let startDate = calendar.date(byAdding: .day, value: -emptyDays, to: startOfMonth) else { return [DayModel]() }
        
        var days = [DayModel]()
        
        for day in 0..<42 {
            guard let date = calendar.date(byAdding: .day, value: day, to: startDate) else { continue }
            let day = calendar.component(.day, from: date)
            let isToday = calendar.isDateInToday(date)
            let isCurrentMonth = calendar.isDate(date, equalTo: Date.now, toGranularity: .month)
            let isItInThisMonth = calendar.isDate(date, equalTo: startOfMonth, toGranularity: .month)
            days.append(DayModel(date: date,
                                 day: day,
                                 isToday: isToday,
                                 isCurrentMonth: isCurrentMonth,
                                 isItInThismonth: isItInThisMonth))
        }
        return days
    }
    func makeMonths (for date: Date) -> [MonthModel] {
        var months = [MonthModel]()
        guard let startOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: date))) else { return [] }
        for month in 0..<12 {
            if let monthDate = calendar.date(byAdding: .month, value: month, to: startOfYear) {
                let month = self.makeMonth(for: monthDate)
                months.append(month)
            }
        }
        return months
    }
    private func makeMonth (for date: Date) -> MonthModel {
        let month = MonthModel(date: date, days: [])
        let days = makeDays(for: month)
        return MonthModel(date: date, days: days)
    }
}
