//
//  ImageBoardCell.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 31..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class ImageBoardCell: UITableViewCell {
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        
//        updateWithImage(image: nil)
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        updateWithImage(image: nil)
//    }
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            thumbImage.image = imageToDisplay
        } else {
            thumbImage.image = nil
        }
    }
    
}
