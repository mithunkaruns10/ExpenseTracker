//
//  UITextField+Extension.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-17.
//

import Foundation
import UIKit

extension UITextField{
    //MARK: - Add a left padding to a textfield
    func addLeftPadding(with text: String? = " ") {
        self.leftViewMode = .always
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftLabel.text = text
        leftView = leftLabel
    }
    //MARK: - Remove white spaces and newlines from textfield text
    func getText()-> String?{
        return self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
