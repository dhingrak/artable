//
//  AddEditCategoryVC.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-11.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryVC: UIViewController {
    
    var categoryToEdit: Category?
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var categoryImg: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTaped))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // Populate the data if the category mode is editing
        
        if let category = categoryToEdit {
            nameTxt.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imageTaped() {
        // Launch the image picker
        launchImgPicker()
    }
    
    @IBAction func addCategoryClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
    }
    
    func uploadImageThenDocument() {
        guard let image = categoryImg.image,
            let categoryName = nameTxt.text, categoryName.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Must add category image and name")
                activityIndicator.stopAnimating()
                return
        }
        
        // Step 1: Turn the image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        // Step 2: Create an storage image reference -> Location in the fireStorage
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
        
        // Step 3: Set the metadata
        let metadata = StorageMetadata()
        metadata.contentType = ("image/jpeg")
        
        // Step 4: Upload the data
        imageRef.putData(imageData, metadata: metadata) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image")
                return
            }
            
            // Step 5: Once the image is uploaded, retrieve the downloaded url
            
            imageRef.downloadURL { (url, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "Unable to retrieve image URL")
                    return
                }
                
                guard let url = url else { return }
                // Step 6: Uplaod new category document to the firestore categoris collection
                
                self.uploadDocument(url: url.absoluteString)
            }
        }
    }
    
    func uploadDocument(url: String) {
        
        var docRef: DocumentReference!
        var category = Category.init(name: nameTxt.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            // Editing the existing document
            
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        }
        else {
            // Adding a new Category
            docRef = Firestore.firestore().collection("categories").document()
            category.id = docRef.documentID
        }
       
        
        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "Unbale to upload new categoty to firestore")
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


extension AddEditCategoryVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {return}
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
