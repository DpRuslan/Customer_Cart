import UIKit

class Customer_Cart: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!
    static var cart: Details!
    var managerAPI: ManagerAPI! = .shared
    var filteredData = [InfoOfEachItem]()
    var filteredFlag: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        navigationItem.hidesBackButton = true
        navigationItem.title = "Customer Cart"
        searchBar.placeholder = "Type something"
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
        if filteredFlag == true {
            return filteredData.count
        }
        guard let cart = Customer_Cart.cart else {return 0}
        return cart.order_items_information.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredFlag == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = filteredData[indexPath.row].product.name
            return cell!
        }
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

extension Customer_Cart: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        if searchText != "" {
            filteredData = Customer_Cart.cart.order_items_information.filter({ $0.product.name.lowercased().uppercased().prefix(searchText.count) ==
                searchText.lowercased().uppercased()})
            filteredFlag = true
        } else {
            filteredFlag = false
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredFlag = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
