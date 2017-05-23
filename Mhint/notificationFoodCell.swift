//
//  notificationFoodCell.swift
//  Mhint
//
//  Created by Andrea Merli on 23/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import SwiftyGif
import UIKit

class BaseCellChooseNotificationFood: UICollectionViewCell {
    
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

class CustomCellChooseNotificationFood: BaseCellChooseNotificationFood {
    
    var checkImageBtn: UIImageView = {
        var imageIngredient: UIImageView!
        let img = UIImage(named: "check-false")
        imageIngredient = UIImageView(image: img)
        return imageIngredient
    }()
    
    let titleNotification: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "AvenirLTStd-Heavy", size: 13)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(checkImageBtn)
        
        self.addSubview(titleNotification)
    }
    
}

