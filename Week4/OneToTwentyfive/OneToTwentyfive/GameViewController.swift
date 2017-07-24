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
    
    var sortedArray: [Int] = []
    var shuffeldArray: [Int] = []
    var currentNumber: Int = 1
    
    var isStartGame: Bool = false {
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
        
        self.homeButton.setTitle("Home")
        self.homeButton.label.font = UIFont.systemFont(ofSize: 22)
        self.homeButton.addTarget(self, action: #selector(gotoHome), for: .touchDown)
        
        self.historyButton.setTitle("History")
        self.historyButton.label.font = UIFont.systemFont(ofSize: 22)
        self.historyButton.addTarget(self, action: #selector(gotoHistory), for: .touchDown)
        
        self.gameStartButton.setTitle("Press to Start")
        self.gameStartButton.label.font = UIFont.systemFont(ofSize: 30)
        self.gameStartButton.addTarget(self, action: #selector(startGame), for: .touchDown)
        
        for i in 1...25 {
            sortedArray.append(i)
        }
        
        shuffeldArray = sortedArray.shuffled(arr: sortedArray)
        
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
                
                count = count + 1
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func gotoHome() {
        navigationController?.popViewController(animated: true)
    }
    
    func gotoHistory() {
        performSegue(withIdentifier: "history", sender: nil)
    }
    
    func startGame() {
        self.isStartGame = true
    }
    
    func buttonFunctionMaker(index: Int, button: MyButton) -> () -> () {
        
        func checkNumber() {
            if(currentNumber == index) {
                button.alpha = 0
                print("정답! \(currentNumber)")
                currentNumber = currentNumber + 1
            } else {
                print("땡! 1.5초 증가합니다. 현재 숫자 \(currentNumber)")
            }
        }
        
        return checkNumber
    }
    
}
