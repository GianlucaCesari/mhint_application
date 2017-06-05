//
//  CellSettings.swift
//  Mhint
//
//  Created by Andrea Merli on 07/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellSetting: UICollectionViewCell {
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

class CustomCellSetting: BaseCellSetting {
    
    var titleTextView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 16)
        titleView.text = "[text]"
        titleView.textColor = .black
        return titleView
    }()
    
    var titleTextViewDivide: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Heavy", size: 25)
        titleView.text = "[divide]"
        titleView.textColor = .black
        return titleView
    }()
    
    var arrow: UIImageView = {
        var titleView: UIImageView!
        let img = UIImage(named: "arrow")
        titleView = UIImageView(image: img)
        titleView.alpha = 0.8
        return titleView
    }()
    
    var switchSection: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = false
        switchDemo.alpha = 0
        switchDemo.setOn(true, animated: false)
        switchDemo.onTintColor = GlobalColor().greenSea
        return switchDemo
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(titleTextView)
        self.addSubview(titleTextViewDivide)
        self.addSubview(arrow)
        self.addSubview(switchSection)
    }
    
}
