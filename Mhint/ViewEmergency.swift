//
//  Emergency.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire

class EmergencyController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UITextFieldDelegate {
    
    let customCellIdentifier = "cellId"
    
    let heightCell = GlobalSize().heightScreen*0.2
    
    var emergencyReceive = [String]()
    var emergencyReceiveName = [String]()
    var emergencyReceiveDescription = [String]()
    var emergencyReceiveUser = [String]()
    var emergencyReceiveLat = [Double]()
    var emergencyReceiveLon = [Double]()
    
    var emergencySendFalse = ["accepted"]
    var emergencySendFalseName = [""]
    var emergencySendFalseDescription = [""]
    var emergencySendFalseUser = [""]
    var emergencySendFalseUserImage = [""]
    var emergencySendFalseLat = [0.0]
    var emergencySendFalseLon = [0.0]
    
    var emergencySendTrue = ["pending"]
    var emergencySendTrueName = [""]
    var emergencySendTrueDescription = [""]
    var emergencySendTrueUser = [""]
    var emergencySendTrueUserImage = [""]
    
    var allEmergency = [String]()
    
    var timer:Timer!
    
    var boolCall1 = false
    var boolCall2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "NEEDS & EMERGENCY")
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: GlobalSize().widthScreen*0.25, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen*0.5, height:  GlobalSize().widthScreen*0.5), nameGif: "load")
        
        //RICHIEDE DAL SERVER
        getEmergencyPending()
        getEmergencyAccepted()
        
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
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if saveData.bool(forKey: "earlyAddEmergency") {
            boolCall1 = false
            boolCall2 = false
            emergencyReceive.removeAll()
            emergencyReceiveName.removeAll()
            emergencyReceiveDescription.removeAll()
            emergencyReceiveUser.removeAll()
            emergencyReceiveLat.removeAll()
            emergencyReceiveLon.removeAll()
            
            emergencySendFalse.removeAll()
            emergencySendFalseName.removeAll()
            emergencySendFalseDescription.removeAll()
            emergencySendFalseUser.removeAll()
            emergencySendFalseUserImage.removeAll()
            emergencySendFalseLat.removeAll()
            emergencySendFalseLon.removeAll()
            
            emergencySendTrue.removeAll()
            emergencySendTrueName.removeAll()
            emergencySendTrueDescription.removeAll()
            emergencySendTrueUser.removeAll()
            emergencySendTrueUserImage.removeAll()
            
            emergencySendFalse.append("accepted")
            emergencySendFalseName.append("")
            emergencySendFalseDescription.append("")
            emergencySendFalseUser.append("")
            emergencySendFalseUserImage.append("")
            
            emergencySendTrue.append("pending")
            emergencySendTrueName.append("")
            emergencySendTrueDescription.append("")
            emergencySendTrueUser.append("")
            emergencySendTrueUserImage.append("")
            
            self.view.willRemoveSubview(collectionView!)
            
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
            
            getEmergencyPending()
            getEmergencyAccepted()
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
            saveData.set(false, forKey: "earlyAddEmergency")
        }
    }
    
    func showCollectionView() {
        
        if boolCall1 && boolCall2 {
            timer.invalidate()
            
            print("FINITO\n\n\n\n")
            
            print(allEmergency)
            
            if emergencyReceive.count == 0 {
                emergencyReceive.append("no-request")
                allEmergency.insert("no-request", at: 0)
            }
            
            print(emergencyReceive)
            print(emergencyReceiveName)
            print(emergencyReceiveDescription)
            print(emergencyReceiveUser)
            
            print("\n")
            
            if emergencySendFalse.count == 1 {
                emergencySendFalse.removeAll()
                emergencySendFalse.append("no-accepted")
                if let index = allEmergency.index(of: "accepted") {
                    allEmergency[index] = "no-accepted"
                }
            } else {
                emergencySendFalse[0] = "accepted"
                if let index = allEmergency.index(of: "no-accepted") {
                    allEmergency[index] = "accepted"
                }
            }
            
            print(emergencySendFalse)
            print(emergencySendFalseName)
            print(emergencySendFalseDescription)
            print(emergencySendFalseUser)
            
            print("\n")
            
            
            if emergencySendTrue.count == 1 {
                emergencySendTrue.removeAll()
                emergencySendTrue.append("no-pending")
                if let index = allEmergency.index(of: "pending") {
                    allEmergency[index] = "no-pending"
                }
            } else {
                emergencySendTrue[0] = "pending"
                if let index = allEmergency.index(of: "no-pending") {
                    allEmergency[index] = "pending"
                }
            }
            
            print(emergencySendTrue)
            print(emergencySendTrueName)
            print(emergencySendTrueDescription)
            print(emergencySendTrueUser)
            
            print(allEmergency)
            
            GlobalFunc().removeLoadingChat(s: self)
            collectionView?.reloadData()
            self.view.addSubview(collectionView!)
            
        }
    }
    
    
    func getEmergencyPending() {
        Alamofire.request("https://api.mhint.eu/needs?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { response in
            if let items = response.result.value as? [[String: Any]] {
                if items.count == 0 {
                    self.boolCall1 = true
                } else {
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
                            self.emergencySendTrueUserImage.append(user["image_profile"] as! String)
                        }
                        
                        if self.emergencySendTrue.count == items.count+1 {
                            self.allEmergency.removeAll()
                            self.allEmergency.append(contentsOf: self.emergencyReceive)
                            self.allEmergency.append(contentsOf: self.emergencySendFalse)
                            self.allEmergency.append(contentsOf: self.emergencySendTrue)
                            self.boolCall1 = true
                        }
                    }
                }
            }
        }
    }
    
    func getEmergencyAccepted() {
        Alamofire.request("https://api.mhint.eu/requests?mail=\(GlobalUser.email)", encoding: JSONEncoding.default).responseJSON { response in
            if let items = response.result.value as? [[String: Any]] {
                self.emergencyReceive.removeAll()
                if items.count == 0 {
                    self.boolCall2 = true
                } else {
                    for item in items {
                        if String(describing: item["status"]!) == "pending" {
                            self.emergencyReceive.append(item["_id"] as! String)
                            self.emergencyReceiveName.append(item["name"] as! String)
                            
                            let time = item["created_at"] as! String
                            let timeHour = time.components(separatedBy: "T")[1].components(separatedBy: ".")[0].components(separatedBy: ":")
                            
                            let description = item["description"] as! String
                            if description != "" {
                                self.emergencyReceiveDescription.append(description)
                            } else {
                                self.emergencyReceiveDescription.append("")
                            }
                        
                            if let user = item["user_sender"] as? [String: Any] {
                                self.emergencyReceiveUser.append(user["name"] as! String + " at " + timeHour[0] + ":" + timeHour[1])
                            }
                            if let position = item["display_position"] as? [String: Double] {
                                self.emergencyReceiveLat.append(position["lat"]!)
                                self.emergencyReceiveLon.append(position["long"]!)
                            }
                        } else if String(describing: item["status"]!) == "accepted" {
                            
                            self.emergencySendFalse.append(item["_id"] as! String)
                            self.emergencySendFalseName.append(item["name"] as! String)
                            
                            if String(describing: item["description"]!) != "" {
                                self.emergencySendFalseDescription.append(item["description"]! as! String)
                            } else {
                                self.emergencySendFalseDescription.append("")
                            }
                            
                            if let user = item["user_sender"] as? [String: Any] {
                                self.emergencySendFalseUser.append(user["name"] as! String)
                                self.emergencySendFalseUserImage.append(user["image_profile"] as! String)
                            }
                            if let position = item["display_position"] as? [String: Double] {
                                self.emergencySendFalseLat.append(position["lat"]!)
                                self.emergencySendFalseLon.append(position["long"]!)
                            }
                        }
                        
                        if (self.emergencyReceive.count + self.emergencySendFalse.count) == items.count+1 {
                            self.allEmergency.removeAll()
                            self.allEmergency.append(contentsOf: self.emergencyReceive)
                            self.allEmergency.append(contentsOf: self.emergencySendFalse)
                            self.allEmergency.append(contentsOf: self.emergencySendTrue)
                            self.boolCall2 = true
                        }
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
        customCell.userImg.alpha = 0
        customCell.btnClose.alpha = 0
        customCell.btnPosition.alpha = 0
        
        if indexPath.row < emergencyReceive.count {
            if allEmergency[indexPath.row] == "no-request" {
                
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "No one ask your help yet".uppercased()
                customCell.titleTextViewDivide.font = UIFont(name: "AvenirLTStd-Black", size: 13)
                customCell.titleTextViewDivide.textAlignment = .center
                customCell.titleTextViewDivide.addTextSpacing()
                customCell.titleTextViewDivide.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: heightCell*0.6)
                
            } else {
                
                customCell.titleEmergency.alpha = 1
                customCell.descriptionEmergency.alpha = 1
                customCell.peopleRequestEmergency.alpha = 1
                customCell.btnNo.alpha = 1
                customCell.btnOk.alpha = 1
                customCell.btnMaps.alpha = 1
                
                customCell.titleEmergency.text = emergencyReceiveName[indexPath.row].uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.7, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = emergencyReceiveDescription[indexPath.row]
                if emergencyReceiveDescription[indexPath.row] == "" {
                    customCell.descriptionEmergency.text = "Was in a hurry he couldn't even write a description."
                    customCell.descriptionEmergency.textColor = .lightGray
                }
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.3, width: GlobalSize().widthScreen*0.65, height: heightCell*0.3)
                
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
            if allEmergency[indexPath.row] == "no-accepted" {
                customCell.backgroundColor = .white
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
                customCell.userImg.alpha = 1
                customCell.btnPosition.alpha = 1
                
                customCell.titleEmergency.text = emergencySendFalseName[indexPath.row-emergencyReceive.count].uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.95, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = emergencySendFalseDescription[indexPath.row-emergencyReceive.count]
                customCell.descriptionEmergency.delegate = self
                if emergencySendFalseDescription[indexPath.row-emergencyReceive.count] == "" {
                    customCell.descriptionEmergency.text = emergencySendFalseUser[indexPath.row-emergencyReceive.count] + " was too busy."
                    customCell.descriptionEmergency.textColor = .lightGray
                }
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.3, width: GlobalSize().widthScreen*0.8, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = "You accepted \(emergencySendFalseUser[indexPath.row-emergencyReceive.count])'s need"
                customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft+heightCell*0.3, y: heightCell*0.65, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
                
                customCell.userImg.frame = CGRect(x: marginLeft, y: heightCell*0.66, width: heightCell*0.22, height: heightCell*0.22)
                customCell.userImg.layer.cornerRadius = heightCell*0.11
                customCell.userImg.sd_setImage(with: URL(string: emergencySendFalseUserImage[indexPath.row-emergencyReceive.count]), placeholderImage: nil)
                
                customCell.btnPosition.frame = CGRect(x: GlobalSize().widthScreen*0.87, y: heightCell*0.7, width: heightCell*0.2, height: heightCell*0.2)
                customCell.btnPosition.tag = indexPath.row-emergencyReceive.count
                customCell.btnPosition.addTarget(self, action: #selector(openMapsToAccept), for: .touchUpInside)
            }
        } else if indexPath.row < (emergencyReceive.count + emergencySendFalse.count + emergencySendTrue.count) {
            if allEmergency[indexPath.row] == "no-pending" {
                customCell.backgroundColor = .white
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
                customCell.userImg.alpha = 1
                customCell.btnClose.alpha = 1
                
                customCell.titleEmergency.text = emergencySendTrueName[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)].uppercased()
                customCell.titleEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.14, width: GlobalSize().widthScreen*0.8, height: heightCell*0.12)
                
                customCell.descriptionEmergency.text = emergencySendTrueDescription[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)]
                customCell.descriptionEmergency.delegate = self
                if emergencySendTrueDescription[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)] == "" {
                    customCell.descriptionEmergency.text = emergencySendTrueUser[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)] + " was too busy."
                    customCell.descriptionEmergency.textColor = .lightGray
                }
                customCell.descriptionEmergency.frame = CGRect(x: marginLeft, y: heightCell*0.3, width: GlobalSize().widthScreen*0.85, height: heightCell*0.3)
                
                customCell.peopleRequestEmergency.text = emergencySendTrueUser[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)]
                customCell.peopleRequestEmergency.frame = CGRect(x: marginLeft+heightCell*0.3, y: heightCell*0.65, width: GlobalSize().widthScreen*0.95, height: heightCell*0.3)
                
                customCell.userImg.frame = CGRect(x: marginLeft, y: heightCell*0.66, width: heightCell*0.22, height: heightCell*0.22)
                customCell.userImg.layer.cornerRadius = heightCell*0.11
                customCell.userImg.sd_setImage(with: URL(string: emergencySendTrueUserImage[indexPath.row - (emergencyReceive.count + emergencySendFalse.count)]), placeholderImage: nil)
                
                customCell.btnClose.frame = CGRect(x: GlobalSize().widthScreen*0.87, y: heightCell*0.7, width: heightCell*0.2, height: heightCell*0.2)
                customCell.btnClose.tag = indexPath.row
                customCell.btnClose.addTarget(self, action: #selector(removeEmergency), for: .touchUpInside)
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
        } else if allEmergency[indexPath.row] == "no-accepted" || allEmergency[indexPath.row] == "no-pending" {
            return CGSize(width: view.frame.width, height: 0)
        } else {
            return CGSize(width: view.frame.width, height: heightCell)
        }
    }
    //COLLECTIONVIEW
    
    
    //HEADER
    func header() {
        GlobalFunc().titlePage(titlePage: "Needs & Emergency.", s: self)
        let description = UITextView()
        description.text = "Welcome in the Needs & Emergency section\nAsk or answer somebody else needs!"
        description.textColor = GlobalColor().colorBlack
        description.isEditable = false
        description.isScrollEnabled = false
        description.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        description.frame = CGRect(x: GlobalSize().widthScreen*0.04, y: GlobalSize().heightScreen*0.18, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.15)
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
    func openMapsToAccept(_ sender: UIButton) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let url = "comgooglemaps://?q=\(self.emergencySendFalseLat[sender.tag]),\(self.emergencySendFalseLon[sender.tag])&zoom=14"
            UIApplication.shared.open(URL(string: url)!)
        } else {
            if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
                let url = "http://maps.apple.com?q=\(self.emergencySendFalseLat[sender.tag]),\(self.emergencySendFalseLon[sender.tag])&z=14"
                UIApplication.shared.open(URL(string: url)!)
            } else {
                GlobalFunc().alertCustom(stringAlertTitle: "Not location map available", stringAlertDescription: "Download Apple Maps or Google maps", button: "Cancel", s: self)
            }
        }
    }
    
    //OK/NO
    func emergencyOk(_ sender: UIButton) {
        
        let parameter = [
            "request_id": emergencyReceive[sender.tag]
            , "status": "accepted"
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/needresponse", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in }
        
        GlobalFunc().alertCustom(stringAlertTitle: "Thanks", stringAlertDescription: "You helped your friend!", button: "OK", s: self)
        
        boolCall1 = false
        boolCall2 = false
        
        emergencyReceive.removeAll()
        emergencyReceiveName.removeAll()
        emergencyReceiveDescription.removeAll()
        emergencyReceiveUser.removeAll()
        emergencyReceiveLat.removeAll()
        emergencyReceiveLon.removeAll()
        
        emergencySendFalse.removeAll()
        emergencySendFalseName.removeAll()
        emergencySendFalseDescription.removeAll()
        emergencySendFalseUser.removeAll()
        emergencySendFalseUserImage.removeAll()
        
        emergencySendTrue.removeAll()
        emergencySendTrueName.removeAll()
        emergencySendTrueDescription.removeAll()
        emergencySendTrueUser.removeAll()
        emergencySendTrueUserImage.removeAll()
        
        emergencySendFalse.append("accepted")
        emergencySendFalseName.append("")
        emergencySendFalseDescription.append("")
        emergencySendFalseUser.append("")
        emergencySendFalseUserImage.append("")
        
        emergencySendTrue.append("pending")
        emergencySendTrueName.append("")
        emergencySendTrueDescription.append("")
        emergencySendTrueUser.append("")
        emergencySendTrueUserImage.append("")
        
        self.view.willRemoveSubview(collectionView!)
        
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
        
        getEmergencyPending()
        getEmergencyAccepted()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        
    }
    func emergencyNo(_ sender: UIButton) {
        
        let parameter = [
            "request_id": emergencyReceive[sender.tag]
            , "status": "refused"
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/needresponse", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in }
        
        GlobalFunc().alertCustom(stringAlertTitle: "Come on", stringAlertDescription: "You don't help your friends", button: "Sorry I'm busy", s: self)
        
        boolCall1 = false
        boolCall2 = false
        
        emergencyReceive.removeAll()
        emergencyReceiveName.removeAll()
        emergencyReceiveDescription.removeAll()
        emergencyReceiveUser.removeAll()
        emergencyReceiveLat.removeAll()
        emergencyReceiveLon.removeAll()
        
        emergencySendFalse.removeAll()
        emergencySendFalseName.removeAll()
        emergencySendFalseDescription.removeAll()
        emergencySendFalseUser.removeAll()
        emergencySendFalseUserImage.removeAll()
        
        emergencySendTrue.removeAll()
        emergencySendTrueName.removeAll()
        emergencySendTrueDescription.removeAll()
        emergencySendTrueUser.removeAll()
        emergencySendTrueUserImage.removeAll()
        
        emergencySendFalse.append("accepted")
        emergencySendFalseName.append("")
        emergencySendFalseDescription.append("")
        emergencySendFalseUser.append("")
        emergencySendFalseUserImage.append("")
        
        emergencySendTrue.append("pending")
        emergencySendTrueName.append("")
        emergencySendTrueDescription.append("")
        emergencySendTrueUser.append("")
        emergencySendTrueUserImage.append("")
        
        self.view.willRemoveSubview(collectionView!)
        
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
        
        getEmergencyPending()
        getEmergencyAccepted()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        
    }
    
    func removeEmergency(_ sender: UIButton) {
        
        let parameter = [
            "request_id": allEmergency[sender.tag]
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/needcomplete", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in }
        
        GlobalFunc().alertCustom(stringAlertTitle: "Emergency completed", stringAlertDescription: "This emergency was remove", button: "Perfect", s: self)
        
        boolCall1 = false
        boolCall2 = false
        
        emergencyReceive.removeAll()
        emergencyReceiveName.removeAll()
        emergencyReceiveDescription.removeAll()
        emergencyReceiveUser.removeAll()
        emergencyReceiveLat.removeAll()
        emergencyReceiveLon.removeAll()
        
        emergencySendFalse.removeAll()
        emergencySendFalseName.removeAll()
        emergencySendFalseDescription.removeAll()
        emergencySendFalseUser.removeAll()
        emergencySendFalseUserImage.removeAll()
        
        emergencySendTrue.removeAll()
        emergencySendTrueName.removeAll()
        emergencySendTrueDescription.removeAll()
        emergencySendTrueUser.removeAll()
        emergencySendTrueUserImage.removeAll()
        
        emergencySendFalse.append("accepted")
        emergencySendFalseName.append("")
        emergencySendFalseDescription.append("")
        emergencySendFalseUser.append("")
        emergencySendFalseUserImage.append("")
        
        emergencySendTrue.append("pending")
        emergencySendTrueName.append("")
        emergencySendTrueDescription.append("")
        emergencySendTrueUser.append("")
        emergencySendTrueUserImage.append("")
        
        self.view.willRemoveSubview(collectionView!)
        
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
        
        getEmergencyPending()
        getEmergencyAccepted()
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        
    }
    
    func addNeed() {
        let newViewController = addEmergency()
        self.navigationController?.pushViewController(newViewController, animated: true)        
    }
    
}
