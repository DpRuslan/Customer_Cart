import UIKit

class Customer_Cart_Logo: UIViewController {
    @IBOutlet var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.image = UIImage(named: "Custom_Cart")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Customer_Cart") as! Customer_Cart
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
