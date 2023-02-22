import UIKit
import CoreData

class Customer_Cart_Core: UIViewController {
    @IBOutlet var cart_total_Label: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var filteredFlag: Bool = false
    var filteredData: [Cart] = []
    var managerAPI: ManagerAPI = .shared
    lazy var fetchedResultController: NSFetchedResultsController<Cart> = {
        let request: NSFetchRequest<Cart> = Cart.fetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AppDelegate.coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        self.navigationItem.hidesBackButton = true
        managerAPI.receiveParse { [weak self] in
            try? self?.fetchedResultController.performFetch()
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.cart_total_Label.text = "Cart total: \(self!.fetchDataFromCartTotal() / 100)"
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func fetchDataFromCartTotal() -> Double {
        let fetchRequest: NSFetchRequest<CartTotal> = CartTotal.fetchRequest()
        let items = try! AppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
        let item = items.first!.cart_total
        return item
    }
}

extension Customer_Cart_Core: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredFlag == true {
            return filteredData.count
        }
        guard let carts = fetchedResultController.fetchedObjects else {return 0}
        return carts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredFlag == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cart_Cell")
            cell?.textLabel?.text = filteredData[indexPath.row].name
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cart_Cell", for: indexPath)
        let infoModel = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = infoModel.name
        cell.selectionStyle = .gray
        return cell
    }
}

extension Customer_Cart_Core: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoModel = fetchedResultController.object(at: indexPath)
        let infoModelId = infoModel.objectID
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Cart_Details") as! Cart_Details
        vc.infoID = infoModelId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Customer_Cart_Core: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        if searchText != "" {
            let fetchRequest: NSFetchRequest<Cart> = Cart.fetchRequest()
            let data = try! AppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
            filteredData = data.filter({ $0.name!.lowercased().uppercased().prefix(searchText.count) ==
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

extension Customer_Cart_Core {
    
}

