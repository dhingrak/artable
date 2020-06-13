//
//  LoginVC.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-07.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passtxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty ,
        let password = passtxt.text , password.isNotEmpty else {
            simpleAlert(title: "Error", msg: "Please fill out all fields")
            return
            
        }
        
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self!)
                self?.activityIndicator.stopAnimating()
                return
            }
            self?.activityIndicator.stopAnimating()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }
}
