
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
    var availableState: AvailableState = .enabled {
        didSet {
            switch availableState {
            case .enabled:
                backgroundColor = backgroundColor?.withAlphaComponent(1)
            case .disabled:
                backgroundColor = backgroundColor?.withAlphaComponent(0.5)
            }
        }
    }
    
    var buttonState: ButtonState = .isNormal {
        didSet {
            switch buttonState {
            case .isNormal:
                setTitle(normalLabel)
                setBgColor(normalColor)
            case .isSelected:
                setTitle(selectedLabel)
                setBgColor(selectedColor)
            }
        }
    }
    
    var isHighlighted: Bool = false {
        didSet {
            if buttonState == .isNormal && isHighlighted {
                setTitle(normalHighlightedLabel)
                setBgColor(normalHighlightedColor)
            } else if buttonState == .isSelected && isHighlighted {
                setTitle(selectedHighlitedLabel)
                setBgColor(selectedHighlitedColor)
            } else if buttonState == .isNormal && !isHighlighted {
                setTitle(normalLabel)
                setBgColor(normalColor)
            } else if buttonState == .isSelected && !isHighlighted {
                setTitle(selectedLabel)
                setBgColor(selectedColor)
            }
        }
    }
    
    var label: UILabel!
    @IBInspectable var normalLabel: String?
    @IBInspectable var selectedLabel: String?
    @IBInspectable var normalHighlightedLabel: String?
    @IBInspectable var selectedHighlitedLabel: String?
    
    @IBInspectable var normalColor: UIColor?
    @IBInspectable var selectedColor: UIColor?
    @IBInspectable var normalHighlightedColor: UIColor?
    @IBInspectable var selectedHighlitedColor: UIColor?
    
    var eventList: [UIControlEvents.RawValue : (Selector, Any)] = [ : ]
    
    //MARK: Touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard availableState == .enabled else {
            return
        }
        
        isHighlighted = true
        sendAction(for: [.touchDown])
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
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLabel()
    }
    
    func setTitle(_ title: String?) {
        guard title != "" else {
            return
        }
        
        guard title != nil else {
            return
        }
        
        label.text = title
    }
    
    func setBgColor(_ color: UIColor?) {
        guard color != nil else {
            return
        }
        
        self.backgroundColor = color!
    }
    
    func sendAction(for controlEvents: UIControlEvents) {
        guard let tuple = eventList[controlEvents.rawValue] else {
            return
        }
        
        if(controlEvents.contains(.touchDown)) {
            self.buttonState = .isNormal
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
    
    func setLabel() {
        label = UILabel()
        label.text = normalLabel ?? ""
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.addSubview(label)
        
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 200)
        let alignCenterXConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[superview]-(<=1)-[label]",
            options: NSLayoutFormatOptions.alignAllCenterX,
            metrics: nil,
            views: ["superview":self, "label":label])
        
        self.addConstraints(alignCenterXConstraints)
        
        // Center vertically
        let alignCenterYConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[superview]-(<=1)-[label]",
            options: NSLayoutFormatOptions.alignAllCenterY,
            metrics: nil,
            views: ["superview":self, "label":label])
        
        self.addConstraints(alignCenterYConstraints)
        
        self.addConstraints([ widthConstraint, heightConstraint])
    }
}
