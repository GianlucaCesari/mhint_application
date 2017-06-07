//
//  cellEmergency.swift
//  Mhint
//
//  Created by Andrea Merli on 06/06/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellEmergency: UICollectionViewCell {
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

class CustomCellEmergency: BaseCellEmergency {
    
    var titleEmergency: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Heavy", size: 12)
        titleView.backgroundColor = GlobalColor().backgroundCollectionView
        titleView.textColor = .black
        titleView.alpha = 0
        return titleView
    }()
    var descriptionEmergency: UITextView = {
        let titleView = UITextView()
        titleView.textColor = .black
        titleView.layoutMargins.left = -10
        titleView.isEditable = false
        titleView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 13)
        titleView.backgroundColor = GlobalColor().backgroundCollectionView
        titleView.isUserInteractionEnabled = false
        titleView.alpha = 0
        return titleView
    }()
    var peopleRequestEmergency: UILabel = {
        let titleView = UILabel()
        titleView.textColor = .darkGray
        titleView.font = UIFont(name: "AvenirLTStd-Light", size: 12)
        titleView.backgroundColor = GlobalColor().backgroundCollectionView
        titleView.alpha = 0
        return titleView
    }()
    
    //BUTTON
    var btnOk: UIButton = {
        var btn = UIButton()
        let img = UIImage(named: "ok")
        btn.setImage(img, for: .normal)
        btn.alpha = 0
        return btn
    }()
    var btnNo: UIButton = {
        var btn = UIButton()
        let img = UIImage(named: "unlike")
        btn.setImage(img, for: .normal)
        btn.alpha = 0
        return btn
    }()
    var btnMaps: UIButton = {
        var btn = UIButton()
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.darkGray, for: .normal)
        btn.setTitle("View in map", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirLTStd-Light", size: 12)
        btn.alpha = 0
        return btn
    }()
    
    //DIVIDE EMERGENCY
    var titleTextViewDivide: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Heavy", size: 11)
        titleView.addTextSpacing()
        titleView.text = "[divide]"
        titleView.textColor = .black
        titleView.alpha = 0
        return titleView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(titleEmergency)
        self.addSubview(descriptionEmergency)
        self.addSubview(peopleRequestEmergency)
        
        self.addSubview(btnOk)
        self.addSubview(btnNo)
        self.addSubview(btnMaps)
        
        self.addSubview(titleTextViewDivide)
    }
    
}
