//
//  TransactionsTableViewCell.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-15.
//

import Foundation
import UIKit

class TransactionsTableViewCell: UITableViewCell {
    let transactionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()
    
    let amountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.numberOfLines = 2
        lbl.textAlignment = .right
        return lbl
    }()
    
    var transaction: Transaction? {
        didSet {
            configureCell(transaction: transaction)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        uiSetup()
    }
    
    //MARK: - Cell UI Setup
    fileprivate func uiSetup(){
        [transactionLabel, amountLabel].forEach({ contentView.addSubview($0)})
        transactionLabel.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trialing: amountLabel.leadingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        amountLabel.anchor(top: transactionLabel.topAnchor, bottom: transactionLabel.bottomAnchor, leading: transactionLabel.trailingAnchor, trialing: contentView.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 8))
    }
    
    //MARK: - Configuare Cell
    fileprivate func configureCell(transaction: Transaction?){
        transactionLabel.text = transaction?.transactionDescription ?? "Not available"
        let amount = transaction?.amount ?? 0.0
        let isIncome = transaction?.type == 2
        amountLabel.text = isIncome ? "$ \(amount)" : "-$ \(amount)"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
