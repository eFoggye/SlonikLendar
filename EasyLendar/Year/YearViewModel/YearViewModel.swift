import Foundation
protocol YearViewModelProtocol {
    func hasEvents(for date: Date) -> Bool
}
final class YearViewModel: YearViewModelProtocol {
    private let coreDataManager: CoreDataManagerProtocol
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    func hasEvents(for date: Date) -> Bool {
        return coreDataManager.fetchEvent(for: date).count != 0
    }
}
