//
//  HomeDetailsRecipesCell.swift
//  Mhint
//
//  Created by Andrea Merli on 26/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellChooseHomeDetailsRecipes: UICollectionViewCell {
    
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

class CustomCellChooseHomeDetailsRecipes: BaseCellChooseHomeDetailsRecipes {
    
    let titleSection: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.addTextSpacing()
        label.font = UIFont(name: "AvenirLTStd-Heavy", size: 15)
        label.backgroundColor = GlobalColor().backgroundCollectionView
        return label
    }()
    
    let lineTitleSection: UIView = {
        var line = UIView()
        line.backgroundColor = .black
        line.alpha = 0
        return line
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(titleSection)
        self.addSubview(lineTitleSection)
        
    }
    
}

