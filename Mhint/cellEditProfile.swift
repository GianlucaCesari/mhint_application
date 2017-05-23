//
//  cellEditProfile.swift
//  Mhint
//
//  Created by Andrea Merli on 09/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellEditProfile: UICollectionViewCell {
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

class CustomCellEditProfile: BaseCellEditProfile {
    
    var titleTextView: UILabel = {
        let titleView = UILabel()
        titleView.text = "[text]"
        titleView.textColor = .black
        return titleView
    }()
    
    var imageProfile: UIImageView = {
        var titleView: UIImageView!
        let img = UIImage(named: "default")
        titleView = UIImageView(image: img)
        titleView.alpha = 0
        return titleView
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(titleTextView)
        self.addSubview(imageProfile)
    }
    
}
