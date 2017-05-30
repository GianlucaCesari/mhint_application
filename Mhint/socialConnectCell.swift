//
//  socialConnectCell.swift
//  Mhint
//
//  Created by Andrea Merli on 30/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
//
//  cellEditProfile.swift
//  Mhint
//
//  Created by Andrea Merli on 09/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellEditSocial: UICollectionViewCell {
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

class CustomCellEditSocial: BaseCellEditSocial {
    
    var titleTextView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        titleView.text = "[text]"
        titleView.textColor = .black
        return titleView
    }()
    
    var img: UIImageView = {
        var titleView: UIImageView!
        let img = UIImage(named: "facebook")
        titleView = UIImageView(image: img)
        return titleView
    }()
    
    var switchSection: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.isOn = false
        switchDemo.alpha = 1
        switchDemo.setOn(true, animated: false)
        switchDemo.onTintColor = GlobalColor().greenSea
        return switchDemo
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(img)
        self.addSubview(titleTextView)
        self.addSubview(switchSection)
    }
    
}
