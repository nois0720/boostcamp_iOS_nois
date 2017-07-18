//
//  MyButton.swift
//  MyButton
//
//  Created by Yoo Seok Kim on 2017. 7. 17..
//  Copyright © 2017년 Nois. All rights reserved.
//
import UIKit

class MyButton: UIView {
    
    //MARK: Enum
    enum AvailableState: Int {
        case enabled = 0
        case disabled
    }
    
    enum ButtonState: Int {
        case isNormal = 0
        case isSelected
    }
    
    //MARK: Variables
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
                setTitle(normalLabel)
            case .isSelected:
                setTitle(selectedLabel)
            }
        }
    }
    
    var isHighlighted: Bool {
        didSet {
            if buttonState == .isNormal && isHighlighted {
                setTitle(normalHighlightedLabel)
            } else if buttonState == .isSelected && isHighlighted {
                setTitle(selectedHighlitedLabel)
            } else if buttonState == .isNormal && !isHighlighted {
                setTitle(normalLabel)
            } else if buttonState == .isSelected && !isHighlighted {
                setTitle(selectedLabel)
            }
        }
    }
    
    @IBOutlet var label: UILabel!
    
    @IBInspectable var normalLabel: String?
    @IBInspectable var selectedLabel: String?
    @IBInspectable var normalHighlightedLabel: String?
    @IBInspectable var selectedHighlitedLabel: String?
    
    var eventList: [UIControlEvents.RawValue : (Selector, Any)] = [ : ]
    
    //MARK: Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        guard self.bounds.contains(touchLocation) else {
            return
        }
        
        switch buttonState {
        case .isNormal:
            buttonState = .isSelected
        case .isSelected:
            buttonState = .isNormal
        }
        
        sendAction(for: [.touchUpInside])
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
    
    func setTitle(_ title: String?) {
        label?.text = title ?? ""
    }
    
    func sendAction(for controlEvents: UIControlEvents) {
        guard let tuple = eventList[controlEvents.rawValue] else {
            return
        }
        
        let selector = tuple.0
        if let target = tuple.1 as? NSObjectProtocol {
            target.perform(selector)
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        guard let t = target as Any? else {
            return
        }
        
        eventList[controlEvents.rawValue] = (action, t)
    }
    
    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        eventList[controlEvents.rawValue] = nil
    }
    
}
