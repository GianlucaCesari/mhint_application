//
//  shoppingList.swift
//  Mhint
//
//  Created by Andrea Merli on 23/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ShoppingListController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    let cellId = "cellShoppingList"
    
    let heightCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen*0.8
    
    var shoppingList = [String]()
    var shoppingListQuantity = [String]()
    var shoppingListId = [String]()
    var arrayImageHidden = [Bool]()
    
    var idList:String = ""
    
    let btnNextPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        getShoppingList()
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
        collectionView?.register(CustomCellChooseListShopping.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    //SHOPPINGLIST
    func getShoppingList() {
        
        shoppingList.removeAll()
        shoppingListId.removeAll()
        shoppingListQuantity.removeAll()
        arrayImageHidden.removeAll()
        
        var x = 0
        
        Alamofire.request("https://api.mhint.eu/shoppinglist?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { JSON in
            if let json = JSON.result.value as? [String: Any]{
                self.idList = json["_id"] as! String
                if let items = json["items"] as? [[String: Any]] {
                    for item in items {
                        var value = ""
                        if let v = item["value"] {
                            value = v as! String
                        }
                        
                        var unit = ""
                        if let u = item["unit"] {
                            unit = u as! String
                        }
                        
                        x += 1
                        self.shoppingList.append(item["name"]! as! String)
                        self.shoppingListQuantity.append("\(value) \(unit)")
                        self.shoppingListId.append(item["_id"]! as! String)
                        self.arrayImageHidden.append(item["checked"]! as! Bool)
                        
                        if items.count == x {
                            self.shoppingList.reverse()
                            self.shoppingListQuantity.reverse()
                            self.shoppingListId.reverse()
                            self.arrayImageHidden.reverse()
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseListShopping
        
        cell.titleDiet.text = shoppingList[indexPath.row].capitalized
        cell.titleDiet.frame = CGRect(x: heightCell+(heightCell/2)-20, y: 0, width: widthCollectionView, height: heightCell)
        
        cell.quantityDiet.frame = CGRect(x: widthCollectionView-(heightCell*2)-30, y: 0, width: heightCell*2, height: heightCell)
        cell.quantityDiet.text = shoppingListQuantity[indexPath.row].capitalized
        
        let imageGreen = UIImage(named: "check-true")
        cell.checkImageBtn.frame = CGRect(x: heightCell*0.1, y: heightCell*0.15, width: heightCell*0.8, height: heightCell*0.8)
        cell.checkImageBtn.image = imageGreen
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollectionView, height: heightCell)
    }
    //COLLECTIONVIEW
    
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
        let newViewController = NotificationFoodController(collectionViewLayout: layout)
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
