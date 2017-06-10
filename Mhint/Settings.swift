//
//  Settings.swift
//  Mhint
//
//  Created by Andrea Merli on 20/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//
import UIKit
import SwiftyGif

import Alamofire //INTERNET
import HealthKit //SALUTE

class SettingsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    //CLASSI ESTERNE2
    let globalColor = GlobalColor()
    let globalFunction = GlobalFunc()
    let globalSize = GlobalSize()
    
    //HEALTHKIT
    let healthManager:HKHealthStore = HKHealthStore()
    
    //PROFILE
    var imgProfileImage = UIImage()
    let buttonImgProfile = UIImageView()
    
    //LOADING
    let imageview = UIImageView(gifImage: UIImage(gifName: "load"), manager: SwiftyGifManager(memoryLimit:20))
    
    //CollectionView
    let customCellIdentifier = "customCellIdentifier"
    let settingsSection = ["Connect your account", "Bots", "Your activity", "Food", "Needs & Emergency"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        globalFunction.navBar(nav: navigationItem, s: self, show: true) //navigation bar
        globalFunction.navBarRightChat(nav: navigationItem, s: self) //navigation v.a.
        
        header()
        
        profileImage()
        
        profileData()
        
        socialConnection()
        
        collectionViewFunc()
    }
    
    //COLLECTIONVIEW
    func collectionViewFunc() {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: GlobalSize().widthScreen, height: 90)
        
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.contentInset.top = -60
        collectionView?.frame = CGRect(x: 0, y: self.globalSize.heightScreen*0.39, width: self.globalSize.widthScreen, height: self.globalSize.heightScreen*0.61)
        collectionView?.register(CustomCellSetting.self, forCellWithReuseIdentifier: customCellIdentifier)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCellSetting
        let sizeArrow = self.globalSize.widthScreen*0.05
        let marginLeft = 25
        var heightRow = 90
        
        if indexPath.row == 2 {
            customCell.backgroundColor = .white
            heightRow = 70
            customCell.arrow.alpha = 0
            customCell.titleTextView.alpha = 0
            customCell.titleTextViewDivide.text = settingsSection[indexPath.row]
        }
        else if (indexPath.row > 2){
            heightRow = 70
            customCell.arrow.alpha = 0
            customCell.titleTextViewDivide.alpha = 0
            customCell.titleTextView.text = settingsSection[indexPath.row]
            
            customCell.switchSection.alpha = 1
            customCell.switchSection.frame = CGRect(x: self.globalSize.widthScreen*0.8, y: (CGFloat(heightRow)-customCell.switchSection.frame.size.height)/2, width: 0, height: 0)
            customCell.switchSection.isEnabled = false
            
            if indexPath.row == 3 {
                customCell.switchSection.isOn = saveData.bool(forKey: "food")
            } else if indexPath.row == 4 {
                customCell.switchSection.isOn = saveData.bool(forKey: "need")
            }
            
            customCell.switchSection.tag = indexPath.row
            customCell.switchSection.addTarget(self, action: #selector(switchSection), for: UIControlEvents.valueChanged)
            
        }
        else{
            heightRow = 90
            customCell.titleTextViewDivide.alpha = 0
            customCell.arrow.frame = CGRect(x: self.globalSize.widthScreen-sizeArrow-10, y: (CGFloat(heightRow)-sizeArrow)/2, width: sizeArrow, height: sizeArrow)
            customCell.titleTextView.text = settingsSection[indexPath.row]
        }
        customCell.titleTextView.frame = CGRect(x: marginLeft, y: 0, width: Int(self.globalSize.widthScreen/2), height: heightRow)
        customCell.titleTextViewDivide.frame = CGRect(x: marginLeft, y: 10, width: Int(self.globalSize.widthScreen/2), height: heightRow)
        
        return customCell
    }
    
    
    func switchSection(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        if mySwitch.tag == 3 {
            GlobalFunc().saveUserProfile(value: value, description: "food")
        } else if mySwitch.tag == 4 {
            GlobalFunc().saveUserProfile(value: value, description: "need")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCellSetting
        
        cell.switchSection.isOn = !cell.switchSection.isOn
        
        if indexPath.row == 0 {
            let newViewController = socialController(collectionViewLayout: layout)
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        else if indexPath.row == 1 {
            let newViewController = botController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        } else if indexPath.row == 3 && cell.switchSection.isOn {
            accessToHealth()
            saveData.set(cell.switchSection.isOn, forKey: "food")
            saveData.set(cell.switchSection.isOn, forKey: "loginHealth")
            updateSection()
        } else if indexPath.row == 3 && !cell.switchSection.isOn {
            saveData.set(cell.switchSection.isOn, forKey: "food")
            saveData.set(cell.switchSection.isOn, forKey: "loginHealth")
            updateSection()
        } else if indexPath.row == 4 && cell.switchSection.isOn {
            takeNumber()
            saveData.set(cell.switchSection.isOn, forKey: "need")
            updateSection()
        } else if indexPath.row == 4 && !cell.switchSection.isOn {
            saveData.set(cell.switchSection.isOn, forKey: "need")
            updateSection()
        }
    }
    
    func updateSection() {
        let parameter = [
            "mail": GlobalUser.email
            , "sectionsEnabled": [
                "food": (saveData.bool(forKey: "food") ? 1 : 0)
                , "need": (saveData.bool(forKey: "need") ? 1 : 0)
            ]
            , "logins": [
                "facebook": saveData.bool(forKey: "loginFacebook") ? 1 : 0
                , "twitter": saveData.bool(forKey: "loginTwitter") ? 1 : 0
                , "google": saveData.bool(forKey: "loginGoogle") ? 1 : 0
                , "health": saveData.bool(forKey: "loginHealth") ? 1 : 0
            ]
        ] as [String : Any]
        
        Alamofire.request("https://api.mhint.eu/user", method: .put, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2{
            return CGSize(width: view.frame.width, height: 70)
        } else if(indexPath.row > 2){
            return CGSize(width: view.frame.width, height: 70)
        } else {
            return CGSize(width: view.frame.width, height: 90)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    //COLLECTIONVIEW
    
    //ALERT HEALHTKIT
    func accessToHealth() {
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!)
        
        guard timerHeight == nil else { return }
        
        healthManager.requestAuthorization(toShare: nil, read: readTypes) { (success, error) -> Void in
            GlobalFunc().alertCustom(stringAlertTitle: "Health succefully connect", stringAlertDescription: "", button: "OK", s: self)
        }
    }
    
    //ALERT NUMBER
    func takeNumber() {
        let alert = UIAlertController(title: "What's your number ?", message: "Type here", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
            textField.keyboardType = UIKeyboardType.phonePad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [] (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let firstTextField = (alert?.textFields![0])! as UITextField
            if let number = firstTextField.text {
                let num = Int(number)!
                if num > 0 {
                    GlobalUser.phoneNumber = number
                    
                    let parameter = [
                        "mail": GlobalUser.email
                        , "tel_number": number
                        ] as [String : Any]
                    
                    Alamofire.request("https://api.mhint.eu/user", method: .put, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                        print(response)
                    }
                    
                } else {
                    self.takeNumber()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func socialConnection() {
        let socialButton = UIButton()
        socialButton.frame = CGRect(x: self.globalSize.widthScreen*0.08, y: self.globalSize.heightScreen*0.09, width: self.globalSize.widthScreen, height: self.globalSize.widthScreen*0.1)
    }
    
    func header() {
        
        let settings = UILabel()
        settings.text = "Settings"
        settings.textColor = self.globalColor.colorBlack
        settings.font = UIFont(name: "AvenirLTStd-Medium", size: self.globalSize.widthScreen*0.035)
        settings.frame = CGRect(x: self.globalSize.widthScreen*0.1, y: self.globalSize.heightScreen*0.1, width: self.globalSize.widthScreen, height: self.globalSize.widthScreen*0.1)
        self.view.addSubview(settings)
        
        let name = UILabel()
        name.text = saveData.string(forKey: "nameProfile")
        name.textColor = self.globalColor.colorBlack
        name.font = UIFont(name: "AvenirLTStd-Medium", size: self.globalSize.widthScreen*0.07)
        name.frame = CGRect(x: self.globalSize.widthScreen*0.08, y: self.globalSize.heightScreen*0.145, width: self.globalSize.widthScreen, height: self.globalSize.widthScreen*0.1)
        self.view.addSubview(name)
        
    }
    
    func profileImage() {
        
        imageview.frame = CGRect(x: self.globalSize.widthScreen*0.15, y: self.globalSize.heightScreen*0.265, width: self.globalSize.widthScreen*0.09, height: self.globalSize.widthScreen*0.09)
        view.addSubview(imageview)
        
        self.buttonImgProfile.sd_setImage(with: URL(string: GlobalUser.imageProfile!), placeholderImage: nil)
        
        self.buttonImgProfile.frame = CGRect(x: self.globalSize.widthScreen*0.07, y: self.globalSize.heightScreen*0.22, width: self.globalSize.widthScreen*0.2, height: self.globalSize.widthScreen*0.2)
        
        self.buttonImgProfile.backgroundColor = .clear
        self.buttonImgProfile.layer.cornerRadius = self.globalSize.widthScreen*0.02
        self.buttonImgProfile.layer.borderWidth = self.globalSize.widthScreen*0.015
        self.buttonImgProfile.layer.borderColor = UIColor.clear.cgColor
        self.buttonImgProfile.layer.masksToBounds = true
        
        self.buttonImgProfile.layer.shadowColor = UIColor.black.cgColor
        self.buttonImgProfile.layer.shadowOpacity = 0.8
        self.buttonImgProfile.layer.shadowOffset = CGSize.zero
        self.buttonImgProfile.layer.shadowRadius = 10
        self.view.addSubview(self.buttonImgProfile)
        
    }
    
    func profileData(){
        
        let btnProfile = UIButton()
        btnProfile.backgroundColor = .clear
        btnProfile.frame = CGRect(x: 0, y: self.globalSize.heightScreen*0.2, width: self.globalSize.widthScreen, height: self.globalSize.heightScreen*0.16)
        btnProfile.addTarget(self, action: #selector(openEditProfile), for: .touchUpInside)
        self.view.addSubview(btnProfile)
        
        let place = UILabel()
        
        if saveData.string(forKey: "address") != nil {
            place.text = "\(saveData.string(forKey: "address")!)"
        } else {
            place.text = "Not address found"
        }
        if saveData.value(forKey: "birthday") != nil {
            if let birth = saveData.string(forKey: "birthday") {
                let b = birth.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
                place.text = place.text! + "\n\(b)"
            }
        } else {
            place.text = place.text! + "\nNot birthday found"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attrString = NSMutableAttributedString(string: place.text!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        place.attributedText = attrString
        place.textColor = self.globalColor.colorBlack
        place.numberOfLines = 2
        place.font = UIFont(name: "AvenirLTStd-Medium", size: self.globalSize.widthScreen*0.035)
        place.frame = CGRect(x: self.globalSize.widthScreen*0.33, y: self.globalSize.heightScreen*0.22, width: self.globalSize.widthScreen*0.76, height: self.globalSize.widthScreen*0.1)
        self.view.addSubview(place)
        
        
        let height = UILabel()
        var stringHeight = "H. 150 cm"
        if saveData.value(forKey: "height") != nil {
            stringHeight = "H. \(saveData.string(forKey: "height")!) cm"
        }
        let myMutableStringHeight = NSMutableAttributedString(string: stringHeight, attributes: [NSFontAttributeName:UIFont(name: "AvenirLTStd-Medium", size: self.globalSize.widthScreen*0.04)!])
        myMutableStringHeight.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirLTStd-Black", size: self.globalSize.widthScreen*0.04)!, range: NSRange(location: 0, length: 2))
        height.attributedText = myMutableStringHeight
        height.textColor = self.globalColor.colorBlack
        height.frame = CGRect(x: self.globalSize.widthScreen*0.33, y: self.globalSize.heightScreen*0.28, width: self.globalSize.widthScreen*0.3, height: self.globalSize.widthScreen*0.1)
        self.view.addSubview(height)
        
        let weight = UILabel()
        var stringWeight = "W. 50 kg"
        if saveData.value(forKey: "weight") != nil {
            stringWeight = "W. \(saveData.string(forKey: "weight")!) kg"
        }
        let myMutableStringWeight = NSMutableAttributedString(string: stringWeight, attributes: [NSFontAttributeName:UIFont(name: "AvenirLTStd-Medium", size: self.globalSize.widthScreen*0.04)!])
        myMutableStringWeight.addAttribute(NSFontAttributeName, value: UIFont(name: "AvenirLTStd-Black", size: self.globalSize.widthScreen*0.04)!, range: NSRange(location: 0, length: 2))
        weight.attributedText = myMutableStringWeight
        weight.textColor = self.globalColor.colorBlack
        weight.frame = CGRect(x: self.globalSize.widthScreen*0.59, y: self.globalSize.heightScreen*0.28, width: self.globalSize.widthScreen*0.3, height: self.globalSize.widthScreen*0.1)
        self.view.addSubview(weight)
        
        
        var titleView: UIImageView!
        let img = UIImage(named: "arrow")
        titleView = UIImageView(image: img)
        titleView.alpha = 0.8
        titleView.frame = CGRect(x: self.globalSize.widthScreen*0.92, y: self.globalSize.heightScreen*0.26, width: self.globalSize.widthScreen*0.06, height: self.globalSize.widthScreen*0.06)
        self.view.addSubview(titleView)
        
    }
    
    func openEditProfile() {
        let newViewController = editProfileController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
}
