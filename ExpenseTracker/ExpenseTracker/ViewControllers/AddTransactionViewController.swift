//
//  AddTransactionViewController.swift
//  ExpenseTracker
//
//  Created by Mithun Karun Suma on 2022-09-15.
//

import Foundation
import UIKit

class AddTransactionViewController: UIViewController{
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = .systemBlue
        tv.separatorInset = .zero
        return tv
    }()

    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addTransactionButton: UIButton!
    @IBOutlet weak var transactionAmountDecrementButton: UIButton!
    @IBOutlet weak var transactionAmountIncrementButton: UIButton!
    @IBOutlet weak var transactionAmountTextField: UITextField!
    @IBOutlet weak var transactionAmountView: UIView!
    @IBOutlet weak var transactionDescriptionTextField: UITextField!
    @IBOutlet weak var transactionTypeTextField: UITextField!
    @IBOutlet weak var transactionTypeDropDownView: UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    
    var tap: UITapGestureRecognizer!
    var bottomConstraintConstant: CGFloat = 0
    var currentTransactiontype: Int64 = 1
    weak var homeVC: HomeViewController?
    let transactionViewModel = TransactionViewModel()
    let transactionTypes: [TransactionType] = [.expense, .income]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup()
        dropDownSetup()
        addKeyboardDisplayObservers()
    }
    
    //MARK: - UI Setup
    fileprivate func uiSetup(){
        
        bottomConstraintConstant = containerBottomConstraint.constant
        tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        [dropDownButton, transactionAmountIncrementButton, transactionAmountDecrementButton, transactionTypeDropDownView, transactionAmountView, transactionDescriptionTextField].forEach({
            $0?.layer.borderColor = UIColor.black.cgColor
            $0?.layer.borderWidth = 1
        })
        transactionAmountTextField.addLeftPadding(with: " $")
        transactionAmountTextField.becomeFirstResponder()
        [transactionTypeTextField, transactionDescriptionTextField].forEach({ $0?.addLeftPadding()})
    }
    //MARK: - Add Keyboard observers
    fileprivate func addKeyboardDisplayObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - DropDown Tableview setup
    fileprivate func dropDownSetup(){
        containerView.addSubview(tableView)
        tableView.anchor(top: transactionTypeDropDownView.bottomAnchor, bottom: nil, leading: transactionTypeDropDownView.leadingAnchor, trialing: transactionTypeDropDownView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: transactionTypeDropDownView.frame.width, height: 50))
        tableView.isHidden = true
        containerView.bringSubviewToFront(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    //MARK: - Handle Dropdown action
    @IBAction func handleDropDownButtonTapAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UIView.animate(withDuration: 0.8) {
            self.tableView.isHidden = !sender.isSelected
        }
    }
    //MARK: - Handle Transaction amount increment/decrement action
    @IBAction func handleTransactionAmountInputAction(_ sender: UIButton) {
        guard let amount = transactionViewModel.getAmount(from: transactionAmountTextField.getText()) else { return }
        transactionAmountTextField.text = sender.tag == 0  ? transactionViewModel.incrementByOne(currentValue: amount) : transactionViewModel.decrementByOne(currentValue: amount)
    }
    //MARK: - Handle Add Transaction action
    @IBAction func handleAddTransactionButtonAction(_ sender: Any) {
        let isValid = transactionViewModel.isTransactionValid(transactionType: currentTransactiontype, description: transactionDescriptionTextField.getText(), amountString: transactionAmountTextField.getText())
        isValid ? addTransaction() : CommonUtils.showAlert(at: self, message: "Please enter valid details")
    }
    //MARK: - Add a transaction
    fileprivate func addTransaction(){
        guard let amount =  transactionViewModel.getAmount(from: transactionAmountTextField.getText()) else {
           return
        }
        Storage.shared.addTransaction(transactionType: currentTransactiontype, desc: transactionDescriptionTextField.getText() ?? "", amount:amount) { status, error in
            guard status || error == nil else {
                CommonUtils.showAlert(at: self, message: "Something went wrong. Please try again")
                return
            }
            self.dismiss(animated: true) {
                self.homeVC?.getAllTransactions()
            }
        }
    }
    //MARK: - Handle Dropdown selection
    fileprivate func handleDropDownSelection(type:TransactionType){
        transactionTypeTextField.text = type.rawValue
        tableView.isHidden = true
        dropDownButton.isSelected = false
    }
    //MARK: - Helpers Keyboad hide/show
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardSize.height > bottomConstraintConstant {
                UIView.animate(withDuration: 0.3) {
                    self.containerBottomConstraint.constant = keyboardSize.height + 16
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardSize.height > bottomConstraintConstant {
                UIView.animate(withDuration: 0.3) {
                    self.containerBottomConstraint.constant = keyboardSize.height - 16
                }
            }
        }
    }
    //MARK: - Dismiss Keyboard
    @objc func endEditing(){
        view.endEditing(true)
    }
    //MARK: - Handle Close button
    @IBAction func handleCloseAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension AddTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = transactionTypes[indexPath.row].rawValue
        cell.contentView.backgroundColor = .opaqueSeparator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTransactiontype = Int64(indexPath.row + 1)
        handleDropDownSelection(type: transactionTypes[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
}
