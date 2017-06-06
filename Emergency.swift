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
    
    var emergencyReceive = ["Empty", "Empty"]
    let emergencySendFalse = ["accepted", "Empty", "Empty"]
    let emergencySendTrue = ["pending", "Empty", "Empty"]
    
    var allEmergency = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        allEmergency.append(contentsOf: emergencyReceive)
        allEmergency.append(contentsOf: emergencySendFalse)
        allEmergency.append(contentsOf: emergencySendTrue)
        
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
        collectionView?.contentInset.top = -60
        collectionView?.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.29, width: GlobalSize().widthScreen, height:  GlobalSize().heightScreen*0.71)
        collectionView?.register(CustomCellEmergency.self, forCellWithReuseIdentifier: customCellIdentifier)
        
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCellEmergency
        let marginLeft = GlobalSize().widthScreen*0.05
        
        if indexPath.row < emergencyReceive.count {
            customCell.titleEmergency.text = "Birre".uppercased()
            customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.7, height: heightCell*0.12)
            
            customCell.descriptionEmergency.text = "6 bottiglie di Becks doppio malto nella confezione di cartone."
            customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.35, width: GlobalSize().widthScreen*0.65, height: heightCell*0.3)
            
            customCell.peopleRequestEmergency.text = "Request by Merli Andrea"
            customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.7, width: GlobalSize().widthScreen*0.6, height: heightCell*0.3)
            
            customCell.btnMaps.frame = CGRect(x: GlobalSize().widthScreen*0.7, y: heightCell*0.7, width: GlobalSize().widthScreen*0.3, height: heightCell*0.3)
            customCell.btnOk.frame = CGRect(x: GlobalSize().widthScreen*0.75, y: heightCell*0.3, width: heightCell*0.2, height: heightCell*0.2)
            customCell.btnNo.frame = CGRect(x: ((GlobalSize().widthScreen*0.8)+(heightCell*0.2)), y: heightCell*0.3, width: heightCell*0.2, height: heightCell*0.2)
            
            customCell.btnNo.tag = indexPath.row
            customCell.btnOk.tag = indexPath.row
            customCell.btnMaps.tag = indexPath.row
            
            customCell.btnNo.addTarget(self, action: #selector(emergencyNo), for: .touchUpInside)
            customCell.btnOk.addTarget(self, action: #selector(emergencyOk), for: .touchUpInside)
            customCell.btnMaps.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
            
        } else if indexPath.row < (emergencyReceive.count + emergencySendTrue.count) {
            if allEmergency[indexPath.row] == "accepted" {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.text = "your request accepted".uppercased()
                customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: heightCell*0.25, width: GlobalSize().widthScreen, height: heightCell*0.1)
            } else {
                customCell.titleEmergency.text = "Birre".uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.95, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = "6 bottiglie di Becks doppio malto nella confezione di cartone."
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.35, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = "Accept by Merli Andrea at 12:13pm"
                customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.7, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
            }
        } else if indexPath.row < (emergencyReceive.count + emergencySendTrue.count+emergencySendFalse.count) {
            if allEmergency[indexPath.row] == "pending" {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.text = "your request pending".uppercased()
                customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: heightCell*0.25, width: GlobalSize().widthScreen, height: heightCell*0.1)
            } else {
                customCell.titleEmergency.text = "Birre".uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.95, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = "6 bottiglie di Becks doppio malto nella confezione di cartone."
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.35, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = "Waiting Merli Andrea"
                customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.7, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
            }
        }
        
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allEmergency.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if allEmergency[indexPath.row] == "accepted" {
            return CGSize(width: view.frame.width, height: heightCell*0.4)
        } else if allEmergency[indexPath.row] == "pending" {
            return CGSize(width: view.frame.width, height: heightCell*0.4)
        } else {
            return CGSize(width: view.frame.width, height: heightCell)
        }
    }
    //COLLECTIONVIEW
    
    
    //HEADER
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
    
    
    //MAPPE
    func openMaps(_ sender: UIButton) {
        print(sender.tag)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let url = "comgooglemaps://?q=40.765819,-73.975866&zoom=14")
            UIApplication.shared.open(URL(string: url)!)
        } else {
            if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
                let url = "http://maps.apple.com?q=50.894967,4.341626&z=14"
                UIApplication.shared.open(URL(string: url)!)
            } else {
                GlobalFunc().alertCustom(stringAlertTitle: "Not location map available", stringAlertDescription: "Download Apple Maps or Google maps", button: "Cancel", s: self)
            }
        }
    }
    
    //OK/NO
    func emergencyOk(_ sender: UIButton) {
        allEmergency.remove(at: sender.tag)
        emergencyReceive.remove(at: sender.tag)
        print(sender.tag)
        print("L'utente ", GlobalUser.email, " vuole aiutare la tua emergenza ", sender.tag)
        GlobalFunc().alertCustom(stringAlertTitle: "Thank's", stringAlertDescription: "You help your friends", button: "OK", s: self)
        self.collectionView?.reloadData()
    }
    func emergencyNo(_ sender: UIButton) {
        allEmergency.remove(at: sender.tag)
        emergencyReceive.remove(at: sender.tag)
        print(sender.tag)
        print("L'utente ", GlobalUser.email, " non vuole aiutare la tua emergenza ", sender.tag)
        GlobalFunc().alertCustom(stringAlertTitle: "Come on", stringAlertDescription: "You don't help your friends", button: "Sorry I'm busy", s: self)
        self.collectionView?.reloadData()
    }
    
}
