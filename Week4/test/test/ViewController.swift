//
//  ViewController.swift
//  test
//
//  Created by Yoo Seok Kim on 2017. 7. 24..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.addTarget(self, action: #selector(test), for: .touchDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() {
        print("Test")
    }
}

class ChildViewController: ViewController {
    
}
