//
//  GameViewController.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 24..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

final class Action: NSObject {
    
    private let _action: () -> ()
    
    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }
    
    func action() {
        _action()
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var homeButton: MyButton!
    @IBOutlet weak var historyButton: MyButton!
    @IBOutlet weak var gameStartButton: MyButton!
    @IBOutlet weak var numberStackView: UIStackView!
    
    @IBOutlet weak var currRecord: UILabel!
    @IBOutlet weak var highRecord: UILabel!
    
    private var currentNumber: Int = 1
    private var maxNumber: Int = 25
    private var timer: Timer? = Timer()
    private var startDate: Date!
    
    private lazy var sortedArray: [Int] = {
        var array: [Int] = []
        
        for i in 1...self.maxNumber {
            array.append(i)
        }
        
        return array
    }()
    
    private var isStartGame: Bool = false {
        didSet {
            if isStartGame {
                self.historyButton!.availableState = .disabled
                self.gameStartButton.alpha = 0
            } else {
                self.historyButton!.availableState = .enabled
                self.gameStartButton.alpha = 1
            }
        }
    }
    
    //MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGameUIs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "history" else {
            return
        }
        
        let recordTableViewController = segue.destination as! RecordTableViewController
        
        guard recordTableViewController.recordStore == nil else {
            return
        }
        
        let recordStore = RecordStore()
        recordTableViewController.recordStore = recordStore
    }
    
    //MARK: View init functions
    func initGameUIs() {
        let highRecordItem = FileUtils.getHighScoreItem()
        
        if(highRecordItem != nil) {
            self.highRecord.text = "\(highRecordItem!.nickName) : \(highRecordItem!.record)"
        }
        
        self.homeButton.setTitle("Home")
        self.homeButton.label.font = UIFont.systemFont(ofSize: 22)
        self.homeButton.addTarget(self, action: #selector(gotoHome), for: .touchDown)
        
        self.historyButton.setTitle("History")
        self.historyButton.label.font = UIFont.systemFont(ofSize: 22)
        self.historyButton.addTarget(self, action: #selector(gotoHistory), for: .touchDown)
        
        self.gameStartButton.setTitle("Press to Start")
        self.gameStartButton.label.font = UIFont.systemFont(ofSize: 30)
        self.gameStartButton.addTarget(self, action: #selector(startGame), for: .touchDown)
        
        initNumberButtons()
    }
    
    func initNumberButtons() {
        let shuffeldArray = sortedArray.shuffled()
        
        var count = 0
        
        for row in self.numberStackView.subviews {
            for button in row.subviews {
                guard let myButton = button as? MyButton else {
                    return
                }
                
                let buttonFunction = buttonFunctionMaker(index: shuffeldArray[count], button: myButton)
                let buttonAction = Action(action: buttonFunction)
                
                myButton.addTarget(buttonAction, action: #selector(buttonAction.action), for: .touchDown)
                
                myButton.setTitle(String(shuffeldArray[count]))
                myButton.label.font = UIFont.systemFont(ofSize: 16)
                myButton.alpha = 1
                myButton.buttonState = .isNormal
                
                count = count + 1
            }
        }
    }
    
    func test(_ button: MyButton) {
        
    }
    
    //MARK: Segue functions
    func gotoHome() {
        navigationController?.popViewController(animated: true)
    }
    
    func gotoHistory() {
        performSegue(withIdentifier: "history", sender: nil)
    }
    
    //MARK: Game functions
    func startGame() {
        self.isStartGame = true
        currentNumber = 1
        
        currRecord.text = "--:--:--"
        startDate = Date()
        startTimer()
    }
    
    func resetGame() {
        self.isStartGame = false
        stopTimer()
        initNumberButtons()
    }
    
    func buttonFunctionMaker(index: Int, button: MyButton) -> () -> () {
        func checkNumber() {
            guard currentNumber == index else {
                animateClickFail(button)
                print("땡! 1.5초 증가합니다. 현재 숫자 \(currentNumber)")
                return
            }
            
            print("정답! \(currentNumber)")
            
            animateClickSuccess(button)
            
            guard currentNumber == maxNumber else {
                currentNumber = currentNumber + 1
                return
            }
            
            endGameAlert()
            resetGame()
        }
        
        return checkNumber
    }
    
    func endGameAlert() {
        let alert = UIAlertController(title: "Clear!!", message: "Record: \(currRecord.text!)", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "닉네임을 입력하세요"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            let nickName = alert!.textFields![0].text!
            let currentRecord = self.currRecord.text!
            
            let df = DateFormatter()
            df.dateFormat = "mm:ss:SS"
            
            let highRecordItem = FileUtils.getHighScoreItem()
            FileUtils.appendItem2Data(item: RecordItem(nickName: nickName, record: currentRecord))
            
            guard highRecordItem != nil else {
                self.highRecord.text = "\(nickName) : \(currentRecord)"
                return
            }
            
            let highRecordDate = df.date(from: highRecordItem!.record)
            let currRecordDate = df.date(from: self.currRecord.text!)
            let delta = currRecordDate!.timeIntervalSince(highRecordDate!)
            
            guard delta < 0 else {
                return
            }
            
            self.highRecord.text = "\(nickName) : \(currentRecord)"
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Timer
    func startTimer () {
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(0.01),
            target      : self,
            selector    : #selector(self.recordTimestamp),
            userInfo    : nil,
            repeats     : true)
    }
    
    func stopTimer() {
        timer!.invalidate()
    }
    
    func recordTimestamp() {
        let d = Date()
        let df = DateFormatter()
        let delta = d.timeIntervalSince(startDate)
        let deltaDate = Date(timeIntervalSinceReferenceDate: delta)
        
        df.dateFormat = "mm:ss:SS"
        currRecord.text = df.string(from: deltaDate)
    }
    
    
    //MARK: Animation
    func animateClickFail(_ target: MyButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            target.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 18)
        }, completion: { (finished) -> Void in
            target.transform = CGAffineTransform(rotationAngle: 0)
        })
    }
    
    func animateClickSuccess(_ target: MyButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            target.alpha = 0
        }, completion: nil)
    }
}
