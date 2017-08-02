//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Yoo Seok Kim on 2017. 7. 29..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    @IBOutlet var collectionView: UICollectionView!
    
    var photoStore: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        photoStore.fetchRecentPhotos { (photosResult) -> Void in
            OperationQueue.main.addOperation({
                switch photosResult {
                case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                case let .Failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.collectionView.reloadSections(IndexSet(integer: 0))
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowPhoto",
            let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first else {
                return
        }
        
        let photo = photoDataSource.photos[selectedIndexPath.row]
        let destinationVC = segue.destination as! PhotoInfoViewController
        
        destinationVC.photo = photo
        destinationVC.photoStore = photoStore
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        photoStore.fetchImageForPhoto(photo: photo) {
            (result) -> Void in
            
            OperationQueue.main.addOperation() {
                guard let photoIndex = self.photoDataSource.photos.index(where: {
                    $0 == photo
                }) else {
                    return
                }
                
                let photoIndexPath = IndexPath(row: photoIndex, section: 0)
                
                guard let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell else {
                    return
                }
                
                cell.updateWithImage(image: photo.image)
            }
        }
    }
    
    @IBAction func editImage(_ sender: Any) {
        
    }
}
