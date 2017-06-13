//
//  Emergency.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire
import Whisper
import MapKit
import AVFoundation

class EmergencyController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UITextFieldDelegate {
    
    let customCellIdentifier = "cellId"
    
    var player: AVAudioPlayer?
    
    let viewOverlay = UIButton()
    var blurEffectView = UIVisualEffectView()
    let map = MKMapView()
    let img = UIImageView()
    let lbl = UILabel()
    let btn = UIButton()
    
    let heightCell = GlobalSize().heightScreen*0.2
    
    var emergencyReceive = [String]()
    var emergencyReceiveName = [String]()
    var emergencyReceiveDescription = [String]()
    var emergencyReceiveUser = [String]()
    var emergencyReceiveUserImage = [String]()
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
        
        UIApplication.shared.statusBarView?.backgroundColor = .white
        saveData.set(false, forKey: "earlyAddEmergency")
        
        self.view.backgroundColor = .white
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "NEEDS & EMERGENCY")
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: GlobalSize().widthScreen*0.25, y: GlobalSize().heightScreen*0.4, width: GlobalSize().widthScreen*0.5, height:  GlobalSize().widthScreen*0.5), nameGif: "load-long")
        
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
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if saveData.bool(forKey: "earlyAddEmergency") {
            saveData.set(false, forKey: "earlyAddEmergency")
            
            boolCall1 = false
            boolCall2 = false
            
            emergencyReceive.removeAll()
            emergencyReceiveName.removeAll()
            emergencyReceiveDescription.removeAll()
            emergencyReceiveUser.removeAll()
            emergencyReceiveUserImage.removeAll()
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
            
            getEmergencyPending()
            getEmergencyAccepted()
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        }
    }
    
    func showCollectionView() {
        if boolCall1 && boolCall2 && emergencyReceive.count == 0 && emergencySendFalse.count == 1 && emergencySendTrue.count == 1 {
            emergencySendFalse.removeAll()
            emergencySendTrue.removeAll()
            emergencyReceive.append("no-request")
            emergencySendFalse.insert("no-accepted", at: 0)
            emergencySendTrue.insert("no-pending", at: 0)
            
            allEmergency.removeAll()
            allEmergency.append(contentsOf: emergencyReceive)
            allEmergency.append(contentsOf: emergencySendFalse)
            allEmergency.append(contentsOf: emergencySendTrue)
        } else if boolCall1 && boolCall2 {
            timer.invalidate()
            
            if emergencyReceive.count == 0 {
                emergencyReceive.append("no-request")
                allEmergency.insert("no-request", at: 0)
            }
            
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
            
            GlobalFunc().removeLoadingChat(s: self)
            collectionView?.reloadData()
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
                                self.emergencyReceiveUserImage.append(user["image_profile"] as! String)
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
                customCell.titleTextViewDivide.text = "No one asked for your help yet".uppercased()
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
                customCell.btnMaps.addTarget(self, action: #selector(openPopUpMap), for: .touchUpInside)
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
                customCell.btnPosition.addTarget(self, action: #selector(openPopUpMapAccepted), for: .touchUpInside)
            }
        } else if indexPath.row < (emergencyReceive.count + emergencySendFalse.count + emergencySendTrue.count) {
            if allEmergency[indexPath.row] == "no-pending" {
                customCell.backgroundColor = .white
            }
            else if allEmergency[indexPath.row] == "pending" {
                customCell.backgroundColor = .white
                customCell.titleTextViewDivide.alpha = 1
                customCell.titleTextViewDivide.text = "your requests".uppercased()
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
                    customCell.descriptionEmergency.text = "Was in a hurry he couldn't even write a description."
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
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        viewOverlay.backgroundColor = .black
        viewOverlay.alpha = 0
        viewOverlay.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen)
        self.navigationController?.view.addSubview(viewOverlay)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.viewOverlay.alpha = 0.6
        }, completion: nil)
        
        let parameter = [
            "request_id": emergencyReceive[sender.tag]
            , "status": "accepted"
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/needresponse", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in
            self.animationImage(i: "ok-popup", n: "Ok I'll do it!", color: GlobalColor().greenSea.cgColor)
        }
    }
    
    func emergencyNo(_ sender: UIButton) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        viewOverlay.backgroundColor = .black
        viewOverlay.alpha = 0
        viewOverlay.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen)
        self.navigationController?.view.addSubview(viewOverlay)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.viewOverlay.alpha = 0.6
        }, completion: nil)
        
        let parameter = [
            "request_id": emergencyReceive[sender.tag]
            , "status": "refused"
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/needresponse", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in
            self.animationImage(i: "no-popup", n: "Sorry I'm busy", color: GlobalColor().red.cgColor)
        }
    }
    
    func removeEmergency(_ sender: UIButton) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.backgroundColor = .black
        blurEffectView.alpha = 0.4
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.navigationController?.view.addSubview(blurEffectView)
        
        UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.blurEffectView.alpha = 0.7
        }, completion: nil)
        
        let parameter = [
            "request_id": allEmergency[sender.tag]
            ] as [String : Any]
        Alamofire.request("https://api.mhint.eu/needcomplete", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in
            self.animationImage(i: "remove", n: "I don't need it anymore", color: UIColor.darkGray.cgColor)
        }
    }
    
    func animationImage(i: String, n: String, color: CGColor) {
        
        self.boolCall1 = false
        self.boolCall2 = false
        
        self.emergencyReceive.removeAll()
        self.emergencyReceiveName.removeAll()
        self.emergencyReceiveDescription.removeAll()
        self.emergencyReceiveUser.removeAll()
        self.emergencyReceiveUserImage.removeAll()
        self.emergencyReceiveLat.removeAll()
        self.emergencyReceiveLon.removeAll()
        
        self.emergencySendFalse.removeAll()
        self.emergencySendFalseName.removeAll()
        self.emergencySendFalseDescription.removeAll()
        self.emergencySendFalseUser.removeAll()
        self.emergencySendFalseUserImage.removeAll()
        
        self.emergencySendTrue.removeAll()
        self.emergencySendTrueName.removeAll()
        self.emergencySendTrueDescription.removeAll()
        self.emergencySendTrueUser.removeAll()
        self.emergencySendTrueUserImage.removeAll()
        
        self.emergencySendFalse.append("accepted")
        self.emergencySendFalseName.append("")
        self.emergencySendFalseDescription.append("")
        self.emergencySendFalseUser.append("")
        self.emergencySendFalseUserImage.append("")
        
        self.emergencySendTrue.append("pending")
        self.emergencySendTrueName.append("")
        self.emergencySendTrueDescription.append("")
        self.emergencySendTrueUser.append("")
        self.emergencySendTrueUserImage.append("")
        
        self.getEmergencyPending()
        self.getEmergencyAccepted()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.showCollectionView), userInfo: nil, repeats: true)
        
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        guard let url = Bundle.main.url(forResource: "bamboo", withExtension: "mp3") else {
            print("error")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
        } catch let error { }
        let v = UIView()
        v.frame = CGRect(x: GlobalSize().widthScreen*0.4, y: GlobalSize().heightScreen*1.5, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
        v.backgroundColor = .white
        v.layer.cornerRadius = GlobalSize().widthScreen*0.1
        v.layer.masksToBounds = true
        v.alpha = 1
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.6
        v.layer.shadowRadius = GlobalSize().widthScreen*0.1
        self.navigationController?.view.addSubview(v)
        
        let imgProfile = UIImageView()
        imgProfile.frame = CGRect(x: GlobalSize().widthScreen*0.42, y: GlobalSize().heightScreen*1.5, width: GlobalSize().widthScreen*0.16, height: GlobalSize().widthScreen*0.16)
        let img = UIImage(named: i)
        imgProfile.image = img
        self.navigationController?.view.addSubview(imgProfile)
        
        let label = UILabel()
        label.text = n.uppercased()
        label.alpha = 0
        label.addTextSpacing()
        label.textColor = .white
        label.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.03)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.475, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.navigationController?.view.addSubview(label)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            imgProfile.frame.origin.y = GlobalSize().heightScreen*0.38
            v.frame.origin.y = GlobalSize().heightScreen*0.37
        }, completion: nil)
        let when = DispatchTime.now() + 0.6
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.player?.play()
            self.blurEffectView.layer.removeAllAnimations()
        }
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
            label.alpha = 1
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.2, delay: 1, options: .curveLinear, animations: {
                label.alpha = 0
                imgProfile.alpha = 0
                self.viewOverlay.alpha = 0
                self.blurEffectView.alpha = 0
                v.alpha = 0
            }, completion: nil)
        })
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            self.btn.alpha = 0
            self.lbl.alpha = 0
            self.img.alpha = 0
            self.map.alpha = 0
            self.viewOverlay.alpha = 0
        })
    }
    
    func openPopUpMap(_ sender: UIButton) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        viewOverlay.backgroundColor = .black
        viewOverlay.alpha = 0
        viewOverlay.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        viewOverlay.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen)
        self.navigationController?.view.addSubview(viewOverlay)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.viewOverlay.alpha = 0.8
        }, completion: nil)
        
        map.showsBuildings = true
        let coordinates = CLLocationCoordinate2DMake(emergencyReceiveLat[sender.tag],emergencyReceiveLon[sender.tag])
        map.region = MKCoordinateRegionMakeWithDistance(coordinates, 0,0)
        map.mapType = MKMapType.standard
        
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coordinates
        mapCamera.pitch = 45
        mapCamera.altitude = 100
        mapCamera.heading = 0
        
        map.camera = mapCamera
        map.frame = CGRect(x: GlobalSize().widthScreen*0.4, y: GlobalSize().heightScreen*1.5, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
        map.layer.cornerRadius = 8
        map.alpha = 1
        map.layer.masksToBounds = true
        map.mapType = MKMapType.standard
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
        self.navigationController?.view.addSubview(map)
        
        img.sd_setImage(with: URL(string: emergencyReceiveUserImage[sender.tag]), placeholderImage: nil)
        img.alpha = 0
        img.frame = CGRect(x: GlobalSize().widthScreen*0.5, y: GlobalSize().heightScreen*0.58, width: GlobalSize().widthScreen*0, height: GlobalSize().widthScreen*0)
        img.layer.cornerRadius = GlobalSize().widthScreen*0.1
        img.layer.masksToBounds = true
        img.layer.borderWidth = 3
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowOpacity = 0.6
        img.layer.shadowRadius = GlobalSize().widthScreen*0.1
        self.navigationController?.view.addSubview(img)
        
        let user = emergencyReceiveUser[sender.tag].components(separatedBy: " at ")[0]
        lbl.text = "\(user) was here."
        lbl.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.07)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.alpha = 0
        lbl.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.65, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.navigationController?.view.addSubview(lbl)
        
        btn.setTitle("Open in Maps".uppercased(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.03)
        btn.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.7, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        btn.alpha = 0
        btn.tag = sender.tag
        btn.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        self.navigationController?.view.addSubview(btn)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            self.map.frame.origin.y = GlobalSize().heightScreen*0.38
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
                self.map.frame = CGRect(x: GlobalSize().widthScreen*0.15, y: GlobalSize().heightScreen*0.2, width: GlobalSize().widthScreen*0.7, height: GlobalSize().widthScreen*0.7)
                self.img.frame = CGRect(x: GlobalSize().widthScreen*0.4, y: GlobalSize().heightScreen*0.54, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
                self.btn.alpha = 1
                self.lbl.alpha = 1
                self.img.alpha = 1
            })
        })
    }
    
    func openPopUpMapAccepted(_ sender: UIButton) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        viewOverlay.backgroundColor = .black
        viewOverlay.alpha = 0
        viewOverlay.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        viewOverlay.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen)
        self.navigationController?.view.addSubview(viewOverlay)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.viewOverlay.alpha = 0.8
        }, completion: nil)
        
        map.showsBuildings = true
        print(sender.tag)
        print(emergencySendFalseLat)
        let coordinates = CLLocationCoordinate2DMake(emergencySendFalseLat[sender.tag],emergencySendFalseLon[sender.tag])
        map.region = MKCoordinateRegionMakeWithDistance(coordinates, 0,0)
        map.mapType = MKMapType.standard
        
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coordinates
        mapCamera.pitch = 45
        mapCamera.altitude = 100
        mapCamera.heading = 0
        
        map.camera = mapCamera
        map.frame = CGRect(x: GlobalSize().widthScreen*0.4, y: GlobalSize().heightScreen*1.5, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
        map.layer.cornerRadius = 8
        map.alpha = 1
        map.layer.masksToBounds = true
        map.mapType = MKMapType.standard
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        map.addAnnotation(annotation)
        self.navigationController?.view.addSubview(map)
        
        img.sd_setImage(with: URL(string: emergencySendFalseUserImage[sender.tag]), placeholderImage: nil)
        img.alpha = 0
        img.frame = CGRect(x: GlobalSize().widthScreen*0.5, y: GlobalSize().heightScreen*0.58, width: GlobalSize().widthScreen*0, height: GlobalSize().widthScreen*0)
        img.layer.cornerRadius = GlobalSize().widthScreen*0.1
        img.layer.masksToBounds = true
        img.layer.borderWidth = 3
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.shadowColor = UIColor.black.cgColor
        img.layer.shadowOpacity = 0.6
        img.layer.shadowRadius = GlobalSize().widthScreen*0.1
        self.navigationController?.view.addSubview(img)
        
        let user = emergencySendFalseUser[sender.tag].components(separatedBy: " at ")[0]
        lbl.text = "\(user) was here."
        lbl.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.07)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.alpha = 0
        lbl.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.65, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.navigationController?.view.addSubview(lbl)
        
        btn.setTitle("Open in Maps".uppercased(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.03)
        btn.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.7, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        btn.alpha = 0
        btn.tag = sender.tag
        btn.addTarget(self, action: #selector(openMapsToAccept), for: .touchUpInside)
        self.navigationController?.view.addSubview(btn)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            self.map.frame.origin.y = GlobalSize().heightScreen*0.38
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
                self.map.frame = CGRect(x: GlobalSize().widthScreen*0.15, y: GlobalSize().heightScreen*0.2, width: GlobalSize().widthScreen*0.7, height: GlobalSize().widthScreen*0.7)
                self.img.frame = CGRect(x: GlobalSize().widthScreen*0.4, y: GlobalSize().heightScreen*0.54, width: GlobalSize().widthScreen*0.2, height: GlobalSize().widthScreen*0.2)
                self.btn.alpha = 1
                self.lbl.alpha = 1
                self.img.alpha = 1
            })
        })
    }
    
    func addNeed() {
        let newViewController = addEmergency()
        self.navigationController?.pushViewController(newViewController, animated: true)        
    }
    
}
