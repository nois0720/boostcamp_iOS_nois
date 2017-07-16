//
//  ItemViewController.swift
//  Homepwner
//
//  Created by Yoo Seok Kim on 2017. 7. 16..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController {
    
    var itemStore: ItemStore!
    let sectionTitles: [String] = ["expensive", "cheap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        addFooter()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let expensiveCount = itemStore.allItems.filter{ $0.valueInDollars >= 50 }.count
        
        switch section {
        case 0:
            return expensiveCount
        case 1:
            return itemStore.allItems.count - expensiveCount
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        let sortedItems = itemStore.allItems.sorted{ $0.valueInDollars > $1.valueInDollars }
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        var row: Int
        
        if indexPath.section == 0 {
            row = indexPath.row
        } else {
            row = indexPath.row + itemStore.allItems.filter{ $0.valueInDollars >= 50 }.count
        }
        
        let item = sortedItems[row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    func addFooter() {
        let footerFrame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40)
        
        let footerView = UIView(frame: footerFrame)
        footerView.backgroundColor = UIColor.orange
        
        let footerLabel = UILabel(frame: footerFrame)
        footerLabel.text = "No More Items!"
        footerLabel.textAlignment = .center
        
        footerView.addSubview(footerLabel)
        tableView.tableFooterView = footerView
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    //        return sectionTitles
    //    }
}
