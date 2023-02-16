//
//  Cart+CoreDataProperties.swift
//  Customer_Cart
//
//  Created by Ruslan Yarkun on 16.02.2023.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart")
    }

    @NSManaged public var case_price: Int64
    @NSManaged public var name: String?
    @NSManaged public var packaging_type: String?
    @NSManaged public var quantity: Double
    @NSManaged public var sub_total: Int64
    @NSManaged public var substitutable: Bool
    @NSManaged public var unit_price: Int64
    @NSManaged public var weight_price: Int64
    @NSManaged public var photo: ItemPhoto?

}

extension Cart : Identifiable {

}
