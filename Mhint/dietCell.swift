//
//  dietCell.swift
//  Mhint
//
//  Created by Andrea Merli on 20/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import SwiftyGif
import UIKit

class BaseCellChooseDiet: UICollectionViewCell {
    
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

class CustomCellChooseDiet: BaseCellChooseDiet {
    
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
    
    let titleDiet: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AvenirLTStd-Heavy", size: 10)
        return label
    }()
    
    let calorieDiet: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AvenirLTStd-Light", size: 12)
        return label
    }()
    
    let ingridientDiet: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.alpha = 0.6
        label.font = UIFont(name: "AvenirLTStd-Medium", size: 13)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(loadingBackground)
        self.addSubview(imageIngredientBackground)
        self.addSubview(overlayImageButton)
        
        self.addSubview(titleDiet)
        self.addSubview(calorieDiet)
        self.addSubview(ingridientDiet)
    }
    
}
