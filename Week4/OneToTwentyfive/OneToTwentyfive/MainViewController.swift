//
//  MainViewController.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 24..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
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
        
        self.animateGameTitleLabel()
        
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
    
    func gotoGameView() {
        performSegue(withIdentifier: "game", sender: nil)
    }
    
    func gotoHistoryView() {
        performSegue(withIdentifier: "history", sender: nil)
    }
    
    func animateGameTitleLabel() {
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.gameTitleLabel.transform = self.gameTitleLabel.transform.scaledBy(x: 1.5, y: 1.5)
        }, completion: { (finished) -> Void in
            self.gameTitleLabel.transform = self.gameTitleLabel.transform.scaledBy(x: 2/3, y: 2/3)
        })
    }
    
}
