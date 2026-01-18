import Foundation

struct Event {
    let id: UUID
    let name: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let notifications: Bool
}
