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

//POST-GET
import Alamofire

class TeachingController: UIViewController{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    var timerCard = Timer()
    
    var titleArray = [String]()
    var imageArray = [String]()
    var idArray = [String]()
    
    let row1 = UITextView()
    let row2 = UITextView()
    
    var nutrimentsName = [String]()
    var nutrimentsValue = [String]()
    
    let widthCard = GlobalSize().widthScreen*0.72
    let heightCard = GlobalSize().heightScreen*0.5
    
    private var swipeView: DMSwipeCardsView<String>!
    private var swipeViewApp: DMSwipeCardsView<String>!
    var currentIndex = Int()
    
    var imageLoadingView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalFunc().checkInternet(s: self)//INTERNET
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true)
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: GlobalSize().widthScreen*0.14, y: GlobalSize().heightScreen*0.1, width: self.widthCard, height: self.heightCard))
            
            let index = Int(element)!
            
            let label = UILabel(frame: container.bounds)
            label.textAlignment = .center
            label.backgroundColor = .white
            label.font = UIFont.systemFont(ofSize: 12, weight: UIFontWeightThin)
            label.clipsToBounds = true
            label.layer.cornerRadius = 3
            container.addSubview(label)
            
            let imageLoading = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
            imageLoading.frame = CGRect(x: 0, y: 0, width: self.widthCard, height: self.widthCard)
            container.addSubview(imageLoading)
            
            var titleView: UIImageView!
            let img = UIImage(named: "default")
            titleView = UIImageView(image: img)
            titleView.alpha = 1
            titleView.frame = CGRect(x: 0, y: 0, width: self.widthCard, height: self.widthCard)
            titleView.sd_setImage(with: URL(string: self.imageArray[Int(element)!]), placeholderImage: nil)
            container.addSubview(titleView)
            
            if index-1 != -1 {
                self.showNutriments(name: self.nutrimentsName[index-1], value: self.nutrimentsValue[index-1])
            }
            let titleCard = UILabel()
            self.currentIndex = Int(element)!
            titleCard.text = self.titleArray[Int(element)!]
            titleCard.textColor = .black
            titleCard.font = UIFont(name: "AvenirLTStd-Light", size: GlobalSize().widthScreen*0.035)
            titleCard.textAlignment = .center
            titleCard.frame = CGRect(x: 0, y: self.widthCard, width: self.widthCard, height: self.heightCard-self.widthCard)
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
            label.frame = CGRect(x: GlobalSize().widthScreen*0.14, y: GlobalSize().heightScreen*0.1, width: self.widthCard, height: self.heightCard)
            label.backgroundColor = mode == .left ? GlobalColor().red : GlobalColor().green
            label.alpha = 0.3
            return label
        }
        
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
        self.view.backgroundColor = .white
        
        imageLoadingView = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
        imageLoadingView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.3, width: GlobalSize().widthScreen*0.8, height: GlobalSize().widthScreen*0.8)
        self.view.addSubview(imageLoadingView)
        
        loadingCard()
        
        header()
        
        swipeViewApp = DMSwipeCardsView<String>(frame: frame, viewGenerator: viewGenerator, overlayGenerator: overlayGenerator)
    }
    
    func showNutriments(name: String, value: String) {
        
        let marginLeft = GlobalSize().widthScreen*0.1
        let marginTop = GlobalSize().heightScreen*0.1+(self.heightCard*1.3)
        
        let widthRow = (GlobalSize().widthScreen-(marginLeft*2))/2
        let heightRow = GlobalSize().heightScreen-marginTop
        
        self.row1.removeFromSuperview()
        self.row2.removeFromSuperview()
        
        row1.text = name
        row1.isEditable = false
        row1.backgroundColor = .clear
        row1.font = UIFont(name: "AvenirLTStd-Medium", size: 14)
        row1.frame = CGRect(x: marginLeft*2, y: marginTop, width: widthRow, height: heightRow)
        self.view.addSubview(row1)
        
        row2.text = value
        row2.isEditable = false
        row2.backgroundColor = .clear
        row2.font = UIFont(name: "AvenirLTStd-Black", size: 14)
        row2.frame = CGRect(x: marginLeft*2+widthRow, y: marginTop, width: widthRow*0.7, height: heightRow)
        self.view.addSubview(row2)
        
    }
    
    func checkCardExist() {
        if titleArray.count > 0 {
            self.imageLoadingView.removeFromSuperview()
            self.swipeView = self.swipeViewApp
            self.swipeView.delegate = self
            self.swipeView.addCards((0...(titleArray.count-1)).map({"\($0)"}), onTop: false)
            self.view.addSubview(swipeView)
            timerCard.invalidate()
        }
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Teach to Mhint.", s: self)
    }
    
    func loadingCard() {
        if GlobalUser.email != "" {
        Alamofire.request("https://api.mhint.eu/foodpreference?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { response in
            self.titleArray.removeAll()
            self.idArray.removeAll()
            self.imageArray.removeAll()
            if let result = response.result.value {
                for anItem in result as! [[String:Any]] {
                
                    self.titleArray.append(anItem["name"]! as! String)
                    self.idArray.append(anItem["_id"]! as! String)
                    self.imageArray.append(anItem["img_url"]! as! String)
                    
                    var arrayName = ""
                    var arrayValue = ""
                    
                    var index = -1
                    for nutriments in anItem["nutrients"] as! [[String:Any]] {
                        index += 1
                        if index < 8 {
                            if let name = nutriments["name"]{
                                arrayName = "\(arrayName)\(String(describing: name)) \n"
                            }
                            if let value = nutriments["amount"] {
                                var val = String(describing: value)
                                if val.characters.count > 5 {
                                    let endIndex = val.index(val.endIndex, offsetBy: (5-val.characters.count))
                                    val = val.substring(to: endIndex)
                                }
                                arrayValue = "\(arrayValue)\(val) \(nutriments["unit"]!)\n"
                            }
                        }
                    }
                    self.nutrimentsName.append(arrayName)
                    self.nutrimentsValue.append(arrayValue)
                }
            } else {
                self.finishCard()
            }
        }
        timerCard = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.checkCardExist), userInfo: nil, repeats: true)
        }
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
        switch sender.tag {
        case 1:
            sendVote(val: true, index: currentIndex)
        case -1:
            sendVote(val: false, index: currentIndex)
        default:
            break
        }
    }
    
    func sendVote(val: Bool, index: Int) {
        let parameter = [
            "mail": GlobalUser.email,
            "food_id": idArray[index-1],
            "type": val ? "like":"not-like"
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/foodpreference", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON {_ in }
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
        imageLoadingView = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
        imageLoadingView.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.3, width: GlobalSize().widthScreen*0.8, height: GlobalSize().widthScreen*0.8)
        self.view.addSubview(imageLoadingView)
        row1.text = ""
        row2.text = ""
        self.loadingCard()
    }
}
