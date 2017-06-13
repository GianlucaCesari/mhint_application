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
        self.backgroundColor = GlobalColor().backgroundCollectionView
    }
    
}

class CustomCellChooseHomeDetailsRecipes: BaseCellChooseHomeDetailsRecipes {
    
    let titleSection: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.addTextSpacing()
        label.textAlignment = .center
        label.font = UIFont(name: "AvenirLTStd-Black", size: 11)
        label.backgroundColor = GlobalColor().backgroundCollectionView
        return label
    }()
    
    let lineTitleSection: UIView = {
        var line = UIView()
        line.backgroundColor = .black
        return line
    }()
    
    let descriptionRecipes: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.isEditable = false
        label.isScrollEnabled = false
        label.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        label.backgroundColor = GlobalColor().backgroundCollectionView
        label.textAlignment = .justified
        return label
    }()
    
    
    //TABLE FOR SHOW INGREDIENT
    let labelRow1: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.isEditable = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        label.backgroundColor = GlobalColor().backgroundCollectionView
        label.font = UIFont(name: "AvenirLTStd-Medium", size: 12)
        return label
    }()
    
    let labelRow2: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.isEditable = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        label.backgroundColor = GlobalColor().backgroundCollectionView
        label.font = UIFont(name: "AvenirLTStd-Black", size: 12)
        return label
    }()
    
    let labelRow3: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.isEditable = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        label.backgroundColor = GlobalColor().backgroundCollectionView
        label.font = UIFont(name: "AvenirLTStd-Medium", size: 12)
        return label
    }()
    
    let labelRow4: UITextView = {
        var label = UITextView()
        label.textColor = .black
        label.isEditable = false
        label.isScrollEnabled = false
        label.textAlignment = .left
        label.backgroundColor = GlobalColor().backgroundCollectionView
        label.font = UIFont(name: "AvenirLTStd-Black", size: 12)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(lineTitleSection)
        self.addSubview(titleSection)
        self.addSubview(descriptionRecipes)
        self.addSubview(labelRow1)
        self.addSubview(labelRow2)
        self.addSubview(labelRow3)
        self.addSubview(labelRow4)
    }
    
}
