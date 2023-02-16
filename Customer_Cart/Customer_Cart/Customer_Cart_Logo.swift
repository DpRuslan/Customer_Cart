import UIKit
import CoreData

class Customer_Cart_Logo: UIViewController {
    @IBOutlet var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "Custom_Cart")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Customer_Cart") as! Customer_Cart_Core
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
