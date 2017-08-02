//
//  SignupViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: -Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emailTextField.tag = 0
        nicknameTextField.tag = 1
        passwordTextField.tag = 2
        passwordCheckTextField.tag = 3
        
        emailTextField.delegate = self
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: -Actions
    @IBAction func signUp(_ sender: UIButton) {
        guard let emailText = emailTextField.text, !emailText.isEmpty,
            let nicknameText = nicknameTextField.text, !nicknameText.isEmpty,
            let passwordText = passwordTextField.text, !passwordText.isEmpty,
            let passwordCheckText = passwordCheckTextField.text, !passwordCheckText.isEmpty else {
                alertMessage(title: "회원가입 실패", message: "모든 항목을 입력해주세요")
                return
        }
        
        guard passwordText == passwordCheckText else {
            alertMessage(title: "회원가입 실패", message: "패스워드가 일치하지 않습니다!")
            return
        }
        
        let userInfo = User(email: emailText, password: passwordText, nickname: nicknameText)
        ImageBoardAPI.requestSignup(userInfo: userInfo) { (result) in
            OperationQueue.main.addOperation({
                switch result {
                case let .Success(userInfo):
                    let alertTitle = "회원가입 성공"
                    let alertMessage = "email: \(userInfo.email)\nnickname: \(userInfo.nickname ?? "")"
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                        (alertAction) in
                        
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                case let .Failure(error):
                    let alertTitle = "회원가입 실패"
                    let alertMessage = "Error Message: \(error)"
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
