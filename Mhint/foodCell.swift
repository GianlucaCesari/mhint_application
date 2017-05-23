//
//  foodCell.swift
//  Mhint
//
//  Created by Andrea Merli on 19/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import SwiftyGif
import UIKit

class BaseCellChooseIngredient: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        self.backgroundColor = .white
    }
    
}

class CustomCellChooseIngredient: BaseCellChooseIngredient {
    
    var loadingBackground: UIImageView = {
        var imageIngredient = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
        return imageIngredient
    }()
    
    var overlayImageButton: UIImageView = {
        var imageIngredient: UIImageView!
        let img = UIImage(named: "overlayIngredientImage0")
        imageIngredient = UIImageView(image: img)
        imageIngredient.layer.cornerRadius = 5
        imageIngredient.layer.masksToBounds = true
        return imageIngredient
    }()
    
    var imageIngredientBackground: UIImageView = {
        var imageIngredient: UIImageView!
        let img = UIImage(named: "default")
        imageIngredient = UIImageView(image: img)
        imageIngredient.layer.cornerRadius = 5
        imageIngredient.layer.masksToBounds = true
        return imageIngredient
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(loadingBackground)
        self.addSubview(imageIngredientBackground)
        self.addSubview(overlayImageButton)
    }
    
}
