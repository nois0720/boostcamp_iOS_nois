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
    
    var eventDictionary: [UIControlEvents.RawValue : [(Selector, Any)]] = [ : ]
    
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
        
        print("end touch 1 \(UIControlEvents.touchUpInside.rawValue)")
        print("end touch 2 \(UIControlEvents.touchDragInside.rawValue)")
        
        sendAction(for: [.touchUpInside])
        sendAction(for: [.touchUpInside, .touchDragInside])
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        self.availableState = .enabled
        self.buttonState = .isNormal
        self.isHighlighted = false
        super.init(frame: frame)
        
        setTitle(normalLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.availableState = .enabled
        self.buttonState = .isNormal
        self.isHighlighted = false
        super.init(coder: aDecoder)
    }
    
    func setTitle(_ title: String?) {
        label?.text = title ?? ""
        label?.textAlignment = .center
    }
    
    func sendAction(for controlEvents: UIControlEvents) {
        //controlEvents.
        
        print("send action \(controlEvents.rawValue)")
        //controlEvents.
        
        guard let events = eventDictionary[controlEvents.rawValue] else {
            return
        }
        
        for event in events {
            let selector = event.0

            if let target = event.1 as? NSObjectProtocol {
                target.perform(selector)
            }
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        print("add target. \(controlEvents)")
        
        guard let t = target as Any? else {
            return
        }
        
        if eventDictionary[controlEvents.rawValue] == nil {
            eventDictionary[controlEvents.rawValue] = []
        }
        
        eventDictionary[controlEvents.rawValue]!.append((action,t))
    }
    
    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents) {
        //eventDictionary[controlEvents.rawValue]?.remove(at: <#T##Int#>) = nil
    }
}
