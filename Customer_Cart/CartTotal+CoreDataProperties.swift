//
//  CartTotal+CoreDataProperties.swift
//  Customer_Cart
//
//  Created by Ruslan Yarkun on 16.02.2023.
//
//

import Foundation
import CoreData


extension CartTotal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartTotal> {
        return NSFetchRequest<CartTotal>(entityName: "CartTotal")
    }

    @NSManaged public var cart_total: Double

}

extension CartTotal : Identifiable {

}
