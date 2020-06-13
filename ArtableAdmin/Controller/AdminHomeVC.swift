//
//  ViewController.swift
//  ArtableAdmin
//
//  Created by Kunal Dhingra on 2020-06-06.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        
        navigationItem.rightBarButtonItem = addCategoryBtn
    }
    
    @objc func addCategory() {
        performSegue(withIdentifier: Segues.toAddEditCategory, sender: self)
    }


}

