//
//  Product.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-09.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timestamp: Timestamp
    var stock: Int
    
    
    init(
        name: String,
        id: String,
        category: String,
        price: Double,
        productDescription: String,
        imageUrl: String,
        timestamp: Timestamp = Timestamp(),
        stock: Int = 0) {
        
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imageUrl
        self.timestamp = timestamp
        self.stock = stock
    }
    
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timestamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
        
    }
    
    static func modelToData(product: Product) -> [String: Any] {
        let data: [String: Any] = [
            "name": product.name,
            "id": product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDescription,
            "imageUrl": product.imageUrl,
            "timestamp": product.timestamp
        ]
        
        return data
    }
}
