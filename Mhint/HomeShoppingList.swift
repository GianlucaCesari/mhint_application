//
//  ShoppinListHome.swift
//  Mhint
//
//  Created by Andrea Merli on 25/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import Alamofire

var shoppingList = [String]()
var shoppingListQuantity = [String]()
var shoppingListId = [String]()
var arrayImageHidden = [Bool]()

class HomeShoppingListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate, UITextFieldDelegate {
    
    let cellId = "cellShoppingList"
    
    
    let heightCell = GlobalSize().widthScreen*0.15
    let widthCollectionView = GlobalSize().widthScreen
    
    let loadingShoppingBar = UIProgressView()
    var progressBarTimer:Timer!
    var progressBarStop:Float! = 0.0
    
    var idList:String = ""
    
    let btnAlert = UITextField()
    let btnAlertQuantity = UITextField()
    let btnAlertUnity = UITextField()
    
    let lbl = UILabel()
    
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Shopping list")
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        getShoppingList()
        
        loadingShoppingList()
        header()
        
        addItemShoppingList()
        
        collectionView?.backgroundColor = .white
        
        saveShoppingList()
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: widthCollectionView, height: heightCell)
        collectionView?.collectionViewLayout = layout
        collectionView?.backgroundColor = GlobalColor().backgroundCollectionView
        collectionView?.delegate = self
        collectionView?.backgroundColor = .white
        collectionView?.dataSource = self
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.285, width: widthCollectionView, height: GlobalSize().heightScreen*0.61)
        collectionView?.register(CustomCellChooseHomeShoppingList.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        if UIApplication.shared.applicationIconBadgeNumber > 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        if shoppingList.count < 1 {
            insertClearData()
        }
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
                        x += 1
                        shoppingList.append(item["name"]! as! String)
                        shoppingListQuantity.append("\(item["value"]!) \(item["unit"]!)")
                        shoppingListId.append(item["_id"]! as! String)
                        arrayImageHidden.append(item["checked"]! as! Bool)
                        if items.count == x {
                            shoppingList.reverse()
                            shoppingListQuantity.reverse()
                            shoppingListId.reverse()
                            arrayImageHidden.reverse()
                            self.view.willRemoveSubview(self.lbl)
                            self.lbl.removeFromSuperview()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseHomeShoppingList
        
        cell.titleDiet.text = shoppingList[indexPath.row].capitalized
        cell.titleDiet.frame = CGRect(x: heightCell+(heightCell/2)-20, y: 0, width: widthCollectionView, height: heightCell)
        
        cell.quantityDiet.frame = CGRect(x: widthCollectionView-(heightCell*2)-30, y: 0, width: heightCell*2, height: heightCell)
        cell.quantityDiet.text = shoppingListQuantity[indexPath.row].capitalized
        
        cell.checkImageBtn.frame = CGRect(x: GlobalSize().widthScreen*0.04, y: heightCell*0.2, width: GlobalSize().heightScreen*0.05, height: GlobalSize().heightScreen*0.05)
        
        cell.lineGetItem.alpha = 0
        cell.lineGetItem.frame = CGRect(x: 0, y: heightCell*0.475, width: widthCollectionView, height: heightCell*0.03)
        
        if arrayImageHidden.count < (indexPath.row + 1) {
            arrayImageHidden.append(false)
        }
        
        if arrayImageHidden[indexPath.row] == true {
            let stringImage = "check-true"
            cell.quantityDiet.textColor = .lightGray
            cell.titleDiet.textColor = .lightGray
            cell.quantityDiet.alpha = 0.6
            cell.titleDiet.alpha = 0.6
            cell.lineGetItem.alpha = 0.1
            let imageGreen = UIImage(named: stringImage)
            cell.checkImageBtn.image = imageGreen
        } else {
            let stringImage = "check-false"
            cell.quantityDiet.textColor = .black
            cell.titleDiet.textColor = .black
            cell.quantityDiet.alpha = 1
            cell.titleDiet.alpha = 1
            cell.lineGetItem.alpha = 0
            let imageGreen = UIImage(named: stringImage)
            cell.checkImageBtn.image = imageGreen
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollectionView, height: heightCell)
    }
    //CLICK CELL
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellChooseHomeShoppingList
        
        var boolImage = Bool()
        var stringImage = String()
        if arrayImageHidden[indexPath.row] == true {
            boolImage = false
            stringImage = "check-false"
            cell.quantityDiet.textColor = .black
            cell.titleDiet.textColor = .black
            cell.quantityDiet.alpha = 1
            cell.titleDiet.alpha = 1
            cell.lineGetItem.alpha = 0
        } else {
            boolImage = true
            stringImage = "check-true"
            cell.quantityDiet.textColor = .lightGray
            cell.titleDiet.textColor = .lightGray
            cell.quantityDiet.alpha = 0.6
            cell.titleDiet.alpha = 0.6
            cell.lineGetItem.alpha = 0.1
        }
        
        
        let parameter = [
            "item_id": shoppingListId[indexPath.row]
            , "checked": boolImage
            ] as [String : Any]
        
        
        Alamofire.request("https://api.mhint.eu/itemchecked", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in
            print(JSON)
        }
        
        let imageGreen = UIImage(named: stringImage)
        cell.checkImageBtn.image = imageGreen
        arrayImageHidden[indexPath.row] = boolImage
        
    }
    //COLLECTIONVIEW
    
    
    func addItemShoppingList() {
        let addBackground = UIButton()
        addBackground.backgroundColor = GlobalColor().backgroundCollectionView
        //addBackground(self, action: #selector(alertAddItem), for: .touchUpInside)
        addBackground.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.28, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(addBackground)
        
        let btnMenu = UIButton()
        let imgMenuClose = UIImage(named: "check-plus")
        btnMenu.setImage(imgMenuClose, for: .normal)
        btnMenu.frame = CGRect(x: GlobalSize().widthScreen*0.04, y: GlobalSize().heightScreen*0.305, width: GlobalSize().heightScreen*0.05, height: GlobalSize().heightScreen*0.05)
        btnMenu.addTarget(self, action: #selector(insertShoppingList), for: .touchUpInside)
        self.view.addSubview(btnMenu)
        
        btnAlert.placeholder = "Add Item"
        btnAlert.textColor = .black
        btnAlert.font = UIFont(name: "AvenirLTStd-Heavy", size: 13)
        btnAlert.textAlignment = .left
        btnAlert.frame = CGRect(x: GlobalSize().widthScreen*0.15, y: GlobalSize().heightScreen*0.305, width: GlobalSize().widthScreen*0.4, height: GlobalSize().heightScreen*0.05)
        
        btnAlertQuantity.keyboardType = UIKeyboardType.numberPad
        btnAlertQuantity.placeholder = "Add Quanity"
        btnAlertQuantity.textColor = .black
        btnAlertQuantity.font = UIFont(name: "AvenirLTStd-Medium", size: 10)
        btnAlertQuantity.textAlignment = .left
        btnAlertQuantity.frame = CGRect(x: GlobalSize().widthScreen*0.6, y: GlobalSize().heightScreen*0.305, width: GlobalSize().widthScreen*0.2, height: GlobalSize().heightScreen*0.05)
        
        btnAlertUnity.placeholder = "Add Unit"
        btnAlertUnity.textColor = .black
        btnAlertUnity.font = UIFont(name: "AvenirLTStd-Medium", size: 10)
        btnAlertUnity.textAlignment = .left
        btnAlertUnity.frame = CGRect(x: GlobalSize().widthScreen*0.8, y: GlobalSize().heightScreen*0.305, width: GlobalSize().widthScreen*0.2, height: GlobalSize().heightScreen*0.05)
        
        btnAlertUnity.addTarget(self, action: #selector(clickTextField), for: .touchDown)
        btnAlertQuantity.addTarget(self, action: #selector(clickTextField), for: .touchDown)
        btnAlert.addTarget(self, action: #selector(clickTextField), for: .touchDown)
        
        btnAlertUnity.delegate = self
        btnAlertQuantity.delegate = self
        btnAlert.delegate = self
        
        self.view.addSubview(btnAlert)
        self.view.addSubview(btnAlertQuantity)
        self.view.addSubview(btnAlertUnity)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturnClose))
    }
    
    func clickTextField() {
        self.view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturnClose(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.view.removeGestureRecognizer(tap)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        insertShoppingList()
        return true
    }
    
    func insertShoppingList() {
        let textTrimmed = (btnAlert.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textTrimmed != "" {
            
            self.view.willRemoveSubview(lbl)
            lbl.removeFromSuperview()
            
            shoppingList.insert(textTrimmed, at: 0)
            shoppingListQuantity.insert(btnAlertQuantity.text! + " " + btnAlertUnity.text!, at: 0)
            arrayImageHidden.insert(false, at: 0)
            collectionView?.reloadData()
            
            GlobalVariable.listItem.insert(textTrimmed, at: 0)
            GlobalVariable.listItem.insert(btnAlertQuantity.text! + " " + btnAlertUnity.text!, at: 0)
            
            print(idList)
            var parameter = [:] as [String : Any]
            if idList == "" {
                parameter = [
                    "mail": GlobalUser.email
                    , "item": [
                        "name": textTrimmed
                        , "value": btnAlertQuantity.text!
                        , "unit": btnAlertUnity.text!
                    ]
                ] as [String : Any]
            } else {
                parameter = [
                "list_id": idList
                , "item": [
                    "name": textTrimmed
                    , "value": btnAlertQuantity.text!
                    , "unit": btnAlertUnity.text!
                    ]
                ] as [String : Any]
            }
            
            Alamofire.request("https://api.mhint.eu/additem", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in
                if let json = JSON.result.value as? [String: Any]{
                    self.idList = json["_id"] as! String
                }
            }
            
            btnAlert.text = ""
            btnAlertQuantity.text = ""
            btnAlertUnity.text = ""
            
            
        } else {
            GlobalFunc().alertCustom(stringAlertTitle: "No valid name", stringAlertDescription: "Insert the name of the item", button: "OK", s: self)
        }
    }
    
    func loadingShoppingBarFunction() {
        if loadingShoppingBar.progress > HomeFoodController.progressBarStop {
            progressBarTimer.invalidate()
            progressBarTimer = nil
        } else {
            loadingShoppingBar.progress += 0.01
        }
    }
    
    func saveShoppingList() {
        let save = UIButton()
        save.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.9, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        save.setTitle("Shop Now", for: .normal)
        save.backgroundColor = GlobalColor().greenSea
        save.setTitleColor(.white, for: .normal)
        save.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 16)
        save.addTarget(self, action: #selector(clearShoppingList), for: .touchUpInside)
        self.view.addSubview(save)
    }
    
    func clearShoppingList() {
        let controller = UIAlertController(title: "Clear Shopping List", message: "Do you want remove all item ?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        let settingsAction = UIAlertAction(title: "Yes", style: .default) { (_) -> Void in
            GlobalVariable.listItem.removeAll()
            GlobalVariable.listItemQuantity.removeAll()
            shoppingList.removeAll()
            shoppingListQuantity.removeAll()
            self.collectionView?.reloadData()
            self.insertClearData()
            
            let parameter = [
                "list_id": self.idList
                ] as [String : Any]
            
            Alamofire.request("https://api.mhint.eu/listcomplete", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in }
            
        }
        controller.addAction(settingsAction)
        self.present(controller, animated: true, completion: nil)
    }
    
    func insertClearData() {
        lbl.text = "Your shopping list is empty."
        lbl.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.37, width: widthCollectionView, height: GlobalSize().heightScreen*0.536)
        lbl.backgroundColor = .white
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.031)
        lbl.textColor = .black
        self.view.addSubview(lbl)
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
