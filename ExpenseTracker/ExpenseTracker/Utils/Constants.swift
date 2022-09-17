//
//  Constants.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-15.
//

import Foundation


struct Constant {
    //MARK: - Identifiers
    struct Identifier{
        static let transactionCellId = "transactionCellId"
        static let transactionDetailCellId = "transactionDetailsCellId"
        static let addTransaction = "AddTransactionViewController"
    }
}
//MARK: - Transaction Types
enum TransactionType: String {
    case expense = "Expense"
    case income = "Income"
}
