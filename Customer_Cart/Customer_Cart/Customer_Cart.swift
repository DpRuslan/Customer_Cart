import UIKit

class Customer_Cart: UITableViewController {
    var managerAPI: ManagerAPI! = .shared
    static var cart: Details!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "Customer Cart"
        managerAPI.receiveParse { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension Customer_Cart {
    struct Details: Decodable {
        var id: Int
        var cart_total: Double
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
}

extension Customer_Cart {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cart = Customer_Cart.cart else {return 0}
        return cart.order_items_information.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Customer_Cart_Cell") as! Customer_Cart_Cell
            cell.cartTotalTitle.text = "Cart total: \(Customer_Cart.cart.cart_total / 100)"
            cell.cartTotalTitle.textColor = .white
            cell.backgroundColor = .darkGray
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = Customer_Cart.cart.order_items_information[indexPath.row].product.name
            return cell!
        }
    }
}

extension Customer_Cart {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoModel = Customer_Cart.cart.order_items_information[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Cart_Details") as! Cart_Details
        vc.infoModel = infoModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
