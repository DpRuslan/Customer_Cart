import Foundation
import UIKit
import CoreData

class ManagerAPI {
    static var shared: ManagerAPI = .init()
    private init () {}
    func receiveParse(completion: @escaping () -> Void) {
        do {
            if try AppDelegate.coreDataStack.managedContext.count(for: NSFetchRequest<Cart>(entityName: "Cart")) != 0 {
                completion()
            } else {
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
                    if let decodedData = try? decoder.decode(Customer_Cart_Core.Details.self, from: data) {
                        let newCartTotal = CartTotal(context: AppDelegate.coreDataStack.managedContext)
                        newCartTotal.cart_total = decodedData.cart_total
                        for i in decodedData.order_items_information {
                            let newCart = Cart(context: AppDelegate.coreDataStack.managedContext)
                            let newPhoto = ItemPhoto(context: AppDelegate.coreDataStack.managedContext)
                            newPhoto.unit_photo_filename = i.product.unit_photo_filename
                            newPhoto.pack_photo_file = i.product.pack_photo_file
                            newPhoto.weight_photo_filename = i.product.weight_photo_filename
                            newCart.name = i.product.name
                            newCart.packaging_type = i.packaging_type
                            newCart.unit_price = Int64(i.product.unit_price)
                            newCart.case_price = Int64(i.product.case_price)
                            newCart.weight_price = Int64(i.product.weight_price)
                            newCart.quantity = i.quantity
                            newCart.substitutable = i.substitutable
                            newCart.sub_total = Int64(i.sub_total)
                            newCart.photo = newPhoto
                        }
                        try! AppDelegate.coreDataStack.managedContext.save()
                    }
                    completion()
                }.resume()
            }
        } catch {}
    }
}
