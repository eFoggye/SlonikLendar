import Foundation

struct DayModel: Hashable {
    let date: Date
    let day: Int
    let isToday: Bool
    let isCurrentMonth: Bool
    let isItInThismonth: Bool
}
