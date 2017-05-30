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
    
    override func setupViews() {
        super.setupViews()
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
        rect.layer.masksToBounds = true
        
        let shadowSquareColor : UIColor = UIColor.black
        rect.layer.shadowColor = shadowSquareColor.cgColor
        rect.layer.shadowOpacity = 0.8
        rect.layer.shadowOffset = CGSize.zero
        rect.layer.shadowRadius = 10
        
        return rect
    }()
    
    override func setupViews() {
        super.setupViews()
        self.addSubview(backgroundV)
        self.addSubview(titleTextView)
    }
    
}

