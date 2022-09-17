//
//  TransactionViewModel.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-17.
//

import Foundation


struct TransactionViewModel {
    
    //MARK: - Validate a transaction
    func isTransactionValid(transactionType: Int64?, description:String?, amountString: String?) -> Bool {
        var validationStatus = false
        let amount = getAmount(from: amountString)
        guard let transactionType = transactionType, let description = description, let amount = amount else {
            return false
        }
        validationStatus = (transactionType == 1 || transactionType == 2) && description.count > 1 && amount > 0.0
        return validationStatus
    }
    //MARK: - Calculate overall expenses, income, and balance
    func overAllExpenditure(transactions:[Transaction]) -> (Double, Double, Double){
        var totalExpense: Double = 0.0
        var totalIncome: Double = 0.0
        var balance: Double = 0.0
        
        transactions.forEach { transaction in
            switch transaction.type {
            case 1:
                totalExpense = totalExpense + transaction.amount
            case 2:
                totalIncome = totalIncome + transaction.amount
            default:
                break
            }
        }
        balance = (totalIncome - totalExpense) > 0 ? (totalIncome - totalExpense) : 0
        return (totalExpense, totalIncome, balance)
    }
    
    //MARK: - Convert amount string value to double
     func getAmount(from amountString: String?) -> Double? {
        if amountString?.isEmpty ?? true {
            return 0.0
        } else {
            return Double(amountString!)
        }
    }
    //MARK: - Increment amount
     func incrementByOne(currentValue: Double) -> String{
        return String(currentValue + 1)
    }
    //MARK: - Decrement amount
     func decrementByOne(currentValue: Double) -> String{
        return currentValue <= 1.0 ? String(1.0) : String(currentValue - 1)
    }
}
