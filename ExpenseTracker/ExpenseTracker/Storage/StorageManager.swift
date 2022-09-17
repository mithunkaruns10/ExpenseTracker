//
//  StorageManager.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-16.
//

import Foundation
import UIKit

struct Storage {
    
    static let shared = Storage()
    
    private init() { }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Fetch all transactions
    func fetchAllTransactions(completion: @escaping(_ transactions: [Transaction]?,_ error: Error?) -> Void){
        do {
            let transactions = try context.fetch(Transaction.fetchRequest())
            completion(transactions, nil)
        } catch let fetchError {
            debugPrint("Error fetching transactions", fetchError)
            completion(nil, fetchError)
        }
    }
    //MARK: - Add a transaction
    func addTransaction(transactionType: Int64, desc: String, amount: Double, completion: @escaping(_ status: Bool,_ error: Error?) -> Void) {
        
        let transaction = Transaction(context: context)
        transaction.date = Date()
        transaction.transactionDescription = desc
        transaction.amount = amount
        transaction.type = transactionType
        do {
             try context.save()
            completion(true, nil)
        } catch let err {
            debugPrint("Error adding transaction", err)
            completion(false, err)
        }
    }
    //MARK: -  Delete a transaction
    func deleteTransaction(transaction: Transaction) {
       context.delete(transaction)
    }
}
