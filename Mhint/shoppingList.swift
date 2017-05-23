//
//  shoppingList.swift
//  Mhint
//
//  Created by Andrea Merli on 23/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Shopping List")
        header()
        nextPage()
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 2
        layout.sectionInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.33, width: widthCollectionView, height: GlobalSize().heightScreen*0.52)
        collectionView?.register(CustomCellChooseEatOut.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        
    }
    
    //BOTTONE NEXT PAGE
    func nextPage() {
        btnNextPage.setTitle("Ready go on", for: .normal)
        btnNextPage.setTitleColor(.black, for: .normal)
        btnNextPage.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.03)
        btnNextPage.titleLabel?.textAlignment = .center
        btnNextPage.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.92, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.05)
        btnNextPage.addTarget(self, action: #selector(goToDiet), for: .touchUpInside)
        self.view.addSubview(btnNextPage)
    }
    
    func goToDiet() {
        let newViewController = ShoppingListController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //HEADER
    func header() {
        GlobalFunc().titlePage(titlePage: "Food & Diet.", s: self)
        
        let description = UILabel()
        description.text = "Welcome on Food & Diet section\nHelp you to make\nCiao!"
        description.textColor = GlobalColor().colorBlack
        description.numberOfLines = 3
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
        
        
        let titleListView = UILabel()
        titleListView.text = "This is your shopping list".uppercased()
        titleListView.textColor = GlobalColor().colorBlack
        titleListView.textAlignment = .center
        titleListView.addTextSpacing()
        titleListView.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.035)
        titleListView.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(titleListView)
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
