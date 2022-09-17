//
//  TransactionDetailsCell.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-15.
//

import Foundation
import UIKit

class TransactionDetailsCell: UITableViewCell {
    
    let container: UIView = {
        let cView = UIView()
        cView.translatesAutoresizingMaskIntoConstraints = false
        cView.layer.borderWidth = 1.0
        cView.layer.cornerRadius = 10
        cView.layer.masksToBounds = true
        return cView
    }()
    
    let expenseTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "Expenses"
        lbl.textAlignment = .center
        return lbl
    }()
    
    let expenseLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let incomeTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "Income"
        lbl.textAlignment = .center
        return lbl
    }()
    let incomeLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let balanceTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "Balance"
        lbl.textAlignment = .center
        return lbl
    }()
    let balanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        return lbl
    }()
    
    let transactionProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.0
        progressView.layer.borderWidth = 1.0
        progressView.layer.cornerRadius = 8
        progressView.layer.masksToBounds = true
        return progressView
    }()
    
    let separatorBarOne: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .black
        return separator
    }()
    
    let separatorBarTwo: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .black
        return separator
    }()
    var transactions: (Double, Double, Double)?{
        didSet {
            configureCell(transactions: transactions)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        uiSetup()
    }
    
    //MARK: - Cell UI Setup
    fileprivate func uiSetup(){
        
        contentView.addSubview(container)
        let stackViewExpense  = UIStackView(arrangedSubviews: [expenseTitleLabel, expenseLabel])
        let stackViewIncome  = UIStackView(arrangedSubviews: [incomeTitleLabel, incomeLabel])
        let stackViewBalance  = UIStackView(arrangedSubviews: [balanceTitleLabel, balanceLabel])
        
        [separatorBarOne, separatorBarTwo, transactionProgressView].forEach({
            container.addSubview($0)
        })

        [stackViewIncome, stackViewBalance, stackViewExpense].forEach({
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 8
        })
        let detailsContainerStackView = UIStackView(arrangedSubviews: [stackViewExpense, separatorBarOne, stackViewIncome, separatorBarTwo, stackViewBalance])
        detailsContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        detailsContainerStackView.axis = .horizontal
        detailsContainerStackView.spacing = 24
        detailsContainerStackView.distribution = .equalCentering
        container.addSubview(detailsContainerStackView)
        
        container.anchor(top: contentView.topAnchor, bottom: contentView.bottomAnchor, leading: contentView.leadingAnchor, trialing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        detailsContainerStackView.anchor(top: container.topAnchor, bottom: transactionProgressView.topAnchor, leading: container.leadingAnchor, trialing: container.trailingAnchor, padding: .init(top: 50, left: 16, bottom: 32, right: 16))
        transactionProgressView.anchor(top: detailsContainerStackView.bottomAnchor, bottom: container.bottomAnchor, leading: detailsContainerStackView.leadingAnchor, trialing: detailsContainerStackView.trailingAnchor, padding: .init(top: 32, left: 0, bottom: 16, right: 0), size: .init(width: detailsContainerStackView.frame.width, height: 18))
        [separatorBarOne, separatorBarTwo].forEach({
            $0.anchorFixedSize(size: .init(width: 2, height: stackViewExpense.frame.size.height))
        })
    }
    
    //MARK: - Configuare Cell
    fileprivate func configureCell(transactions: (Double, Double, Double)?){
        guard let transactions = transactions else {
            return
        }
        expenseLabel.text = "$" + String(transactions.0)
        incomeLabel.text = "$" + String(transactions.1)
        balanceLabel.text = "$" + String(transactions.2)
        self.transactionProgressView.progress = 0.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            UIView.animate(withDuration: 1) {
                self.transactionProgressView.progress = Float(transactions.0 / transactions.1)
                self.transactionProgressView.layoutIfNeeded()
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

