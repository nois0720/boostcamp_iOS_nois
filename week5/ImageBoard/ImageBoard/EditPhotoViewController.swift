//
//  detailPhotoViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 2..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class EditPhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var authorNicknameLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deletePhotoBarButtonItem: UIBarButtonItem!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.image = photo.image
        dateCreatedLabel.text = ImageBoardAPI.dateFormatStringFromDate(date: photo.dateCreated)
        authorNicknameLabel.text = photo.nickname
        descTextView.text = photo.desc
        
        // 실제 이미지 받아오는 작업 여기서 할것.
        
        descTextView.isEditable = false
    }
    
    @IBAction func editPhoto(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditPhoto", sender: nil)
    }
    
    @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
        
    }
}
