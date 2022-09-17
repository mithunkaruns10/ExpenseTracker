//
//  CommonUtils.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-16.
//

import Foundation
import UIKit


struct CommonUtils {
    
    //MARK: - Get date string from date
    static func getDateString(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter.string(from: date)
    }
    //MARK: -  Show Alert
    static func showAlert(at viewController: UIViewController, title: String? = "Info", message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        viewController.present(alert, animated: true)
    }
}
