import UIKit

class Customer_Cart: UITableViewController {
    var cart: Details!
    struct Details: Decodable {
        var id: Int
        var cart_total: Int
        var order_items_information: [InfoOfEachItem]
    }
    
    struct InfoOfEachItem: Decodable {
        var product: ProductInfo
        var packaging_type: String
        var quantity: Double
        var sub_total: Int
        var substitutable: Bool
    }
    
    struct ProductInfo: Decodable {
        var name: String
        var unit_price: Int
        var case_price: Int
        var weight_price: Int
        var unit_photo_filename: String
        var weight_photo_filename: String
        var pack_photo_file: String
        
    }
    
    func receive(completion: @escaping () -> Void) {
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
            if let decodedData = try? decoder.decode(Details.self, from: data) {
                self.cart = decodedData
            }
            completion()
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "Customer Cart"
        receive { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cart = cart else {return 0}
        return cart.order_items_information.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Customer_Cart_Cell") as! Customer_Cart_Cell
        cell.cartName.text = cart.order_items_information[indexPath.row].product.name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoModel = cart.order_items_information[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Cart_Details") as! Cart_Details
        vc.infoModel = infoModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
