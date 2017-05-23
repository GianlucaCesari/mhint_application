//
//  eatOutCell.swift
//  Mhint
//
//  Created by Andrea Merli on 22/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellChooseEatOut: UICollectionViewCell {
    
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

class CustomCellChooseEatOut: BaseCellChooseEatOut {
    
    var checkImageBtn: UIImageView = {
        var imageIngredient: UIImageView!
        let img = UIImage(named: "check-false")
        imageIngredient = UIImageView(image: img)
        return imageIngredient
    }()
    
    let titleDiet: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AvenirLTStd-Heavy", size: 13)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(checkImageBtn)
        
        self.addSubview(titleDiet)
    }
    
}
