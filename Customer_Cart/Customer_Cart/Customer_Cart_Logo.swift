import UIKit

class Customer_Cart_Logo: UIViewController {
    var managerAPI: ManagerAPI = .shared
    @IBOutlet var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "Custom_Cart")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Customer_Cart") as! Customer_Cart
        managerAPI.receiveParse { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
