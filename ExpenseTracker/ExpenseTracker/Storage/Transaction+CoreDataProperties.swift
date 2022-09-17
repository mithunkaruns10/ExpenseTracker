//
//  Transaction+CoreDataProperties.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-16.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var date: Date?
    @NSManaged public var transactionDescription: String?
    @NSManaged public var type: Int64
    @NSManaged public var amount: Double

}

extension Transaction : Identifiable {
    
}
