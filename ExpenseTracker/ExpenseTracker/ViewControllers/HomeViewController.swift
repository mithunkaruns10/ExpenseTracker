//
//  HomeViewController.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-15.
//

import Foundation
import UIKit


class HomeViewController: UIViewController {
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = .systemBlue
        tv.separatorInset = .zero
        return tv
    }()
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.cornerRadius = btn.frame.width / 2
        btn.layer.masksToBounds = true
        btn.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        return btn
    }()
    let dateFormator: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var transactions: [Transaction]?
    var transactionDates = [String]()
    var transactionDict = [String: [Transaction]]()
    let transactionViewModel = TransactionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
        tableViewSetup()
        getAllTransactions()
    }
    //MARK: - UI Setup
    fileprivate func uiSetup(){
        title = "Home"
        [tableView, addButton].forEach({view.addSubview($0)})
        view.bringSubviewToFront(addButton)
        
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trialing: view.trailingAnchor)
        addButton.anchor(top: nil, bottom: view.bottomAnchor, leading: nil, trialing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 50, right: 25), size: .init(width: 60, height: 60))
        
        addButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
    }
    //MARK: - UItableview Setup
    fileprivate func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(TransactionsTableViewCell.self, forCellReuseIdentifier: Constant.Identifier.transactionCellId)
        tableView.register(TransactionDetailsCell.self, forCellReuseIdentifier: Constant.Identifier.transactionDetailCellId)
    }
    //MARK: - Add button actio
    @objc func addTransaction(){
        guard let addTransactionVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constant.Identifier.addTransaction) as? AddTransactionViewController else { return }
        addTransactionVC.modalTransitionStyle = .crossDissolve
        addTransactionVC.modalPresentationStyle = .overCurrentContext
        addTransactionVC.homeVC = self
        self.present(addTransactionVC, animated: true)
    }
    //MARK: - Get all transactions
   @objc  func getAllTransactions() {
        Storage.shared.fetchAllTransactions { transactions, error in
            guard let transactions = transactions else { return }
            self.transactions = transactions
            self.transactionDict = Dictionary(grouping: transactions, by: { self.dateFormator.string(from: $0.date!) })
            self.transactionDates = Array(self.transactionDict.keys)
            self.tableView.reloadData()
        }
    }
    //MARK: - Delete a transaction
    fileprivate func deleteTransaction(transaction:Transaction){
        Storage.shared.deleteTransaction(transaction: transaction)
        getAllTransactions()
    }
}
//MARK: - UITableview delegate & dataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionDict.keys.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : transactionDict[transactionDates[section - 1]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.transactionDetailCellId, for: indexPath) as? TransactionDetailsCell else {
                return UITableViewCell()
            }
            
            cell.transactions = transactionViewModel.overAllExpenditure(transactions: self.transactions ?? [])

            return cell
            
        } else {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.transactionCellId, for: indexPath) as? TransactionsTableViewCell else {
                return UITableViewCell()
            }
            let transactions = transactionDict[transactionDates[indexPath.section - 1]]
            cell.transaction = transactions?[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? view.frame.height * 0.2 : UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : CommonUtils.getDateString(date: transactionDict[transactionDates[section - 1]]?.first?.date ?? Date())
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let transactions = self.transactionDict[self.transactionDates[indexPath.section - 1]]
            guard let transaction = transactions?[indexPath.row] else { return }
            self.deleteTransaction(transaction: transaction)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return  indexPath.section == 0 ? nil : configuration
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let dateLabel = view as! UITableViewHeaderFooterView
        dateLabel.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        dateLabel.textLabel?.textColor = .black
    }
}
