import Foundation

class ManagerAPI {
    static var shared: ManagerAPI = .init()
    private init () {}
    func receiveParse(completion: @escaping () -> Void) {
        let url: URL = URL(string: "https://www.mocky.io/v2/59c791ed1100005300c39b93")!
        let request: URLRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                if let error = error {
                    print("Error \(error) occurred")
                }
                return
            }
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(Customer_Cart.Details.self, from: data) {
                Customer_Cart.cart = decodedData
            }
            completion()
        }.resume()
    }
}
