//
//  RegisterVC.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-07.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passCheckImg: UIImageView!
    
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Make it so when the password matched, the checkbox turns green.
        
        guard let passTxt = passwordTxt.text else { return }
        
        
        if textField == confirmPassTxt {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPassTxt.text = ""
            }
        }
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
        }
        else {
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
        }
    }
    @IBAction func registerClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty ,
            let username = usernameTxt.text, username.isNotEmpty ,
            let password = passwordTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out the fields")
                return
        }
        
        guard let confirmPass = confirmPassTxt.text , confirmPass == password else {
            simpleAlert(title: "Error", msg: "Passwords do not match")
            return
        }
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error)
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
        
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                debugPrint(error)
//                return
//            }
//
//            self.activityIndicator.stopAnimating()
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
}
