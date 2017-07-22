//
//  ViewController.swift
//  Quiz
//
//  Created by Yoo Seok Kim on 2017. 7. 2..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK : Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    //MARK : Models
    let questions: [String] = ["From what is cognac made?",
                               "What is 7+7?",
                               "What is the capital of Vermont?"]
    
    let answer: [String] = ["Grapes",
                             "14",
                             "Montpelier"]
    
    var currQuestionIdx = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currQuestionIdx]
        answerLabel.text = "???"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK : Actions
    @IBAction func nextQuestionButton(_ sender: UIButton) {
        currQuestionIdx += 1;
        
        if(currQuestionIdx == questions.count) {
            currQuestionIdx = 0;
        }
        
        questionLabel.text = questions[currQuestionIdx]
        answerLabel.text = "???"
        
        animateLabelTransitions()
    }
    
    
    @IBAction func showAnswerButton(_ sender: UIButton) {
        answerLabel.text = answer[currQuestionIdx]
    }
}

