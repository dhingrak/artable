//
//  Extensions.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-07.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

