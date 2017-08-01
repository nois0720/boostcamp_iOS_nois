//
//  ImageTableViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 31..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ImageTableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var photoStore: PhotoStore!
    var authenticationCenter: AuthenticationCenter!
    let imageBoardDataSource = ImageBoardDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = imageBoardDataSource
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        photoStore.fetchBoardPhotoItems { (result) in
            OperationQueue.main.addOperation({
                switch result {
                case let .Success(photos):
                    print("Successfully found \(photos.count) photos.")
                    self.imageBoardDataSource.originPhotos = photos
                    self.imageBoardDataSource.photos = photos
                case let .Failure(error):
                    self.imageBoardDataSource.originPhotos.removeAll()
                    self.imageBoardDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let photo = imageBoardDataSource.photos[indexPath.row]
        
        let imageBoardCell = cell as! ImageBoardCell
        
        imageBoardCell.titleLabel.text = photo.title
        imageBoardCell.authorLabel.text = photo.nickname
        imageBoardCell.dateLabel.text = ImageBoardAPI.dateFormatStringFromDate(date: photo.dateCreated)
        
        photoStore.fetchThumbnailPhotoForImage(photo: photo) { (result) in
            OperationQueue.main.addOperation() {
                guard let imageIndex = self.imageBoardDataSource.photos.index(where: {
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
    
    @IBAction func viewOptionSetting(_ sender: Any) {
        let ac = UIAlertController(title: "", message: "정렬", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "내 게시물만 보기", style: .default, handler: {
            (action) in
            self.imageBoardDataSource.photos = self.imageBoardDataSource.photos.filter({
                (photo) -> Bool in
                
                photo.nickname == self.authenticationCenter.currentUser?.nickname
            })
        })
        
        let action2 = UIAlertAction(title: "전체 게시물 보기", style: .default, handler: {
            (action) in
            
            self.imageBoardDataSource.photos = self.imageBoardDataSource.originPhotos
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        ac.addAction(action1)
        ac.addAction(action2)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
}
