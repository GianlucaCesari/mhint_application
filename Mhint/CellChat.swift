//
//  CellChat.swift
//  Mhint
//
//  Created by Andrea Merli on 07/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        self.backgroundColor = .clear
    }
    
}

class ChatControllerCell: BaseCell {
    
    let titleTextView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 10)
        titleView.text = "[title]"
        return titleView
    }()
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AvenirLTStd-Heavy", size: 24)
        textView.text = "[message]"
        textView.backgroundColor = UIColor.clear
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let roundColor: UIView = {
        let roundeView = UIView()
        roundeView.layer.cornerRadius = 10
        roundeView.layer.masksToBounds = true
        return roundeView
    }()
    
    let btnLink: UIButton = {
        let btn = UIButton()
        
        btn.alpha = 0
        
        btn.backgroundColor = .white
        btn.layer.masksToBounds = false
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 14)
        
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 6.0
        
        return btn
    }()
    
    let imgNeed: UIImageView = {
        let img: UIImageView!
        img = UIImageView(image: UIImage(named: "default"))
        img.alpha = 0
        img.layer.masksToBounds = true
        img.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        img.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        img.layer.shadowOpacity = 1.0
        img.layer.shadowRadius = 6.0
        return img
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.addSubview(btnLink)
        self.addSubview(imgNeed)
        
        self.addSubview(roundColor)
        self.addSubview(titleTextView)
        self.addSubview(messageTextView)
    }
    
}


//HEIGHT/WEIGHT
class BaseCellHeight: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        self.backgroundColor = .clear
    }
    
}
class ChatControllerCellHeight: BaseCellHeight {
    
    let titleTextView: UILabel = {
        let titleView = UILabel()
        titleView.font = UIFont(name: "AvenirLTStd-Medium", size: 13)
        titleView.text = "ciao"
        titleView.textColor = .black
        return titleView
    }()
    
    let backgroundV: UIView = {
       let rect = UIView()
        rect.backgroundColor = .white
        rect.layer.borderWidth = 0
        rect.layer.cornerRadius = GlobalSize().heightScreen*0.035
        rect.layer.masksToBounds = false
        
        rect.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        rect.layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        rect.layer.shadowOpacity = 1.0
        rect.layer.shadowRadius = 6.0
        
        return rect
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(backgroundV)
        self.addSubview(titleTextView)
    }
    
}

