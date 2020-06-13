//
//  AdminProductsVC.swift
//  ArtableAdmin
//
//  Created by Kunal Dhingra on 2020-06-12.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {

    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let editCategoryBtn = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        
        let newProductBtn = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        
        
        navigationItem.setRightBarButtonItems([editCategoryBtn, newProductBtn], animated: false)
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
        
    @objc func newProduct() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Editing product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destination = segue.destination as? AddEditProductVC {
                destination.selectedCategory = category
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            if let destination = segue.destination as? AddEditCategoryVC {
                destination.categoryToEdit = category
            }
        }
    }
}
