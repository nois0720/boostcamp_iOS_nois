//
//  LoginViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 8. 1..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: -Properties
    @IBOutlet weak var photoTitleTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDescTextView: UITextView!
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoTitleTextField.delegate = self
        photoDescTextView.delegate = self
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        return
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        return
    }
    
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
    
    
    func postImage(photo: UploadPhoto, completion: @escaping (UploadResult) -> Void) {
        /*
         "image_title" : <String : 이미지 제목>,
         "image_desc" : <String : 이미지 설명 - Optional>,
         "image_data" : <binary data : 이미지 파일 데이터>
        */
        
        guard let image = photo.image,
            let imageData = UIImagePNGRepresentation(image) else {
            return
        }
        
        let dataString = imageData.base64EncodedString(options: .lineLength64Characters)
        let dictionaryForJson: [String : Any] = ["image_title": "\(photo.title)",
            "image_desc":"\(photo.desc)",
            "image_data":"\(dataString)"]
        
        let url = ImageBoardAPI.postURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionaryForJson,
                                                      options: .prettyPrinted) {
            request.httpBody = jsonData
        }
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processUploadRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    
    func processUploadRequest(data: Data?, error: Error?) -> UploadResult {
        guard let jsonData = data else {
            return .Failure(error!)
        }
        
        if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
            print(jsonString)
        }
        
        return ImageBoardAPI.photoFromJsonData(data: jsonData)
    }
    
    //MARK: -Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let title = photoTitleTextField.text, !title.isEmpty,
            let desc = photoDescTextView.text, !desc.isEmpty,
            let image = photoImageView?.image else {
                let alertTitle = "업로드 실패"
                let alertMessage = "모든 항목을 입력해주세요"
                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        let photoForUpload = UploadPhoto(title: title, desc: desc)
        photoForUpload.image = image
        
        postImage(photo: photoForUpload) { (result) in
            print(result)
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
