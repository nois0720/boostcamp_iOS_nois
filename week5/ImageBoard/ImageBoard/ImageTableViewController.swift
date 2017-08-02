//
//  ImageTableViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 31..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ImageTableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var photos = [Photo]()
    var originPhotos = [Photo]()
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        ImageBoardAPI.fetchBoardPhotoItems { (result) in
            OperationQueue.main.addOperation({
                switch result {
                case let .Success(photos):
                    print("Successfully found \(photos.count) photos.")
                    self.originPhotos = photos
                    self.photos = photos
                case let .Failure(error):
                    self.originPhotos.removeAll()
                    self.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "PhotoDetail" else {
            return
        }
        
        guard let row = tableView.indexPathForSelectedRow?.row else {
            return
        }
        
        let photo = photos[row]
        let detailPhotoViewController = segue.destination as! DetailPhotoViewController
        detailPhotoViewController.photo = photo
    }
    
    @IBAction func viewOptionSetting(_ sender: Any) {
        let ac = UIAlertController(title: "", message: "정렬", preferredStyle: .actionSheet)
        
        let showMyPhotoAction = UIAlertAction(title: "내 게시물만 보기", style: .default, handler: {
            (action) in
            self.photos = self.photos.filter({ (photo) -> Bool in
                photo.nickname == self.currentUser?.nickname
            })
            self.tableView.reloadData()
        })
        
        let showAllPhotoAction = UIAlertAction(title: "전체 게시물 보기", style: .default, handler: {
            (action) in
            
            self.photos = self.originPhotos
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        ac.addAction(showMyPhotoAction)
        ac.addAction(showAllPhotoAction)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func tapImageBoardCell(_ sender: UITapGestureRecognizer) {
        
    }
}

extension ImageTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        
        let imageBoardCell = cell as! ImageBoardCell
        
        imageBoardCell.titleLabel.text = photo.title
        imageBoardCell.authorLabel.text = photo.nickname
        imageBoardCell.dateLabel.text = ImageBoardAPI.dateFormatStringFromDate(date: photo.dateCreated)
        
        ImageBoardAPI.fetchThumbnailPhotoForImage(photo: photo) { (result) in
            OperationQueue.main.addOperation() {
                guard let imageIndex = self.photos.index(where: {
                    $0 == photo
                }) else {
                    return
                }
                
                let photoIndexPath = IndexPath(row: imageIndex, section: 0)
                
                guard let cell = self.tableView.cellForRow(at: photoIndexPath) as? ImageBoardCell else {
                    return
                }
                
                cell.updateWithImage(image: photo.image)
            }
        }
    }
}


extension ImageTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ImageBoardCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ImageBoardCell
        
        let photo = photos[indexPath.row]
        cell.updateWithImage(image: photo.image)
        
        return cell
    }
}
