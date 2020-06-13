//
//  ViewController.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-06.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit
import Firebase


class HomeVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var categories = [Category]()
    var selectedCategory: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupCollectionView()
        setupInitialAnonymousUser()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        guard let font = UIFont(name: "futura", size: 26) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:  UIColor.white ,
            NSAttributedString.Key.font: font
        ]
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            print("Inside anonymous")
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCategoriesListener()
        if let user = Auth.auth().currentUser , !user.isAnonymous {
            loginOutBtn.title = "LogOut"
        } else {
            loginOutBtn.title = "Login"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    
    func setCategoriesListener() {
        listener = db.categories.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                default:
                    return
                }
            })
        })
    }
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        if change.oldIndex == change.newIndex {

            // Item changed but stays at the same index in firestore
            let index = Int(change.oldIndex)
            categories[index] = category
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
        else {
            // Both item and position changed in the firestore
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex , section: 0)])
    }
    
    fileprivate func presentLoginController() {
          let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
          let controller = storyboard.instantiateViewController(identifier: StoryboardId.LoginVC)
          present(controller, animated: true, completion: nil)
    }
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else {return}
        if user.isAnonymous {
            presentLoginController()
        }
        else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                    self.presentLoginController()
                }
            }catch {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.3
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
//        print("Inside selected category")
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        }
    }
    
    
    
}



// This code is for reference purposes

//func fetchCollection() {
//        let collectionRef = db.collection("categories")
//
//        listener = collectionRef.addSnapshotListener { (snap, error) in
//            guard let documents = snap?.documents else { return }
//
//            print(snap?.documentChanges.count)
//            self.categories.removeAll()
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category.init(data: data)
//                self.categories.append(newCategory)
//            }
//
//            self.collectionView.reloadData()
//        }
//    }
//    func fetchDocument() {
//        let docRef = db.collection("categories").document("UUTKfWN7nFz6bEXDyrNq")
//
//        docRef.addSnapshotListener { (snap, error) in
//            self.categories.removeAll()
//            guard let data = snap?.data() else { return }
//            let newCategory = Category.init(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
////        docRef.getDocument { (snap, error) in
////            guard let data = snap?.data() else { return }
////            let newCategory = Category.init(data: data)
////            self.categories.append(newCategory)
////            self.collectionView.reloadData()
////        }
//    }
