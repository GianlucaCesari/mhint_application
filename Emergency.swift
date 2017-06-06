//
//  Emergency.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

class EmergencyController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let customCellIdentifier = "cellId"
    
    let heightCell = GlobalSize().heightScreen*0.2
    
    let emergencyReceive = ["Empty"]
    let emergencySendFalse = ["accepted", "Empty", "Empty"]
    let emergencySendTrue = ["pending", "Empty", "Empty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        GlobalFunc().navBar(nav: navigationItem, s: self, show: true) //navigation bar
        GlobalFunc().navBarRightChat(nav: navigationItem, s: self) //navigation v.a.
        header()
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: GlobalSize().widthScreen, height: heightCell)
        
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.contentInset.top = -80
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.29, width: GlobalSize().widthScreen, height:  GlobalSize().heightScreen*0.71)
        collectionView?.register(CustomCellEmergency.self, forCellWithReuseIdentifier: customCellIdentifier)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCellEmergency
        
        if indexPath.row < emergencyReceive.count {
            customCell.titleEmergency.text = "Sigarette".uppercased()
            customCell.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: heightCell*0.05, width: GlobalSize().widthScreen*0.6, height: heightCell*0.3)
            
            customCell.descriptionEmergency.text = "Doppio malto"
            customCell.descriptionEmergency.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: heightCell*0.4, width: GlobalSize().widthScreen*0.6, height: heightCell*0.2)
            
            customCell.peopleRequestEmergency.text = "Request by Merli Andrea"
            customCell.peopleRequestEmergency.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: heightCell*0.6, width: GlobalSize().widthScreen*0.6, height: heightCell*0.3)
            
            customCell.btnMaps.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
            customCell.btnMaps.frame = CGRect(x: GlobalSize().widthScreen*0.7, y: heightCell*0.6, width: GlobalSize().widthScreen*0.3, height: heightCell*0.3)
        }
        
//        let sizeArrow = self.globalSize.widthScreen*0.05
//        let marginLeft = 25
//        var heightRow = 90
//
//        if indexPath.row == 2 {
//            customCell.backgroundColor = .white
//            heightRow = 70
//            customCell.arrow.alpha = 0
//            customCell.titleTextView.alpha = 0
//            customCell.titleTextViewDivide.text = settingsSection[indexPath.row]
//        }
//        else if (indexPath.row > 2){
//            heightRow = 70
//            customCell.arrow.alpha = 0
//            customCell.titleTextViewDivide.alpha = 0
//            customCell.titleTextView.text = settingsSection[indexPath.row]
//
//            customCell.switchSection.alpha = 1
//            customCell.switchSection.frame = CGRect(x: self.globalSize.widthScreen*0.8, y: (CGFloat(heightRow)-customCell.switchSection.frame.size.height)/2, width: 0, height: 0)
//            customCell.switchSection.isEnabled = false
//
//            if indexPath.row == 3 {
//                customCell.switchSection.isOn = saveData.bool(forKey: "food")
//            } else if indexPath.row == 4 {
//                customCell.switchSection.isOn = saveData.bool(forKey: "need")
//            }
//
//            customCell.switchSection.tag = indexPath.row
//            customCell.switchSection.addTarget(self, action: #selector(switchSection), for: UIControlEvents.valueChanged)
//
//        }
//        else{
//            heightRow = 90
//            customCell.titleTextViewDivide.alpha = 0
//            customCell.arrow.frame = CGRect(x: self.globalSize.widthScreen-sizeArrow-10, y: (CGFloat(heightRow)-sizeArrow)/2, width: sizeArrow, height: sizeArrow)
//            customCell.titleTextView.text = settingsSection[indexPath.row]
//        }
//        customCell.titleTextView.frame = CGRect(x: marginLeft, y: 0, width: Int(self.globalSize.widthScreen/2), height: heightRow)
//        customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: 10, width: Int(self.globalSize.widthScreen/2), height: heightRow)
        
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (emergencyReceive.count + emergencySendFalse.count + emergencySendTrue.count)
    }
    
    func header() {
        GlobalFunc().titlePage(titlePage: "Needs & Emergency.", s: self)
        let description = UILabel()
        description.text = "Welcome on Food & Diet section\nHelp you to make\nCiao!"
        description.textColor = GlobalColor().colorBlack
        description.numberOfLines = 3
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        self.view.addSubview(description)
    }
    
    func openMaps() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic")!)
        } else {
            if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
                UIApplication.shared.open(URL(string: "http://maps.apple.com")!)
            } else {
                GlobalFunc().alertCustom(stringAlertTitle: "Not location map available", stringAlertDescription: "Download Maps or Google maps", button: "Cancel", s: self)
            }
        }
    }
    
}
