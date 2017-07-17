//
//  MyButton.swift
//  MyButton
//
//  Created by Yoo Seok Kim on 2017. 7. 17..
//  Copyright © 2017년 Nois. All rights reserved.
//
import UIKit

class MyButton: UIView {
    
    enum AvailableState: Int {
        case enabled = 0
        case disabled
    }
    
    enum ButtonState: Int {
        case isNormal = 0
        case isSelected
    }
    
    var availableState: AvailableState {
        didSet {
            switch availableState {
            case .enabled:
                backgroundColor = backgroundColor?.withAlphaComponent(1)
            case .disabled:
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
            }
        }
    }
    
    var buttonState: ButtonState {
        didSet {
            switch buttonState {
            case .isNormal:
                label?.text = "normal"
            case .isSelected:
                label?.text = "selected"
            }
        }
    }
    
    var isHighlighted: Bool {
        didSet {
            if buttonState == .isNormal && isHighlighted {
                label?.text = "highlighted1"
            } else if buttonState == .isSelected && isHighlighted {
                label?.text = "highlighted2"
            }
        }
    }
    
    @IBOutlet var label: UILabel!
    @IBOutlet var backgroundImg: UIImageView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard availableState == .enabled else {
            return
        }
        
        print("touch start!")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard availableState == .enabled else {
            return
        }
        
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard availableState == .enabled else {
            return
        }
        
        isHighlighted = false
        
        switch buttonState {
        case .isNormal:
            buttonState = .isSelected
        case .isSelected:
            buttonState = .isNormal
        }
        
        print("touch end!")
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        self.availableState = .enabled
        self.buttonState = .isNormal
        self.isHighlighted = false
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.availableState = .enabled
        self.buttonState = .isNormal
        self.isHighlighted = false
        super.init(coder: aDecoder)
    }
    
}
