import Foundation
protocol APIManagerProtocol {
    func getHolidays()
}
final class APIManager: APIManagerProtocol {
    private let urlString = "https://calendarific.com/api/v2/holidays?&api_key=5gk1X8oZR0u1NbMMQiQWydchRHLsxtmB&country=RU&year=2026&month=1&day=7"
    func getHolidays() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) {data,response,_ in
                print(String(data: data!, encoding: .utf8))
            }
        }
    }
}
