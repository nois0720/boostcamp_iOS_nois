//
//  detailPhotoViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 2..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var authorNicknameLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var deletePhotoBarButtonItem: UIBarButtonItem!
    var photo: Photo!
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = photo.title
        photoImage.image = photo.image
        dateCreatedLabel.text = ImageBoardAPI.dateFormatStringFromDate(date: photo.dateCreated)
        authorNicknameLabel.text = photo.nickname
        descTextView.text = photo.desc
        
        // 실제 이미지 받아오는 작업 여기서 할것.
        
        descTextView.isEditable = false
        
        guard photo.authorId == currentUser.id else {
            editBarButtonItem.isEnabled = false
            deletePhotoBarButtonItem.isEnabled = false
            editBarButtonItem.tintColor = UIColor.clear
            deletePhotoBarButtonItem.tintColor = UIColor.clear
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let editViewController = segue.destination as? EditPhotoViewController else {
            return
        }
        
        editViewController.photo = self.photo
    }
    
    @IBAction func deletePhoto(_ sender: UIBarButtonItem) {
        ImageBoardAPI.deleteImage(id: photo.id) { (result) in
            OperationQueue.main.addOperation({
                switch result {
                case let .success(photo):
                    print(photo)
                    self.navigationController?.popViewController(animated: true)
                case let .failure(error):
                    let alert = UIAlertController(title: "삭제 실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
}
