import UIKit

class Cart_Details: UIViewController {
    @IBOutlet var imageOfItem: UIImageView!
    @IBOutlet var tableView: UITableView!
    var infoModel: Customer_Cart.InfoOfEachItem!
    var urlOfPhoto: URL!
    var data: [Info] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = assignData()
        self.tableView.dataSource = self
        imageOfItem.image = assignImage()
    }
}

extension Cart_Details {
    enum Info {
        case name(value: String)
        case price(value: Double)
        case quantity(value: String)
        case sub_total(value: Double)
        case packaging_type(value: String)
        case substitutable(value: String)
        
        var cellTitle: String {
            switch self {
            case .name(_):
                return "Name"
            case .price(_):
                return "Price"
            case .quantity(_):
                return "Quantity"
            case .sub_total(_):
                return "Sub_total"
            case .packaging_type(_):
                return "Packaging_Type"
            case .substitutable(_):
                return "Substitutable"
            }
        }
        
        var cellValue: String {
            switch self {
            case .name(let value):
                return "\(value)"
            case .price(let value):
                return "\(value / 100)"
            case .quantity(let value):
                return "\(value)"
            case .sub_total(let value):
                return "\(value / 100)"
            case .packaging_type(let value):
                return "\(value)"
            case .substitutable(let value):
                return "\(value)"
            }
        }
    }
}

extension Cart_Details: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! Item_Cell
        cell.titleItem.text = data[indexPath.row].cellTitle
        cell.valueItem.text = data[indexPath.row].cellValue
        cell.selectionStyle = .none
        return cell
    }
}

extension Cart_Details {
    func assignData() -> [Info] {
        data = [.name(value: infoModel.product.name), .quantity(value: "\(infoModel.quantity)"), .sub_total(value: Double(infoModel.sub_total)), .packaging_type(value: infoModel.packaging_type), .substitutable(value: " \(infoModel.substitutable)")]
        if infoModel.packaging_type == "unit" {
            data.insert(.price(value: Double(infoModel.product.unit_price)), at: 1)
            urlOfPhoto = URL(string: infoModel.product.unit_photo_filename)
        } else if infoModel.packaging_type == "case" {
            urlOfPhoto = URL(string: infoModel.product.pack_photo_file)
            data.insert(.price(value: Double(infoModel.product.case_price)), at: 1)
        } else {
            urlOfPhoto = URL(string: infoModel.product.weight_photo_filename)
            data.insert(.price(value: Double(infoModel.product.weight_price)), at: 1)
        }
        return data
    }
    
    func assignImage() -> UIImage {
        guard let urlOfPhoto = urlOfPhoto else {
            imageOfItem.image = UIImage(named: "placeholder")
            return imageOfItem.image!
        }
        imageOfItem.image = UIImage(data: try! Data(contentsOf: urlOfPhoto))
        return imageOfItem.image!
    }
}
