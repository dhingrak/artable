//
//  ProductCell.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-09.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    
    @IBOutlet weak var productImg: RoundedImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    func configureCell(product: Product) {
        productTitle.text = product.name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: "placeholder")
            productImg.kf.indicatorType = .activity
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.1))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
            
        }
        
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
}
