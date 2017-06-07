//
//  Emergency.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire

class EmergencyController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let customCellIdentifier = "cellId"
    
    let heightCell = GlobalSize().heightScreen*0.2
    
    var emergencyReceive = [String]()
    var emergencyReceiveName = [String]()
    var emergencyReceiveDescription = [String]()
    var emergencyReceiveUser = [String]()
    var emergencyReceiveLat = [Double]()
    var emergencyReceiveLon = [Double]()
    
    var emergencySendFalse = ["accepted", "Empty4", "Empty5"]
    
    
    var emergencySendTrue = ["pending"]
    var emergencySendTrueName = [""]
    var emergencySendTrueDescription = [""]
    var emergencySendTrueUser = [""]
    
    var allEmergency = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getEmergencyPending()
        getEmergencyAccepted()
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "NEEDS & EMERGENCY")
        
        self.view.backgroundColor = .white
        
        if emergencyReceive.count == 0 {
            emergencyReceive.append("no-request")
        }
        
        GlobalFunc().navBar(nav: navigationItem, s: self, show: true) //navigation bar
        GlobalFunc().navBarRightChat(nav: navigationItem, s: self) //navigation v.a.
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "plus")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.addNeed), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
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
        self.view.addSubview(collectionView!)
    }
    
    func getEmergencyPending() {
        Alamofire.request("https://api.mhint.eu/needs?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { response in
            if let items = response.result.value as? [[String: Any]] {
                for item in items {
                    self.emergencySendTrueName.append(item["name"]! as! String)
                    self.emergencySendTrue.append(item["_id"] as! String)
                    
                    if let description = item["description"] {
                        self.emergencySendTrueDescription.append(description as! String)
                    } else {
                        self.emergencySendTrueDescription.append("")
                    }
                    
                    if let user = item["user_receiver"] as? [String: Any] {
                        if String(describing: item["status"]!) == "pending" {
                            self.emergencySendTrueUser.append("Waiting \(user["name"]!)")
                        } else if String(describing: item["status"]!) == "accepted" {
                            self.emergencySendTrueUser.append("Accepted by \(user["name"]!)")
                        } else if String(describing: item["status"]!) == "refused" {
                            self.emergencySendTrueUser.append("Refused by \(user["name"]!)")
                        } else {
                            self.emergencySendTrueUser.append("Ops by \(user["name"]!)")
                        }
                    }
                    
                    if self.emergencySendTrue.count == items.count {
                        self.allEmergency.removeAll()
                        self.allEmergency.append(contentsOf: self.emergencyReceive)
                        self.allEmergency.append(contentsOf: self.emergencySendFalse)
                        self.allEmergency.append(contentsOf: self.emergencySendTrue)
                        
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func getEmergencyAccepted() {
        Alamofire.request("https://api.mhint.eu/requests?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { response in
            
            print(response)
            if let items = response.result.value as? [[String: Any]] {
                self.emergencyReceive.removeAll()
                for item in items {
                    
                    if String(describing: item["status"]!) == "pending" {
                        self.emergencyReceive.append(item["_id"] as! String)
                        self.emergencyReceiveName.append(item["name"] as! String)
                        if String(describing: item["description"]) != "" {
                            self.emergencyReceiveDescription.append(item["description"]! as! String)
                        } else {
                            self.emergencyReceiveDescription.append("")
                        }
                        
                        if let user = item["user_sender"] as? [String: Any] {
                            self.emergencyReceiveUser.append(user["name"] as! String)
                        }
                        if let position = item["display_position"] as? [String: Double] {
                            self.emergencyReceiveLat.append(position["lat"]!)
                            self.emergencyReceiveLon.append(position["long"]!)
                        }
                    }
                    if self.emergencyReceive.count == items.count {
                        self.allEmergency.removeAll()
                        self.allEmergency.append(contentsOf: self.emergencyReceive)
                        self.allEmergency.append(contentsOf: self.emergencySendFalse)
                        self.allEmergency.append(contentsOf: self.emergencySendTrue)
                        
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
        
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCellEmergency
        let marginLeft = GlobalSize().widthScreen*0.05
        
        customCell.backgroundColor = GlobalColor().backgroundCollectionView
        
        customCell.titleEmergency.alpha = 0
        customCell.descriptionEmergency.alpha = 0
        customCell.peopleRequestEmergency.alpha = 0
        customCell.btnNo.alpha = 0
        customCell.btnOk.alpha = 0
        customCell.btnMaps.alpha = 0
        customCell.titleTextViewDivide.alpha = 0
        
        if indexPath.row < emergencyReceive.count {
            if emergencyReceive[indexPath.row] == "no-request" {
                
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "No one ask your help yet".uppercased()
                customCell.titleTextViewDivide.font = UIFont(name: "AvenirLTStd-Black", size: 13)
                customCell.titleTextViewDivide.textAlignment = .center
                customCell.titleTextViewDivide.addTextSpacing()
                customCell.titleTextViewDivide.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: heightCell*0.6)
                
            } else {
                
                print(emergencyReceiveName)
                print(indexPath.row)
                
                customCell.titleEmergency.alpha = 1
                customCell.descriptionEmergency.alpha = 1
                customCell.peopleRequestEmergency.alpha = 1
                customCell.btnNo.alpha = 1
                customCell.btnOk.alpha = 1
                customCell.btnMaps.alpha = 1
                
                customCell.titleEmergency.text = emergencyReceiveName[indexPath.row].uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.7, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = emergencyReceiveDescription[indexPath.row]
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.35, width: GlobalSize().widthScreen*0.65, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = "Request by \(emergencyReceiveUser[indexPath.row])"
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
            }
        } else if indexPath.row < (emergencyReceive.count + emergencySendFalse.count) {
            if emergencySendTrue.count == 1 {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "no request accepted".uppercased()
                customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: heightCell*0.25, width: GlobalSize().widthScreen, height: heightCell*0.1)
            }
            else if allEmergency[indexPath.row] == "accepted" {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "request accepted".uppercased()
                customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: heightCell*0.25, width: GlobalSize().widthScreen, height: heightCell*0.1)
            } else {
                customCell.titleEmergency.alpha = 1
                customCell.descriptionEmergency.alpha = 1
                customCell.peopleRequestEmergency.alpha = 1
                
                customCell.titleEmergency.text = "Birre".uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.95, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = "6 bottiglie di Becks doppio malto nella confezione di cartone."
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.35, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = "Accept by Merli Andrea at 12:13pm"
                customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.7, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
            }
        } else if indexPath.row < (emergencyReceive.count + emergencySendFalse.count + emergencySendTrue.count) {
            if emergencySendFalse.count == 1 {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "no request pending".uppercased()
                customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: heightCell*0.25, width: GlobalSize().widthScreen, height: heightCell*0.1)
            }
            else if allEmergency[indexPath.row] == "pending" {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "your request".uppercased()
                customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: heightCell*0.25, width: GlobalSize().widthScreen, height: heightCell*0.1)
            } else {
                customCell.titleEmergency.alpha = 1
                customCell.descriptionEmergency.alpha = 1
                customCell.peopleRequestEmergency.alpha = 1
                
                customCell.titleEmergency.text = emergencySendTrueName[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)].uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.95, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = emergencySendTrueDescription[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)]
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.35, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = emergencySendTrueUser[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)]
                customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.7, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
            }
        }
        
        return customCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allEmergency.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if allEmergency[indexPath.row] == "accepted" || allEmergency[indexPath.row] == "pending" {
            return CGSize(width: view.frame.width, height: heightCell*0.4)
        } else if allEmergency[indexPath.row] == "no-request" {
            return CGSize(width: view.frame.width, height: heightCell*0.6)
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
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let url = "comgooglemaps://?q=\(self.emergencyReceiveLat[sender.tag]),\(self.emergencyReceiveLon[sender.tag])&zoom=14"
            UIApplication.shared.open(URL(string: url)!)
        } else {
            if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
                let url = "http://maps.apple.com?q=\(self.emergencyReceiveLat[sender.tag]),\(self.emergencyReceiveLon[sender.tag])&z=14"
                UIApplication.shared.open(URL(string: url)!)
            } else {
                GlobalFunc().alertCustom(stringAlertTitle: "Not location map available", stringAlertDescription: "Download Apple Maps or Google maps", button: "Cancel", s: self)
            }
        }
    }
    
    //OK/NO
    func emergencyOk(_ sender: UIButton) {
        
        GlobalFunc().alertCustom(stringAlertTitle: "Thank's", stringAlertDescription: "You help your friends", button: "OK", s: self)
        emergencySendFalse.insert(emergencyReceive[sender.tag], at: 1)
        emergencyReceive.remove(at: sender.tag)
        allEmergency.removeAll()
        
        print("L'utente ", GlobalUser.email, " vuole aiutare la tua emergenza ", sender.tag)
        
        if emergencyReceive.count == 0 {
            emergencyReceive.append("no-request")
        }
        
        allEmergency.append(contentsOf: emergencyReceive)
        allEmergency.append(contentsOf: emergencySendFalse)
        allEmergency.append(contentsOf: emergencySendTrue)
        
        self.collectionView?.reloadData()
    }
    func emergencyNo(_ sender: UIButton) {
        
        emergencyReceive.remove(at: sender.tag)
        allEmergency.removeAll()
        
        print("L'utente ", GlobalUser.email, " non vuole aiutare la tua emergenza ", sender.tag)
        GlobalFunc().alertCustom(stringAlertTitle: "Come on", stringAlertDescription: "You don't help your friends", button: "Sorry I'm busy", s: self)
        
        if emergencyReceive.count == 0 {
            emergencyReceive.append("no-request")
        }
        
        allEmergency.append(contentsOf: emergencyReceive)
        allEmergency.append(contentsOf: emergencySendFalse)
        allEmergency.append(contentsOf: emergencySendTrue)
        
        self.collectionView?.reloadData()
    }
    
    func addNeed() {
        let newViewController = addEmergency()
        self.navigationController?.pushViewController(newViewController, animated: true)        
    }
    
}
