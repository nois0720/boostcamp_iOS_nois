//
//  ViewController.swift
//  MyButton
//
//  Created by Yoo Seok Kim on 2017. 7. 17..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myButton: MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func activateMyButton(_ sender: UIButton) {
        switch myButton.availableState {
        case .disabled:
            myButton.availableState = .enabled
            sender.setTitle("Disable the button", for: .normal)
        case .enabled:
            myButton.availableState = .disabled
            sender.setTitle("Enable the button", for: .normal)
        }
    }
}
