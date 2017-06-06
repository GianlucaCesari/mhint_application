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
        return titleView
    }()
    var descriptionEmergency: UILabel = {
        let titleView = UILabel()
        titleView.textColor = .black
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 13)
        titleView.backgroundColor = GlobalColor().backgroundCollectionView
        return titleView
    }()
    var peopleRequestEmergency: UILabel = {
        let titleView = UILabel()
        titleView.textColor = .black
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 14)
        titleView.backgroundColor = GlobalColor().backgroundCollectionView
        return titleView
    }()
    
    //BUTTON
    var btnOk: UIButton = {
        var btn = UIButton()
        let img = UIImage(named: "like")
        btn.setImage(img, for: .normal)
        return btn
    }()
    var btnNope: UIButton = {
        var btn = UIButton()
        let img = UIImage(named: "unlike")
        btn.setImage(img, for: .normal)
        return btn
    }()
    var btnMaps: UIButton = {
        var btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("View in map", for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 14)
        return btn
    }()
    
    //DIVIDE EMERGENCY
    var titleTextViewDivide: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Heavy", size: 25)
        titleView.text = "[divide]"
        titleView.textColor = .black
        return titleView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(titleEmergency)
        self.addSubview(descriptionEmergency)
        self.addSubview(peopleRequestEmergency)
        
        self.addSubview(btnOk)
        self.addSubview(btnNope)
        self.addSubview(btnMaps)
        
        self.addSubview(titleTextViewDivide)
    }
    
}
