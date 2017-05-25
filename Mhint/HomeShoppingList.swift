//
//  ShoppinListHome.swift
//  Mhint
//
//  Created by Andrea Merli on 25/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class HomeShoppingListController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let loadingShoppingBar = UIProgressView()
    var progressBarTimer:Timer!
    var progressBarStop:Float! = 0.0
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Shopping list")
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        loadingShoppingList()
        header()
        
        collectionView?.backgroundColor = .white
        
    }
    
    func loadingShoppingBarFunction() {
        if loadingShoppingBar.progress > HomeFoodController.progressBarStop {
            progressBarTimer.invalidate()
            progressBarTimer = nil
        } else {
            loadingShoppingBar.progress += 0.01
        }
    }
    
    func loadingShoppingList() {
        loadingShoppingBar.trackTintColor = UIColor.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 0.04)
        loadingShoppingBar.progressTintColor = GlobalColor().greenSea
        loadingShoppingBar.frame = CGRect(x:GlobalSize().widthScreen*0.05, y: GlobalSize().heightScreen*0.21, width:GlobalSize().widthScreen*0.9, height:GlobalSize().widthScreen*0.02)
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(HomeShoppingListController.loadingShoppingBarFunction), userInfo: nil, repeats: true)
        self.view.addSubview(loadingShoppingBar)
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Shopping List", s: self)
        
        let titleListView = UILabel()
        titleListView.text = "\(HomeFoodController.weekToGo) \(HomeFoodController.dateToGo)"
        titleListView.textColor = GlobalColor().colorBlack
        titleListView.textAlignment = .left
        titleListView.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.028)
        titleListView.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.22, width: GlobalSize().widthScreen*0.88, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
        
        let titleListViewDay = UILabel()
        titleListViewDay.text = "\(Int(HomeFoodController.dayToGo)) days to go"
        titleListViewDay.textColor = GlobalColor().colorBlack
        titleListViewDay.textAlignment = .right
        titleListViewDay.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.028)
        titleListViewDay.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.22, width: GlobalSize().widthScreen*0.88, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListViewDay)
        
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
