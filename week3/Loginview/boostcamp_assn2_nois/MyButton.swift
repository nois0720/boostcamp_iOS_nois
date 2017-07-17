//
//  MyButton.swift
//  boostcamp_assn2_nois
//
//  Created by Yoo Seok Kim on 2017. 7. 17..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class MyButton: UIView {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var backgroundImg: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touch start!")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch end!")
    }
    
}
