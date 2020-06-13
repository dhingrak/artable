//
//  AddEditProductVC.swift
//  ArtableAdmin
//
//  Created by Kunal Dhingra on 2020-06-12.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addProductBtn: RoundedButton!
    
    //Variables
    
    var selectedCategory: Category!
    var productToEdit: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTouchesRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productNameTxt.text = product.name
            productDescTxt.text = product.productDescription
            productPriceTxt.text = String(product.price)
            addProductBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: product.imageUrl) {
                productImgView.contentMode = .scaleToFill
                productImgView.kf.setImage(with: url)
                
            }
        }
        
    }
    
    @objc func imageTapped() {
        
        // Launch the image picker
        launchImgPicker()
    }
    
    @IBAction func addProductClicked(_ sender: Any) {
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        
        // Checking for the empty fields
        
        guard let image = productImgView.image,
            let productName = productNameTxt.text, productName.isNotEmpty,
            let productDesc = productDescTxt.text, productDesc.isNotEmpty,
            let price = productPriceTxt.text, price.isNotEmpty,
            let productPrice = Double(price)
            else {
                simpleAlert(title: "Error", msg: "Please fill all the fields")
                return
        }
        
        
        activityIndicator.startAnimating()
        
        // Step 1: Turn the image into Data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create a storage image reference -> Location in the firestorage
        let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
        
        // Step 3: Set the metadata
        let metadata = StorageMetadata()
        metadata.contentType = ("image/jpeg")
        
        // Step 4: Upload the data
        imageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            
            // Step 5: Once the image is uploaded, retrieve the downloaded URL
            
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image URL")
                    return
                }
                
                guard let url = url else { return }
                print(url)
                
                // Step 6: Uplaod new product document to the firestore products collection
                
                self.uploadDocument(url: url.absoluteString)
            }
        }
    }
    
    func uploadDocument(url: String) {
        
        var docRef: DocumentReference!
        var product = Product.init(name: productNameTxt.text!,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: Double(productPriceTxt.text!)!,
                                   productDescription: productDescTxt.text,
                                   imageUrl: url)
        
        if let productToEdit = productToEdit {
            // Editing an exisitng product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        }
        else {
            // Adding a new product
            print("Adding a new product")
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
            print(product.id)
        }
        
        
        let data = Product.modelToData(product: product)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload new product to firestore")
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
        self.activityIndicator.stopAnimating()
    }
    
}

extension AddEditProductVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
