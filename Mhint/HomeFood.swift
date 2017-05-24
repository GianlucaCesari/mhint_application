//
//  HomeFood.swift
//  
//
//  Created by Andrea Merli on 24/05/17.
//
//

import Foundation
import UIKit

class HomeFoodController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    //CLASSI ESTERNE
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        header()
        
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UILabel()
        description.text = "Next shop"
        description.textColor = self.globalColor.colorBlack
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        
        let titleListView = UILabel()
        titleListView.text = "3 days to go | 12 Apr."
        titleListView.textColor = self.globalColor.colorBlack
        titleListView.textAlignment = .center
        titleListView.addTextSpacing()
        titleListView.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.035)
        titleListView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
    }
    
}
