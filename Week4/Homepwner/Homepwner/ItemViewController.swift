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
    
    @IBAction func addNewItem(sender: AnyObject) {
        let newItem = itemStore.createItem()
        
        guard let index = itemStore.allItems.index(of: newItem) else {
            return
        }
        
        let indexPath = NSIndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
        addFooter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.updateLabels()
        
        let item = itemStore.allItems[indexPath.row]

        cell.nameLabel?.text = item.name
        cell.serialNumberLabel?.text = item.serialNumber
        cell.valueLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel,
                                             handler: nil)
            
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Remove",
                                             style: .destructive,
                                             handler: { (action) -> Void in
                                                self.itemStore.removeItem(item)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            ac.addAction(deleteAction)
            present(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowItem" else {
            return
        }
        
        guard let row = tableView.indexPathForSelectedRow?.row else {
            return
        }
        
        let item = itemStore.allItems[row]
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.item = item
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
}
