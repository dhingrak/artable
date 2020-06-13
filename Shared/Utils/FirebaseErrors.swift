//
//  FirebaseErrors.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-08.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import Firebase

extension Auth {
    func handleFireAuthError(error: Error, vc: UIViewController) {
        
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another Email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support team."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again"
        case .weakPassword:
            return "Your password is weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your emal or password is invalid."
            
        default:
            return "Sorry, something went wrong "
        }
    }
}

extension Firestore {
    var categories : Query {
        return collection("categories").order(by: "timeStamp", descending: true)
    }
    
    func products(category: String) -> Query {
        return collection("products").whereField("category", isEqualTo: category)
    }

}

