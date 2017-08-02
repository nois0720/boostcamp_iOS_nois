//
//  LoginViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 1..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var photoTitleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDescTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTitleTextField.delegate = self
        photoDescTextView.delegate = self
    }
    
    //MARK: -Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let title = photoTitleTextField.text, !title.isEmpty,
            let desc = photoDescTextView.text, !desc.isEmpty,
            let image = photoImageView?.image else {
                let alert = UIAlertController(title: "업로드 실패", message: "모든 항목을 입력해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let photoForUpload = PhotoForUpload(title: title, desc: desc)
        photoForUpload.image = image
        
        ImageBoardAPI.postImage(photo: photoForUpload) { (result) in
            switch result {
            case let .Success(photo):
                print(photo)
                self.navigationController?.popViewController(animated: true)
            case let .Failure(error):
                let alert = UIAlertController(title: "업로드 실패", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func backgroundTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension UploadViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        return
    }
}

extension UploadViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        return
    }
}

extension UploadViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
