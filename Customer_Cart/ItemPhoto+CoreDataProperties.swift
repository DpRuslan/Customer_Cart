//
//  ItemPhoto+CoreDataProperties.swift
//  Customer_Cart
//
//  Created by Ruslan Yarkun on 16.02.2023.
//
//

import Foundation
import CoreData


extension ItemPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemPhoto> {
        return NSFetchRequest<ItemPhoto>(entityName: "ItemPhoto")
    }

    @NSManaged public var pack_photo_file: String?
    @NSManaged public var unit_photo_filename: String?
    @NSManaged public var weight_photo_filename: String?
    @NSManaged public var cart: Cart?

}

extension ItemPhoto : Identifiable {

}
