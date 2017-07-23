//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Yoo Seok Kim on 2017. 7. 22..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var serialTextField: UITextField!
    @IBOutlet var valueTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    let numberFormater: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.text = item!.name
        serialTextField.text = item!.serialNumber
        valueTextField.text = numberFormater.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormater.string(from: item.dateCreated as Date)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        item!.name = nameTextField.text ?? ""
        item!.serialNumber = serialTextField.text
        
        guard let valueText = valueTextField.text,
            let value = numberFormater.number(from: valueText) else {
                item!.valueInDollars = 0
                return
        }
        
        item!.valueInDollars = value as! Int
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backGroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
