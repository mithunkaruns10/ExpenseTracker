//
//  TransactionTests.swift
//  ExpenseTrackerTests
//
//  Created by Mithun Karun Suma on 2022-09-17.
//

import XCTest
@testable import ExpenseTracker

class TransactionTests: XCTestCase {
    var transactionViewModel: TransactionViewModel?
    override func setUpWithError() throws {
       transactionViewModel = TransactionViewModel()
    }

    override func tearDownWithError() throws {
        transactionViewModel = nil
    }

    //MARK: - Validate a transaction with all valid input
    func testValidateTransactionWithAllValidInputs() throws {
        let validTransactionType = Int64(1)
        let validDecription = "Burger"
        let validAmount = "35"
        let isValidTransaction = transactionViewModel?.isTransactionValid(transactionType: validTransactionType, description: validDecription, amountString: validAmount)
        XCTAssertEqual(isValidTransaction, true, "Valid transaction")
    }
    //MARK: - Validate a transaction with all invalid input
    func testValidateTransactionWithAllInValidInputs() throws {
        let validTransactionType = Int64(3)
        let validDecription = ""
        let validAmount = "#35"
        let isValidTransaction = transactionViewModel?.isTransactionValid(transactionType: validTransactionType, description: validDecription, amountString: validAmount)
        XCTAssertEqual(isValidTransaction, false, "Invalid transaction")
    }
    //MARK: - Validate a transaction with invalid Transaction type
    func testValidateTransactionWithInValidTransactionType() throws {
        let validTransactionType = Int64(3)
        let validDecription = "Juice"
        let validAmount = "55"
        let isValidTransaction = transactionViewModel?.isTransactionValid(transactionType: validTransactionType, description: validDecription, amountString: validAmount)
        XCTAssertEqual(isValidTransaction, false, "Invalid transaction - Invalid transaction")
    }
    //MARK: - Validate a transaction with empty Description
    func testValidateTransactionWithEmptyDescription() throws {
        let validTransactionType = Int64(1)
        let validDecription = ""
        let validAmount = "55"
        let isValidTransaction = transactionViewModel?.isTransactionValid(transactionType: validTransactionType, description: validDecription, amountString: validAmount)
        XCTAssertEqual(isValidTransaction, false, "Invalid transaction - Empty Description")
    }
    //MARK: - Validate a transaction with invalid Amount
    func testValidateTransactionWithInvalidAmount() throws {
        let validTransactionType = Int64(2)
        let validDecription = "Tour"
        let validAmount = "+-#5.0"
        let isValidTransaction = transactionViewModel?.isTransactionValid(transactionType: validTransactionType, description: validDecription, amountString: validAmount)
        XCTAssertEqual(isValidTransaction, false, "Invalid transaction - Invalid amount")
    }
    //MARK: - Get amount from string value - invalid amount
    func testGetAmountFromString() throws {
        let amountString = ""
        let amountStringValid = "34.5"
        let amountStringWithChars = "34.5$hs"
        
        let amount = transactionViewModel?.getAmount(from: amountString)
        let validAmount = transactionViewModel?.getAmount(from: amountStringValid)
        let invalidAmount = transactionViewModel?.getAmount(from: amountStringWithChars)
        
        XCTAssertEqual(amount, 0.0, "Empty string returns 0")
        XCTAssertEqual(validAmount, 34.5, "Valid")
        XCTAssertEqual(invalidAmount, nil, "Invalid")
    }
    //MARK: - Increment stepper operation
    func testIncrementAmountByOne() throws {
        let validAmount = 15.0
        let zeroAmount = 0.0
        let oneAmount = 1.0
        
        let incrementedAmountTestOne = transactionViewModel?.incrementByOne(currentValue: validAmount)
        let incrementedAmountTestTwo = transactionViewModel?.incrementByOne(currentValue: zeroAmount)
        let incrementedAmountTestThree = transactionViewModel?.incrementByOne(currentValue: oneAmount)
        
        XCTAssertEqual(incrementedAmountTestOne, "16.0", "Success")
        XCTAssertEqual(incrementedAmountTestTwo, "1.0", "Success")
        XCTAssertEqual(incrementedAmountTestThree, "2.0", "Success")
    }
    //MARK: - Decrement stepper operation
    func testDecrementAmountByOne() throws {
        let validAmount = 15.0
        let negativeAmount = -1.0
        let oneAmount = 1.0
        
        let incrementedAmountTestOne = transactionViewModel?.decrementByOne(currentValue: validAmount)
        let incrementedAmountTestTwo = transactionViewModel?.decrementByOne(currentValue: negativeAmount)
        let incrementedAmountTestThree = transactionViewModel?.decrementByOne(currentValue: oneAmount)
        
        XCTAssertEqual(incrementedAmountTestOne, "14.0", "Success")
        XCTAssertEqual(incrementedAmountTestTwo, "1.0", "Success")
        XCTAssertEqual(incrementedAmountTestThree, "1.0", "Success")
    }
}
