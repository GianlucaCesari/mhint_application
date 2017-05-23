//
//  Mhint4you.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

//SWIPE
import DMSwipeCards

//GIF
import SwiftyGif

class TeachingController: UIViewController{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    var titleArray = [String]()
    var imageArray = [String]()
    
    private var swipeView: DMSwipeCardsView<String>!
    var currentIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true)
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        let widthCard = GlobalSize().widthScreen*0.72
        let heightCard = GlobalSize().heightScreen*0.5
        
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: GlobalSize().widthScreen*0.14, y: GlobalSize().heightScreen*0.1, width: widthCard, height: heightCard))
            
            let label = UILabel(frame: container.bounds)
            label.textAlignment = .center
            label.backgroundColor = .white
            label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
            label.clipsToBounds = true
            label.layer.cornerRadius = 3
            container.addSubview(label)
            
            let imageLoading = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
            imageLoading.frame = CGRect(x: 0, y: 0, width: widthCard, height: widthCard)
            container.addSubview(imageLoading)
            
            var titleView: UIImageView!
            let img = UIImage(named: "default")
            titleView = UIImageView(image: img)
            titleView.alpha = 1
            titleView.frame = CGRect(x: 0, y: 0, width: widthCard, height: widthCard)
            titleView.sd_setImage(with: URL(string: self.imageArray[Int(element)!]), placeholderImage: nil)
            container.addSubview(titleView)
            
            let titleCard = UILabel()
            self.currentIndex = Int(element)!
            titleCard.text = self.titleArray[Int(element)!]
            titleCard.textColor = .black
            titleCard.font = UIFont(name: "AvenirLTStd-Light", size: GlobalSize().widthScreen*0.035)
            titleCard.textAlignment = .center
            titleCard.frame = CGRect(x: 0, y: widthCard, width: widthCard, height: heightCard-widthCard)
            container.addSubview(titleCard)
            
            container.layer.shadowRadius = 8
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = false
            container.layer.rasterizationScale = UIScreen.main.scale
            
            return container
        }
        
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let label = UILabel()
            label.frame = CGRect(x: GlobalSize().widthScreen*0.14, y: GlobalSize().heightScreen*0.1, width: widthCard, height: heightCard)
            label.backgroundColor = mode == .left ? GlobalColor().red : GlobalColor().green
            label.alpha = 0.3
            return label
        }
        
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
        swipeView = DMSwipeCardsView<String>(frame: frame,
                                             viewGenerator: viewGenerator,
                                             overlayGenerator: overlayGenerator)
        swipeView.delegate = self
        self.view.backgroundColor = .white
        
        
        let arrayTeaching = GlobalFunc().getTeach()
        titleArray = arrayTeaching.0
        imageArray = arrayTeaching.1
        
        if titleArray != nil {
            self.swipeView.addCards((0...(titleArray.count-1)).map({"\($0)"}), onTop: false)
            self.view.addSubview(swipeView)
        } else {
            finishCard()
        }
        
        header()
//        btnUp()
//        btnDown()
        
    }
    
    func btnUp() {
        var titleView: UIImageView!
        let img = UIImage(named: "like")
        titleView = UIImageView(image: img)
        titleView.frame = CGRect(x: GlobalSize().widthScreen*0.79, y: GlobalSize().heightScreen*0.805, width: GlobalSize().widthScreen*0.04, height: GlobalSize().widthScreen*0.04)
        self.view.addSubview(titleView)
        
        let btnUpCard = UIButton()
        btnUpCard.tag = 1
        btnUpCard.setTitle("Like", for: .normal)
        btnUpCard.setTitleColor(.black, for: .normal)
        btnUpCard.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.04)
        btnUpCard.frame = CGRect(x: GlobalSize().widthScreen*0.47, y: GlobalSize().heightScreen*0.72, width: GlobalSize().widthScreen*0.5, height: GlobalSize().heightScreen*0.2)
        btnUpCard.titleLabel?.textAlignment = .center
        btnUpCard.addTarget(self, action: #selector(self.clickVote), for: .touchUpInside)
        self.view.addSubview(btnUpCard)
    }
    
    func btnDown() {
        var titleView: UIImageView!
        let img = UIImage(named: "unlike")
        titleView = UIImageView(image: img)
        titleView.frame = CGRect(x: GlobalSize().widthScreen*0.15, y: GlobalSize().heightScreen*0.805, width: GlobalSize().widthScreen*0.04, height: GlobalSize().widthScreen*0.04)
        self.view.addSubview(titleView)
        
        let btnDownCard = UIButton()
        btnDownCard.tag = -1
        btnDownCard.setTitle("Unlike", for: .normal)
        btnDownCard.setTitleColor(.black, for: .normal)
        btnDownCard.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.04)
        btnDownCard.frame = CGRect(x: GlobalSize().widthScreen*0.03, y: GlobalSize().heightScreen*0.72, width: GlobalSize().widthScreen*0.5, height: GlobalSize().heightScreen*0.2)
        btnDownCard.titleLabel?.textAlignment = .center
        btnDownCard.addTarget(self, action: #selector(self.clickVote), for: .touchUpInside)
        self.view.addSubview(btnDownCard)
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Teach to Mhint.", s: self)
    }
    
    func finishCard() {
        let cardEnd = UILabel()
        cardEnd.text = "For now that's all"
        cardEnd.textColor = .black
        cardEnd.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.038)
        cardEnd.textAlignment = .center
        cardEnd.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.2)
        self.view.addSubview(cardEnd)
    }
    
    func clickVote(sender: UIButton) {
        print(sender.tag)
        switch sender.tag {
        case 1:
            sendVote(val: true, index: currentIndex)
        case -1:
            sendVote(val: false, index: currentIndex)
        default:
            print()
        }
    }
    
    func sendVote(val: Bool, index: Int) {
        print("L'utente", GlobalUser.email, " ha votato ", val, " l'elemento ", titleArray[index-1])
    }
    
}

extension TeachingController: DMSwipeCardsViewDelegate {
    func swipedLeft(_ object: Any) {
        sendVote(val: false, index: (currentIndex))
    }
    
    func swipedRight(_ object: Any) {
        sendVote(val: true, index: (currentIndex))
    }
    
    func cardTapped(_ object: Any) {//CLICK
    }
    
    func reachedEndOfStack() { //QUANDO HA FNITO
        self.finishCard()
    }
}
