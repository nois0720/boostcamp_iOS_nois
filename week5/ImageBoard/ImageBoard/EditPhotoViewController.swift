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
    @IBOutlet weak var photoTitle: UITextField!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var authorNicknameLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTitle.text = photo.title
        photoImage.image = photo.image
        dateCreatedLabel.text = ImageBoardAPI.dateFormatStringFromDate(date: photo.dateCreated)
        authorNicknameLabel.text = photo.nickname
        descTextView.text = photo.desc
    }
    
    @IBAction func cancelEditPhoto(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func endEditPhoto(_ sender: UIBarButtonItem) {
        
        guard let title = photoTitle.text,
            let desc = descTextView.text else {
                return
        }
        
        let photoForEdit = PhotoForUpload(title: title, desc: desc)
        photoForEdit.image = photo.image
        
        ImageBoardAPI.editImage(photoId: photo.id, photo: photoForEdit) { (result) in
            OperationQueue.main.addOperation({
                switch result {
                case let .success(photo):
                    print(photo)
                    self.navigationController?.popViewController(animated: true)
                case let .failure(error):
                    let alert = UIAlertController(title: "수정 실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
}
