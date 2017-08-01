//
//  LoginViewController.swift
//  ImageBoard
//
//  Created by Yoo Seok Kim on 2017. 7. 30..
//  Copyright © 2017년 Nois. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: -Properties
    var authenticationCenter: AuthenticationCenter!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwdTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        emailTextField.tag = 0
        passwdTextField.tag = 1
        
        emailTextField.delegate = self
        passwdTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signupViewController = segue.destination as? SignupViewController {
            signupViewController.authenticationCenter = authenticationCenter
        }
        
        if let imageTableViewController = segue.destination as? ImageTableViewController {
            imageTableViewController.photoStore = PhotoStore()
            imageTableViewController.authenticationCenter = authenticationCenter
        }
    }
    
    //MARK: -Actions
    @IBAction func login(_ sender: UIButton) {
        self.performSegue(withIdentifier: "Login", sender: nil)
        
//        guard let emailText = emailTextField.text, !emailText.isEmpty,
//            let passwdText = passwdTextField.text, !passwdText.isEmpty else {
//                let alertTitle = "로그인 실패"
//                let alertMessage = "모든 항목을 입력해주세요"
//                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                return
//        }
//        
//        let userInfo = User(email: emailText, password: passwdText, nickname: nil)
//        authenticationCenter.requestLogin(userInfo: userInfo) { (result) in
//            OperationQueue.main.addOperation({
//                switch result {
//                case let .Success(userInfo):
//                    self.performSegue(withIdentifier: "Login", sender: nil)
//                case let .Failure(error):
//                    let alertTitle = "로그인 실패"
//                    let alertMessage = "Error Message: \(error)"
//                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            })
//        }
        
    }
}
