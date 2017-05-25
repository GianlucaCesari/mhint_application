//
//  notificationFood.swift
//  Mhint
//
//  Created by Andrea Merli on 23/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationFoodController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UNUserNotificationCenterDelegate{
    
    let cellId = "cellNotificationFood"
    
    let heightCell = GlobalSize().widthScreen*0.14
    let widthCollectionView = GlobalSize().widthScreen*0.8
    
    let daysInWeek = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    var indexWeek:Int!
    
    var arrayImageHidden = [Bool]()
    let btnNextPage = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Weekly notification")
        header()
        
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
        collectionView?.register(CustomCellChooseNotificationFood.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInWeek.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCellChooseNotificationFood
        
        cell.titleNotification.text = daysInWeek[indexPath.row].capitalized
        cell.titleNotification.frame = CGRect(x: heightCell+(heightCell/2)-20, y: 0, width: widthCollectionView, height: heightCell)
        
        cell.checkImageBtn.frame = CGRect(x: heightCell*0.1, y: heightCell*0.15, width: heightCell*0.8, height: heightCell*0.8)
        if arrayImageHidden.count < (indexPath.row + 1) {
            arrayImageHidden.append(false)
        }
        var stringImage = String()
        if arrayImageHidden[indexPath.row] == true {
            stringImage = "check-true"
        } else {
            stringImage = "check-false"
        }
        let imageGreen = UIImage(named: stringImage)
        cell.checkImageBtn.image = imageGreen
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCollectionView, height: heightCell)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for x in 0..<arrayImageHidden.count {
            let cell = collectionView.cellForItem(at: IndexPath(row: x, section: 0)) as! CustomCellChooseNotificationFood
            let imageGreen = UIImage(named: "check-false")
            cell.checkImageBtn.image = imageGreen
            arrayImageHidden[x] = false
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellChooseNotificationFood
        
        var boolImage = Bool()
        if arrayImageHidden[indexPath.row] == true {
            boolImage = false
        } else {
            boolImage = true
        }
        
        let imageGreen = UIImage(named: "check-true")
        cell.checkImageBtn.image = imageGreen
        
        arrayImageHidden[indexPath.row] = boolImage
        indexWeek = indexPath.row
        nextPage()
    }
    //COLLECTIONVIEW
    
    //BOTTONE NEXT PAGE
    func nextPage() {
        btnNextPage.setTitle("Oooooooow, that's all", for: .normal)
        btnNextPage.setTitleColor(.black, for: .normal)
        btnNextPage.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.03)
        btnNextPage.titleLabel?.textAlignment = .center
        btnNextPage.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.92, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.05)
        btnNextPage.addTarget(self, action: #selector(goToDiet), for: .touchUpInside)
        self.view.addSubview(btnNextPage)
    }
    
    func goToDiet() {
        saveData.set(indexWeek+1, forKey: "notificationDay")
        saveData.set(true, forKey: "HomeFood")
        let newViewController = HomeFoodController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
        setNotificationShoppingList()
    }
    
    func setNotificationShoppingList () {
        let content = UNMutableNotificationContent()
        content.title = "It's time to go grocery-shopping!"
        content.body = "Click here to see your grocery list."
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.weekday = saveData.integer(forKey: "notificationDay")
        dateComponents.hour = 18
        dateComponents.minute = 56
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: (dateComponents), repeats: true)
        let request = UNNotificationRequest(identifier:"SampleRequest", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            if (error != nil){
                print(error?.localizedDescription as Any)
            }
        }
        
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
        titleListView.text = "When do you want get notificated ?".uppercased()
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
