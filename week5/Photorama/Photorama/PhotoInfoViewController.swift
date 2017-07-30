//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoStore.fetchImageForPhoto(photo: photo) {
            (result) in
            
            switch result {
            case let .Success(image):
                OperationQueue.main.addOperation() {
                    self.imageView.image = image
                }
            case let .Failure(error):
                print("error fetching image for photo: \(error)")
            }
        }
    }
    
}
