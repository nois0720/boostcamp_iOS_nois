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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGameButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func initGameButtons() {
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
        let shuffeldArray = sortedArray.shuffled(arr: sortedArray)
        
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
    
    func gotoHome() {
        navigationController?.popViewController(animated: true)
    }
    
    func gotoHistory() {
        FileUtils.read(fileName: "test")
        performSegue(withIdentifier: "history", sender: nil)
    }
    
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
                print("땡! 1.5초 증가합니다. 현재 숫자 \(currentNumber)")
                return
            }
            
            print("정답! \(currentNumber)")
            
            button.alpha = 0
            
            guard currentNumber == maxNumber else {
                currentNumber = currentNumber + 1
                return
            }
            
            resetGame()
            
            let alert = UIAlertController(title: "Clear!!", message: "Record: \(currRecord.text!)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField { (textField) in
                textField.placeholder = "닉네임을 입력하세요"
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: ({(alertAction) in
                let df = DateFormatter()
                df.dateFormat = "mm:ss:SS"
                
                let highRecordDate = df.date(from: self.highRecord.text!)
                
                guard highRecordDate != nil else {
                    self.highRecord.text = self.currRecord.text!
                    return
                }
                
                let currRecordDate = df.date(from: self.currRecord.text!)
                let delta = currRecordDate!.timeIntervalSince(highRecordDate!)
                
                guard delta < 0 else {
                    return
                }
                
                self.highRecord.text = self.currRecord.text!
            })))
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return checkNumber
    }
    
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
}
