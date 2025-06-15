//
//  ExpenseEntity+CoreDataProperties.swift
//  EST_Trip
//
//  Created by 권도현 on 6/9/25.
//
//

import Foundation
import CoreData


extension ExpenseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpenseEntity> {
        return NSFetchRequest<ExpenseEntity>(entityName: "Expense")
    }

    @NSManaged public var amount: Int64
    @NSManaged public var category: Int16
    @NSManaged public var id: UUID
    @NSManaged public var memo: String?
    @NSManaged public var payerCount: Int16
    @NSManaged public var place: TravelEntity?

}

extension ExpenseEntity : Identifiable {

}
