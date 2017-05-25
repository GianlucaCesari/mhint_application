//
//  listRecipesCell.swift
//  Mhint
//
//  Created by Andrea Merli on 23/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import SwiftyGif
import UIKit

class BaseCellChooseHomeFood: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        self.backgroundColor = .clear
    }
    
}

class CustomCellChooseHomeFood: BaseCellChooseHomeFood {
    
    var loadingBackground: UIImageView = {
        var imageIngredient = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
        return imageIngredient
    }()
    
    var imageRecipes: UIImageView = {
        var imageIngredient: UIImageView!
        let img = UIImage(named: "overlayIngredientImage0")
        imageIngredient = UIImageView(image: img)
        imageIngredient.layer.cornerRadius = 5
        imageIngredient.layer.masksToBounds = true
        return imageIngredient
    }()
    
    var typeMeal: UILabel = {
        var label = UILabel()
        label.addTextSpacing()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AvenirLTStd-Black", size: 13)
        return label
    }()
    
    var descriptionRecipes: UILabel = {
        var label = UILabel()
        label.addTextSpacing()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "AvenirLTStd-Medium", size: 12)
        return label
    }()
    
    let titleDay: UILabel = {
        var label = UILabel()
        label.addTextSpacing()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont(name: "AvenirLTStd-Black", size: 13)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(imageRecipes)
        self.addSubview(typeMeal)
        self.addSubview(descriptionRecipes)
        
        self.addSubview(titleDay)
    }
    
}
