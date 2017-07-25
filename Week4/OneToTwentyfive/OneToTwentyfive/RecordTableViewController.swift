//
//  RecordTableViewController.swift
//  OneToTwentyfive
//
//  Created by Yoo Seok Kim on 2017. 7. 25..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class RecordTableViewController: UITableViewController {
    
    var recordStore: RecordStore!
    
    @IBOutlet weak var backButton: MyButton!
    @IBOutlet weak var resetButton: MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle("◀︎")
        resetButton.setTitle("Reset")
        backButton.addTarget(self, action: #selector(goBack), for: .touchDown)
        resetButton.addTarget(self, action: #selector(resetRecord), for: .touchDown)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordStore.allRecordItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
        
        let item = recordStore.allRecordItems[indexPath.row]
        
        cell.textLabel?.text = "\(item.record)"
        cell.detailTextLabel?.text = "\(item.nickName) (\(item.dateCreated))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = recordStore.allRecordItems[indexPath.row]
            
            recordStore.removeRecordItem(recordItem: item)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func resetRecord() {
        recordStore.removeAllItem()
        tableView.reloadData()
    }
    
}
