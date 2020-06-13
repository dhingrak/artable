//
//  Constants.swift
//  Artable
//
//  Created by Kunal Dhingra on 2020-06-07.
//  Copyright © 2020 Kunal Dhingra. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
    static let red = #colorLiteral(red: 0.8352941176, green: 0.3921568627, blue: 0.3137254902, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProdcutCell = "ProductCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let toAddEditCategory = "toAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
}
