//
//  MainViewController.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 24..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var playButton: MyButton!
    @IBOutlet weak var historyButton: MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.setTitle("Play")
        playButton.label.font = UIFont.systemFont(ofSize: 22)
        playButton.addTarget(self, action: #selector(gotoGameView), for: .touchDown)
        historyButton.setTitle("History")
        historyButton.label.font = UIFont.systemFont(ofSize: 22)
        historyButton.addTarget(self, action: #selector(gotoHistoryView), for: .touchDown)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func gotoGameView() {
        performSegue(withIdentifier: "game", sender: nil)
    }
    
    func gotoHistoryView() {
        performSegue(withIdentifier: "history", sender: nil)
    }
    
}
