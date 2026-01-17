import Foundation
class MakeEventViewModel {
    private let coreDataManager: CoreDataManager
    init(coreDataManager: CoreDataManagerProtocol = CoreDataManager()) {
        self.coreDataManager = coreDataManager as! CoreDataManager
    }
    func save(event: Event) {
        coreDataManager.create(event: event)
    }
}
