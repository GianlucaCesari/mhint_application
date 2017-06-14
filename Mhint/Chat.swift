
//
//  ViewController.swift
//  Mhint Chat
//
//  Created by Andrea Merli on 10/03/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import HealthKit //SALUTE
import Contacts //CONTACTS
import AVFoundation //SOUND

//SOCIAL IMPORT
import FBSDKLoginKit //FACEBOOK SDK
import Firebase //FIREBASE
import FirebaseAuth //FIREBASE
import GoogleSignIn //GOOGLE SDK
import TwitterKit //TWITTER SDK
import Fabric //TWITTER - FABRIC

import SDWebImage//LOAD IMAGE ASYNC
import SwiftyGif //LOAD GIF

//VARIABLE
var messages: [String]?
var archiveMessages: [String]?
var messagesType: [Bool]?
var archiveMessagesType: [Bool]?

let saveData = UserDefaults.standard //DATA SAVE IN CACHE

var timer = Timer()
var timerHeight : Timer!

//let globalUser = GlobalUser //GLOBAL VAR FOR USER

let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FBSDKLoginButtonDelegate, GIDSignInUIDelegate{
    
    let collectionVHeight = UICollectionView(frame: CGRect(x: 0, y: GlobalSize().heightScreen*0.8, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1), collectionViewLayout: layout)
    
    let collectionVWeight = UICollectionView(frame: CGRect(x: 0, y: GlobalSize().heightScreen*0.8, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1), collectionViewLayout: layout)
    
    var player: AVAudioPlayer?
    
    let viewOverlay = UIButton()
    
    let cellId = "cellId"
    let cellIdHeight = "cellIdHeight"
    let cellIdWeight = "cellIdWeight"
    
    var frameResponse = UIView()
    var imgWave: UIImageView!
    let imgUrlLogo = UIImage(named: "wave")
    
    var buttonChat = [UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton(), UIButton()]
    var loginFacebookBool:Bool = false
    var loginTwitterBool:Bool = false
    static var loginGoogleBool:Bool = false
    var loginHealthBool:Bool = false
    
    var sectionFood:Bool = false
    var sectionNeed:Bool = false
    static var deniedAccessNeed:Bool = false
    
    static var boolResponeWithoutButton:Bool = false
    
    var imageListeningGif = UIImageView()
    
    var nameFacebook = ""
    var facebookToken:String = ""
    
    let healthManager:HKHealthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if saveData.bool(forKey: "welcomeFinish0") {
            sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
            GlobalFunc().navBarMenu(nav: navigationItem, s: self) //MOSTRA IL MENU, DEVE ESSERE FATTO ALLA FINE DELLA CHAT
        } else {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            sideMenuViewController?.panGestureLeftEnabled = false //DA DISATTIVARE ALLA PRIMA APERTURA DELL'APP
        }
        
        UIApplication.shared.statusBarView?.backgroundColor = .white//BACKGROUND STATUS BAR WHITE
        
        GlobalFunc().checkInternet(s: self)//INTERNET
        
        //ARCHIVIO MESSAGGI
        archiveMessages = ["Nice to meet you.", "Tell me somethig about you.", "Facebook;Twitter;Google", "Awww, now we are friend!", "Wow, I'm so excited.", "Let's go! For now, which section do you want to use?", "Help & Needs;Food & Supply"]
        archiveMessagesType = [false, true, false, true, false, true, false, true, false, true, false]
        messages = ["Good Evening,\nI'm Mhint your personal assistant."]
        messagesType = [true]
        
        if saveData.integer(forKey: "positionChat") != 0 {
            archiveMessages = saveData.array(forKey: "archiveMessages") as! [String]?
            archiveMessagesType = saveData.array(forKey: "archiveMessagesType") as! [Bool]?
            
            messages = saveData.array(forKey: "chatMessage") as! [String]?
            messagesType = saveData.array(forKey: "typeMessage") as! [Bool]?
            
            loginFacebookBool = saveData.bool(forKey: "loginFacebook")
            ChatController.loginGoogleBool = saveData.bool(forKey: "loginGoogle")
            loginTwitterBool = saveData.bool(forKey: "loginTwitter")
        }
        saveData.set(false, forKey: "loginHealth")
        
        //TITOLO BARRA DI NAVIGAZIONE SUPERIORE
        GlobalFunc().navBar(nav: navigationItem, s: self, show: false)
        
        
        //BACKGROUND ONDE BOTTONE
        frameResponse.frame = CGRect(x: 0, y: view.frame.height*0.7, width: view.frame.width, height: view.frame.height*0.3)
        frameResponse.backgroundColor = GlobalColor().colorWhite
        self.view.addSubview(frameResponse)
        imgWave = UIImageView (image: imgUrlLogo)
        let marginTopImage = (view.frame.height*0.85 - (view.frame.width/4))
        imgWave.frame = CGRect(x: -self.view.frame.width*0.5, y: self.view.frame.height*0.6, width: self.view.frame.width*2, height: self.view.frame.width)
        self.view.addSubview(imgWave)
        
        //FIRST BUTTON
        if (archiveMessages?.count)! > 0 {
            generateButton(buttonMessage: (archiveMessages?[0])!)
        } else {
            sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
            GlobalFunc().navBarMenu(nav: navigationItem, s: self) //MOSTRA IL MENU, DEVE ESSERE FATTO ALLA FINE DELLA CHAT
        }
        
        collectionView?.delegate = self
        collectionVHeight.delegate = self
        collectionVWeight.delegate = self
        
        collectionView?.dataSource = self
        collectionVHeight.dataSource = self
        collectionVWeight.dataSource = self
        
        let layoutHeight:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layoutHeight.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layoutHeight.scrollDirection = .horizontal
        layoutHeight.itemSize = CGSize(width: GlobalSize().heightScreen*0.1, height: GlobalSize().heightScreen*0.1)
        self.collectionVHeight.collectionViewLayout = layoutHeight
        self.collectionVWeight.collectionViewLayout = layoutHeight
        self.collectionVHeight.contentSize = CGSize(width: 10, height: 10)
        self.collectionVWeight.contentSize = CGSize(width: 10, height: 10)
        
        collectionView?.register(ChatControllerCell.self, forCellWithReuseIdentifier: cellId)
        collectionVHeight.register(ChatControllerCellHeight.self, forCellWithReuseIdentifier: cellIdHeight)
        collectionVWeight.register(ChatControllerCellHeight.self, forCellWithReuseIdentifier: cellIdWeight)
        
        //CHAT
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.7)
        collectionView?.collectionViewLayout = layout
        let itemA = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: itemA, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
        self.view.addSubview(collectionView!)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //PRINT BUTTON START
    func generateButton(buttonMessage: String) {
        
        if let viewWithTag = self.view.viewWithTag(10){
            viewWithTag.removeFromSuperview()
        }
        
        if let viewWithTag = self.view.viewWithTag(20){
            viewWithTag.removeFromSuperview()
        }
        
        for x in 0..<buttonChat.count {
            buttonChat[x].removeFromSuperview()
        }
        
        if buttonMessage.range(of:";") != nil {
            let buttonMessageArr = buttonMessage.characters.split{$0 == ";"}.map(String.init)
            for x in 0..<buttonMessageArr.count {
                makeDynamicButton(textButton: buttonMessageArr[x], length: buttonMessageArr.count, id: x)
            }
        }
        else{
            makeDynamicButton(textButton: buttonMessage, length: 1, id: 0)
        }
    }
    
    func makeDynamicButton(textButton: String, length: Int, id: Int) {
        
        buttonChat[id] = UIButton()
        
        let widthTextAmproximate = NSString(string: textButton).boundingRect(with: CGSize(width: 1000, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
        let screenW = view.frame.width
        let widthText = (widthTextAmproximate.width+(screenW*0.09))
    
        let space = screenW/CGFloat(length)
        var marginLeft = (space/2)-(widthText/2) + (space*CGFloat(id))
        
        if length == 1 {
            marginLeft = screenW/2 - (widthText/2)
        }
        
        let screenH = view.frame.height
        
        buttonChat[id].frame = CGRect(x: marginLeft, y: screenH*0.82, width: widthText, height: screenH*0.08)
        
        buttonChat[id].backgroundColor = .white
        buttonChat[id].layer.cornerRadius = view.frame.height*0.04
        buttonChat[id].layer.masksToBounds = false
        buttonChat[id].setTitle(textButton, for: .normal)
        buttonChat[id].setTitleColor(.black, for: .normal)
        buttonChat[id].titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 14)
        
        buttonChat[id].layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        buttonChat[id].layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        buttonChat[id].layer.shadowOpacity = 1.0
        buttonChat[id].layer.shadowRadius = 6.0
        
        buttonChat[id].tag = 20
        buttonChat[id].removeTarget(self, action: nil, for: .touchUpInside)
        
        if (textButton == "Facebook"){
            buttonChat[id].backgroundColor = UIColor.init(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
            buttonChat[id].setTitleColor(.white, for: .normal)
            buttonChat[id].addTarget(self, action: #selector(facebookLogin), for: .touchUpInside)
        }
        else if textButton == "Google" {
            buttonChat[id].backgroundColor = UIColor.init(red: 221/255, green: 75/255, blue: 57/255, alpha: 1)
            buttonChat[id].setTitleColor(.white, for: .normal)
            buttonChat[id].addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
            GIDSignIn.sharedInstance().uiDelegate = self
        }
        else if textButton == "Twitter" {
            buttonChat[id].backgroundColor = UIColor.init(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
            buttonChat[id].setTitleColor(.white, for: .normal)
            buttonChat[id].addTarget(self, action: #selector(twitterLogin), for: .touchUpInside)
        }
        else if textButton == "Let's start" {
            buttonChat[id].addTarget(self, action: #selector(afterLogin), for: .touchUpInside)
        }
        else if textButton == "Food & Supply" {
            buttonChat[id].addTarget(self, action: #selector(foodSupply), for: .touchUpInside)
        }
        else if textButton == "Help & Needs" {
            buttonChat[id].addTarget(self, action: #selector(needSupply), for: .touchUpInside)
        }
        else if textButton == "I won't give it to you" {
            ChatController.deniedAccessNeed = true
            buttonChat[id].addTarget(self, action: #selector(needSupply), for: .touchUpInside)
        }
        else if textButton == "Apple Health" {
            buttonChat[id].backgroundColor = UIColor.init(red: 241/255, green: 79/255, blue: 98/255, alpha: 1)
            buttonChat[id].setTitleColor(.white, for: .normal)
            buttonChat[id].addTarget(self, action: #selector(accessToHealth), for: .touchUpInside)
        }
        else if textButton == "I'll give you" {
            buttonChat[id].addTarget(self, action: #selector(requestHealth), for: .touchUpInside)
        }
        else if textButton == "Sport" || textButton == "Active" || textButton == "Lazy" {
            buttonChat[id].addTarget(self, action: #selector(finishFood), for: .touchUpInside)
        }
        else if textButton == "Type my number" {
            buttonChat[id].addTarget(self, action: #selector(alertNumber), for: .touchUpInside)
        }
        else if textButton == "Yes" {
            buttonChat[id].addTarget(self, action: #selector(finishNeed), for: .touchUpInside)
        }
        else if textButton == "Start using Mhint" {
            buttonChat[id].addTarget(self, action: #selector(endChat), for: .touchUpInside)
        }
        else{
            buttonChat[id].addTarget(self, action: #selector(activateResponse), for: .touchUpInside)
        }
        self.view.addSubview(buttonChat[id])
    }
    
    //-----------------------------------------------------------------------------------------
    
    //FOOD SECTION
    func requestHealth() {
        ChatController.boolResponeWithoutButton = true
        archiveMessages?.remove(at: 0)
        archiveMessages?.insert("I'll give you", at: 0)
        archiveMessages?.insert("Let's start,\nHow tall are you (cm) ?", at: 1)
        self.heightResponse()
        self.activateResponse()
    }
    
    func heightResponse() {
        for locView in self.view.subviews {
            if locView.isKind(of: UIButton.self) {
                if locView.tag == 20 {
                    locView.removeFromSuperview()
                }
            }
        }
        self.collectionVHeight.backgroundColor = .clear
        self.collectionVHeight.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.8, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.2)
        self.view.addSubview(self.collectionVHeight)
    }
    
    func weightResponse() {
        for locView in self.view.subviews {
            if locView.isKind(of: UIButton.self) {
                if locView.tag == 20 {
                    locView.removeFromSuperview()
                }
            }
        }
        self.collectionVHeight.removeFromSuperview()
        self.collectionVWeight.backgroundColor = .clear
        self.collectionVWeight.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.8, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.17)
        self.view.addSubview(self.collectionVWeight)
    }
    
    func accessToHealth() {
        for x in 0..<self.buttonChat.count {
            self.buttonChat[x].removeFromSuperview()
        }
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: -self.view.frame.width*0.5, y: self.view.frame.height*0.6, width: self.view.frame.width*2, height: self.view.frame.width), nameGif: "load-chat")
        self.view.addSubview(collectionView!)
        var readTypes = Set<HKObjectType>()
        readTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!)
        readTypes.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!)
        readTypes.insert(HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!)
        
        guard timerHeight == nil else { return }
        timerHeight = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.heightResponseTimer), userInfo: nil, repeats: true)
        
        healthManager.requestAuthorization(toShare: nil, read: readTypes) { (success, error) -> Void in
            
            ChatController.boolResponeWithoutButton = true
            archiveMessages?.remove(at: 0)
            archiveMessages?.insert("Get my info from Apple Health", at: 0)
            archiveMessages?.insert("Loading...", at: 1)
            self.activateResponse()
            
            if error == nil {
                GlobalFunc().getBodyData(hM: self.healthManager)
                self.heightResponseTimer()
            } else {
                self.requestHealth()
                saveData.set(true, forKey: "loginHealth")
            }
            GlobalFunc().removeLoadingChat(s: self)
        }
    }
    
    func heightResponseTimer() {
        if GlobalUser.height > -1 && GlobalUser.weight > -1 {
            timerHeight?.invalidate()
            timerHeight = nil
            archiveMessages?.insert("Get my info from Apple Health", at: 0)
            if saveData.integer(forKey: "height") > 178 {
                archiveMessages?.insert("Wow you are so tall, \(saveData.integer(forKey: "height")) cm.\nWhat's your lifestyle ?", at: 1)
            }
            else if saveData.float(forKey: "weight") > 120 || saveData.float(forKey: "weight") < 60 && saveData.float(forKey: "weight") > 30 {
                archiveMessages?.insert("Come on, start to do better than \(saveData.float(forKey: "weight"))kg.\nWhat's your lifestyle ?", at: 1)
            } else {
                archiveMessages?.insert("Ok now what's your lifestyle ?", at: 1)
            }
            archiveMessages?.insert("Sport;Active;Lazy", at: 2)
            self.loginHealthBool = true
            self.activateResponse()
        }
    }
    
    func foodSupply() {
        GlobalFunc().saveUserProfile(value: true, description: "food")
        archiveMessages?.remove(at: 0)
        archiveMessages?.insert("Activate Food & Supply", at: 0)
        archiveMessages?.insert("To suggest you the perfect diet I need some body infomation.", at: 1)
        archiveMessages?.insert("Apple Health;I'll give you", at: 2)
        self.activateResponse()
    }
    
    func finishFood(sender: UIButton) {
        sectionFood = true
        saveData.set(true, forKey: "food")

        if sender.titleLabel?.text == "Sport" {
            GlobalUser.lifestyle = 1
        } else if sender.titleLabel?.text == "Active" {
            GlobalUser.lifestyle = 2
        } else if sender.titleLabel?.text == "Lazy" {
            GlobalUser.lifestyle = 3
        }
        GlobalFunc().saveUserProfile(value: GlobalUser.lifestyle, description: "lifestyle")
        archiveMessages?.insert((sender.titleLabel?.text)!, at: 0)
        if !saveData.bool(forKey: "need") {
            archiveMessages?.insert("Wow, now what do you want to do ?", at: 1)
            archiveMessages?.insert("Start using Mhint;Help & Needs", at: 2)
            self.activateResponse()
        } else {
            self.endChat()
        }
    }
    //FOOD SECTION
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    //NEED SECTION
    func needSupply() {
        for x in 0..<self.buttonChat.count {
            self.buttonChat[x].removeFromSuperview()
        }
        self.view.addSubview(collectionView!)
        
        if ChatController.deniedAccessNeed {
            archiveMessages?.insert("No access to my number", at: 0)
            archiveMessages?.insert("Ops, we need your number to activate the Help & Needs section.", at: 1)
            if saveData.bool(forKey: "food") {
                archiveMessages?.insert("Start using Mhint", at: 2)
            } else {
                archiveMessages?.insert("Food & Supply;Help & Needs", at: 2)
            }
            self.activateResponse()
        } else {
            ChatController.boolResponeWithoutButton = false
            archiveMessages?.insert("Activate.", at: 0)
            archiveMessages?.insert("We need your number to activate the Help & Needs section.", at: 1)
            archiveMessages?.insert("Type my number;I won't give it to you", at: 2)
            self.activateResponse()
        }
    }
    
    func alertNumber() {
        let alert = UIAlertController(title: "Your telephone number", message: "To activate this section we need your telephone number, type it here.", preferredStyle: .alert)
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
                if self.isStringAnInt(string: number) {
                    GlobalUser.phoneNumber = number
                    self.takeNumber(n: number)
                } else {
                    self.alertNumber()
                }
            } else {
                self.alertNumber()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func takeNumber(n: String) {
        self.sectionNeed = true
        saveData.set(true, forKey: "need")
        archiveMessages?.insert("My number is \(n)", at: 0)
        if saveData.bool(forKey: "food") == false {
            archiveMessages?.insert("Do you want to stop or do you want to activate the Food & Supply section?", at: 1)
            archiveMessages?.insert("Start using Mhint;Food & Supply", at: 2)
        } else {
            archiveMessages?.remove(at: 0)
            self.endChat()
        }
        self.activateResponse()
    }
    
    func finishNeed() {
        sectionNeed = true
        saveData.set(true, forKey: "need")
        if saveData.bool(forKey: "food") == false {
            archiveMessages?.insert("Yes", at: 0)
            archiveMessages?.insert("Do you want to stop or do you want to activate the Food & Supply section?", at: 1)
            archiveMessages?.insert("Start using Mhint;Food & Supply", at: 2)
        } else {
            archiveMessages?.remove(at: 0)
            archiveMessages?.insert("Yes", at: 0)
            self.endChat()
        }
        self.activateResponse()
    }
    //SECTION NEED
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    //END CHAT
    func endChat() {
        
        archiveMessages?.insert("Start using Mhint", at: 0)
        archiveMessages?.insert("You can now start exploring the app.", at: 1)
        
        sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
        GlobalFunc().navBarMenu(nav: navigationItem, s: self) //MOSTRA IL MENU, DEVE ESSERE FATTO ALLA FINE DELLA CHAT
        saveData.set(true, forKey: "welcomeFinish0")
        
        //CARICA UTENTE SUL SERVER
        if GlobalUser.fullNameFacebook != nil {
            GlobalUser.fullName = GlobalUser.fullNameFacebook!
        } else if GlobalUser.fullNameTwitter != nil {
            GlobalUser.fullName = GlobalUser.fullNameTwitter!
        } else if GlobalUser.fullNameGoogle != nil {
            GlobalUser.fullName = GlobalUser.fullNameGoogle!
        } else {
            GlobalUser.fullName = GlobalUser.nickname
        }
        
        //BIRTHDAY
        var birth = String()
        if let b = saveData.value(forKey: "birthday") {
            birth = b as! String
        }
        if GlobalUser.birthday != "" {
            birth = GlobalUser.birthday
        }
        
        if GlobalUser.imageProfileFacebook != nil {
            GlobalUser.imageProfile = GlobalUser.imageProfileFacebook
        } else if GlobalUser.fullNameTwitter != nil {
            GlobalUser.imageProfile = GlobalUser.imageProfileTwitter
        } else if GlobalUser.fullNameGoogle != nil {
            GlobalUser.imageProfile = GlobalUser.imageProfileGoogle
        }
        
        if GlobalUser.emailFacebook != nil {
            GlobalUser.email = GlobalUser.emailFacebook!
        } else if GlobalUser.emailTwitter != nil {
            GlobalUser.email = GlobalUser.emailTwitter!
        } else if GlobalUser.emailGoogle != nil {
            GlobalUser.email = GlobalUser.emailGoogle!
        } else {
            GlobalUser.email = GlobalUser.nickname
        }
        
        var n = ""
        if GlobalUser.phoneNumber != nil {
            n = GlobalUser.phoneNumber!
        }
        
        GlobalFunc().saveUserProfile(value: GlobalUser.email, description: "email")
        
        GlobalUser().createUser(name: GlobalUser.fullName!, imageProfile: GlobalUser.imageProfile!, birthday: birth, address: GlobalUser.address, height: GlobalUser.height, weight: GlobalUser.weight, sex: GlobalUser.sex, lifestyle: GlobalUser.lifestyle, sectionEnabled: [saveData.bool(forKey: "food"),saveData.bool(forKey: "need")], logins: [loginFacebookBool,loginTwitterBool,ChatController.loginGoogleBool,loginHealthBool], mail: GlobalUser.email, number: n)
        
        ChatController.boolResponeWithoutButton = true
        self.activateResponse()
        sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
        GlobalFunc().navBarMenu(nav: navigationItem, s: self) //MOSTRA IL MENU, DEVE ESSERE FATTO ALLA FINE DELLA CHAT
        
        //ANIMATION
        viewOverlay.backgroundColor = .black
        viewOverlay.alpha = 0
        viewOverlay.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen)
        viewOverlay.addTarget(self, action: #selector(self.presentLeftMenuViewController(_:)), for: .touchUpInside)
        self.navigationController?.view.addSubview(viewOverlay)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.viewOverlay.alpha = 0.9
        }, completion: nil)
        if GlobalUser.firstName != "" {
            self.animationImage(i: GlobalUser.imageProfile!, n: GlobalUser.firstName, color: UIColor.darkGray.cgColor)
        } else {
            self.animationImage(i: GlobalUser.imageProfile!, n: GlobalUser.fullName!, color: UIColor.darkGray.cgColor)
        }
    }
    //END CHAT
    
    
    
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    //START FACEBOOK
    func facebookLogin() {
        for x in 0..<self.buttonChat.count {
            self.buttonChat[x].removeFromSuperview()
        }
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: -self.view.frame.width*0.5, y: self.view.frame.height*0.6, width: self.view.frame.width*2, height: self.view.frame.width), nameGif: "load-chat")
        self.view.addSubview(collectionView!)
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_birthday", "user_hometown"], from: self, handler: { //PERMESSI DA CHIEDERE
            (result, err) in
            if result?.token != nil {
                self.facebookToken = (result?.token.tokenString)!
                self.showNameFromFacebook()
            } else {
                self.promptLogin()
                GlobalFunc().removeLoadingChat(s: self)
                GlobalFunc().alert(stringAlertTitle: "Error Facebook login", stringAlertDescription: "Ops, something went wrong while authenticating with facebook.", s: self)
            }
        })
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        showNameFromFacebook()
    }
    func showNameFromFacebook() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture, birthday, hometown, first_name, last_name"]).start{ //COSA PRENDERE
            (connection, result, err) in
            
            if err != nil {
                self.promptLogin()
                print("Error Facebook: ", err ?? "")
                GlobalFunc().alert(stringAlertTitle: "Error Login Facebook", stringAlertDescription: err as! String, s: self)
                return
            }
            
            //PRENDERE DATI DA FACEBOOK
            let result = result as? NSDictionary
            let userID = (result?["id"]!)!
            
            //NAME
            if let user_name = result?["name"] as? String {
                GlobalUser.fullNameFacebook = user_name
                saveData.set(user_name, forKey: "nameProfile")
                self.nameFacebook = "What a wonderful name \(user_name)"
            }
            
            //firstName
            if let firstName = result?["first_name"] as? String {
                GlobalUser.firstName = firstName
                saveData.set(firstName, forKey: "firstName")
                self.nameFacebook = "What a wonderful name \(firstName)"
            }
            
            //lastName
            if let lastName = result?["last_name"] as? String {
                GlobalUser.lastName = lastName
                saveData.set(lastName, forKey: "lastName")
            }
            
            //HOMETOWN
            if let user_home = result?["hometown"] as? NSDictionary {
                if let hometown = user_home["name"]! as? String {
                    GlobalUser.address = hometown
                    GlobalFunc().saveUserProfile(value: hometown, description: "address")
                    self.nameFacebook = "\(hometown)\nIt's a wonderful place."
                }
            }
            
            //BIRTHDAY
            GlobalFunc().saveUserProfile(value: String(describing: result?["birthday"]), description: "birthday")
            if let user_birthday = result?["birthday"] as? DateComponents {
                var dateBirthday = ""
                dateBirthday = String(describing: user_birthday.day!) + "/" + String(describing: user_birthday.month!) + "/" + String(describing: user_birthday.year!)
                GlobalFunc().saveUserProfile(value: dateBirthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: ""), description: "birthday")
                GlobalUser.birthday = dateBirthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
                if user_birthday.year! > 1985 {
                    self.nameFacebook = "You are so younger."
                }
            }
            
            //EMAIL
            if let email = result?["email"] as? String {
                GlobalUser.emailFacebook = email
                GlobalFunc().saveUserProfile(value: email, description: "emailFacebook")
            }
            
            //IMAGE
            if let picture = result?["picture"] as? NSDictionary {
                if let picture_data = picture["data"]! as? NSDictionary {
                    if picture_data["url"]! is String {
                        GlobalUser.imageProfileFacebook = "http://graph.facebook.com/\(userID)/picture?type=large"
                        GlobalFunc().saveUserProfile(value: "http://graph.facebook.com/\(userID)/picture?type=large", description: "imageProfile")
                    }
                }
            }
            //PRENDERE DATI DA FACEBOOK
            //CARICA SU FIREBASE
            let credentials = FacebookAuthProvider.credential(withAccessToken: self.facebookToken)
            Auth.auth().signIn(with: credentials, completion: {
                (user, error) in
                if error != nil {
                    print("Error Facebook on Firebase")
                    return
                }
                
                if let email = user?.email {
                    if GlobalUser.emailFacebook == nil {
                        GlobalUser.emailFacebook = email
                        GlobalFunc().saveUserProfile(value: email, description: "emailFacebook")
                    }
                }
                
                print("Successfully Facebook on Firebase")
            })
            self.facebookMessage()
        }
    }
    
    func facebookMessage() {
        self.loginFacebookBool = true
        var message = "Let's start"
        if (!self.loginTwitterBool) {
            message += ";Twitter"
        }
        if (!ChatController.loginGoogleBool) {
            message += ";Google"
        }
        archiveMessages?.remove(at: 0)
        archiveMessages?.insert("Facebook", at: 0)
        archiveMessages?.insert(self.nameFacebook, at: 1)
        archiveMessages?.insert(message, at: 2)
        self.activateResponse()
        GlobalFunc().removeLoadingChat(s: self)
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout from Facebook")
    }
    //END FACEBOOK
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    //START GOOGLE
    func googleLogin() {
        for x in 0..<self.buttonChat.count {
            self.buttonChat[x].removeFromSuperview()
        }
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: -self.view.frame.width*0.5, y: self.view.frame.height*0.6, width: self.view.frame.width*2, height: self.view.frame.width), nameGif: "load-chat")
        self.view.addSubview(collectionView!)
        GIDSignIn.sharedInstance().signIn()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.googleResponse), userInfo: nil, repeats: true)
    }
    
    func googleResponse() {
        if ChatController.loginGoogleBool == true {
            
            timer.invalidate()
            
            var message = "Let's start"
            if (!loginTwitterBool) {
                message += ";Twitter"
            }
            if (!loginFacebookBool) {
                message += ";Facebook"
            }
        
            archiveMessages?.remove(at: 0)
            archiveMessages?.insert("Google", at: 0)
            archiveMessages?.insert("Now you are logged-in with Google", at: 1)
            archiveMessages?.insert(message, at: 2)
            self.activateResponse()
            GlobalFunc().removeLoadingChat(s: self)
        }
    }
    //END GOOGLE
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    //START TWITTER
    func twitterLogin() {
        for x in 0..<self.buttonChat.count {
            self.buttonChat[x].removeFromSuperview()
        }
        GlobalFunc().loadingChat(s: self, frame: CGRect(x: -self.view.frame.width*0.5, y: self.view.frame.height*0.6, width: self.view.frame.width*2, height: self.view.frame.width), nameGif: "load-chat")
        self.view.addSubview(collectionView!)
        Twitter.sharedInstance().logIn { (session, error) in
            if session != nil {
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true",
                                                parameters: ["include_email": "true", "skip_status": "true"],
                                                error: nil)
                
                GlobalUser.nickname = (session?.userName)!
                GlobalFunc().saveUserProfile(value: (session?.userName)!, description: "nickname")
                
                guard let token = session?.authToken else { return }
                guard let secret = session?.authTokenSecret else { return }
                let credentials = TwitterAuthProvider.credential(withToken: token, secret: secret)
                
                client.sendTwitterRequest(request) { response, data, connectionError in
                    if (connectionError == nil) {
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                            
                            let firstName = json["name"] as! String
                            let hometown = json["location"]! as! String
                            
                            if let email = json["email"] {
                                GlobalUser.emailTwitter = email as? String
                                GlobalFunc().saveUserProfile(value: email as! String, description: "emailTwitter")
                            }
                            
                            GlobalUser.address = hometown
                            GlobalFunc().saveUserProfile(value: hometown, description: "address")
                            
                            saveData.set(firstName, forKey: "nameProfile")
                            GlobalFunc().saveUserProfile(value: firstName, description: "fullNameTwitter")
                            GlobalUser.fullNameTwitter = firstName
                            
                        } catch {
                            GlobalFunc().alert(stringAlertTitle: "Error Login Twitter", stringAlertDescription: connectionError as! String, s: self)
                            self.promptLogin()
                        }
                        
                    }
                    else {
                        self.promptLogin()
                        print("Error: \(String(describing: connectionError))")
                    }
                }
                
                Auth.auth().signIn(with: credentials, completion: {
                    (user, error) in
                    
                    if let image = user?.photoURL {
                        GlobalFunc().saveUserProfile(value: String(describing: image), description: "imageProfileTwitter")
                        if saveData.string(forKey: "imageProfile") == nil {
                            GlobalUser.imageProfileTwitter = String(describing: image)
                            saveData.set(String(describing: image), forKey: "imageProfile")
                        }
                    }
                    
                    if error != nil {
                        print("Error Twitter on Firebase")
                        return
                    }
                    print("Successfully Twitter on Firebase")
                    
                    let mes = "Hi, " + (session?.userName)! + "."
                    self.twitterMessage(messageResponse: mes)
                })
                
                
            } else {
                self.promptLogin()
                GlobalFunc().removeLoadingChat(s: self)
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
    }
    
    func twitterMessage(messageResponse: String) {
        loginTwitterBool = true
        
        var message = "Let's start"
        if (!ChatController.loginGoogleBool) {
            message += ";Google"
        }
        if (!loginFacebookBool) {
            message += ";Facebook"
        }
        
        archiveMessages?.remove(at: 0)
        archiveMessages?.insert("Twitter", at: 0)
        archiveMessages?.insert(messageResponse, at: 1)
        archiveMessages?.insert(message, at: 2)
        self.activateResponse()
        GlobalFunc().removeLoadingChat(s: self)
    }
    //END TWITTER
    
    //LOGIN END
    func afterLogin() {
        archiveMessages?[0] = "Let's start"
        self.activateResponse()
    }
    
    func promptLogin() {
        var message = String()
        
        if self.loginFacebookBool || self.loginTwitterBool || ChatController.loginGoogleBool {
            message += "Let's start"
        }
        
        if !self.loginFacebookBool {
            message += ";Facebook"
        }
        if !ChatController.loginGoogleBool {
            message += ";Google"
        }
        if !self.loginTwitterBool {
            message += ";Twitter"
        }
        
        self.generateButton(buttonMessage: message)
    }
    
    
    
    
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    //----------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    
    //MANAGE ARRAY MESSAGE COLLECTION VIEW
    func activateResponse() {
        if ChatController.boolResponeWithoutButton == true {
            ChatController.boolResponeWithoutButton = false
            for locView in self.view.subviews {
                if locView.isKind(of: UIButton.self) {
                    if locView.tag == 20 {
                        locView.removeFromSuperview()
                    }
                }
            }
            
            messages?.append((archiveMessages?[0])!)
            messagesType?.append((archiveMessagesType?[0])!)
            messages?.append((archiveMessages?[1])!)
            messagesType?.append((archiveMessagesType?[1])!)
            archiveMessages?.remove(at: 1)
            archiveMessages?.remove(at: 0)
            
            collectionView?.reloadData()
            
            saveData.set(messages?.count, forKey: "positionChat")
            saveData.set(archiveMessages, forKey: "archiveMessages")
            saveData.set(archiveMessagesType, forKey: "archiveMessagesType")
            saveData.set(messages, forKey: "chatMessage")
            saveData.set(messagesType, forKey: "typeMessage")
            
            saveData.set(loginFacebookBool, forKey: "loginFacebook")
            saveData.set(ChatController.loginGoogleBool, forKey: "loginGoogle")
            saveData.set(loginTwitterBool, forKey: "loginTwitter")
            
            let itemA = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            let lastItemIndex = NSIndexPath(item: itemA, section: 0)
            self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        } else if ((archiveMessages?.count)! > 2){
            ChatController.boolResponeWithoutButton = false
            for locView in self.view.subviews {
                if locView.isKind(of: UIButton.self) {
                    if locView.tag == 20 {
                        locView.removeFromSuperview()
                    }
                }
            }
            
            messages?.append((archiveMessages?[0])!)
            messagesType?.append((archiveMessagesType?[0])!)
            messages?.append((archiveMessages?[1])!)
            messagesType?.append((archiveMessagesType?[1])!)
            
            generateButton(buttonMessage: (archiveMessages?[2])!)
            
            archiveMessages?.remove(at: 1)
            archiveMessages?.remove(at: 0)
            
            collectionView?.reloadData()
            
            saveData.set(messages?.count, forKey: "positionChat")
            saveData.set(archiveMessages, forKey: "archiveMessages")
            saveData.set(archiveMessagesType, forKey: "archiveMessagesType")
            saveData.set(messages, forKey: "chatMessage")
            saveData.set(messagesType, forKey: "typeMessage")
            
            saveData.set(loginFacebookBool, forKey: "loginFacebook")
            saveData.set(ChatController.loginGoogleBool, forKey: "loginGoogle")
            saveData.set(loginTwitterBool, forKey: "loginTwitter")
            
            let itemA = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            let lastItemIndex = NSIndexPath(item: itemA, section: 0)
            self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
            GlobalFunc().removeLoadingChat(s: self)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if let count = messages?.count {
                return count
            }
            return 0
        } else if collectionView == self.collectionVHeight {
            return GlobalSize().maxHeight-GlobalSize().minHeight
        } else {
            return GlobalSize().maxWeight-GlobalSize().minWeight
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatControllerCell
        
            var title:String = ""
            let titleFont:CGFloat = 10
            var colorUser:UIColor = UIColor.init(red: 80/255, green: 227/255, blue: 226/255, alpha: 1)
        
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            cell.messageTextView.text = messages?[indexPath.row]
        
            cell.alpha = 0.1
            cell.messageTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 20 )
            if (((messages?.count)!-1 - indexPath.row) < 3) {
                cell.alpha = 0.3
                cell.messageTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 22)
            }
            if ((messages?.count)!-1 == indexPath.row){
                cell.alpha = 1
                cell.messageTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 24)
            }
        
            if let messagesTypeText = messagesType?[indexPath.row] {
                var marginLeft:CGFloat = 0
                if messagesTypeText {
                    //MHINT
                    title = "Mhint"
                    colorUser = UIColor.init(red: 80/255, green: 227/255, blue: 226/255, alpha: 1)
                    cell.messageTextView.textAlignment = .left
                    cell.titleTextView.textAlignment = .left
                    cell.roundColor.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
                    marginLeft = 25
                }
                else{
                    //YOU
                    title = "You"
                    colorUser = UIColor.init(red: 255/255, green: 119/255, blue: 119/255, alpha: 1)
                    cell.messageTextView.textAlignment = .right
                    cell.titleTextView.textAlignment = .right
                    cell.roundColor.frame = CGRect(x: view.frame.width-40, y: 0, width: 20, height: 20)
                }
            
                cell.roundColor.backgroundColor = colorUser
                cell.titleTextView.text = title
                let estimatedFrameTitle = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: titleFont)], context: nil)
                cell.titleTextView.frame = CGRect(x: marginLeft, y: -6, width: GlobalSize().widthScreen*0.9, height: estimatedFrameTitle.height + 20)
            
                if let messageText = messages?[indexPath.row] {
                    let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)], context: nil)
                    cell.messageTextView.frame = CGRect(x: 10, y: 10, width: GlobalSize().widthScreen*0.9, height: estimatedFrame.height + 25)
                }
            }
            return cell
        }
        else if collectionView == self.collectionVHeight {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdHeight, for: indexPath) as! ChatControllerCellHeight
            cell.backgroundV.frame = CGRect(x: GlobalSize().heightScreen*0.015, y: GlobalSize().heightScreen*0.015, width: GlobalSize().heightScreen*0.07, height: GlobalSize().heightScreen*0.07)
            let height:Int = Int(GlobalSize().minHeight+indexPath.row)
            cell.titleTextView.text = String(height)
            cell.titleTextView.textAlignment = .center
            cell.titleTextView.frame = CGRect(x: 0, y: 0, width: GlobalSize().heightScreen*0.1, height: GlobalSize().heightScreen*0.1)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdWeight, for: indexPath) as! ChatControllerCellHeight
            cell.backgroundV.frame = CGRect(x: GlobalSize().heightScreen*0.015, y: GlobalSize().heightScreen*0.015, width: GlobalSize().heightScreen*0.07, height: GlobalSize().heightScreen*0.07)
            let weight:Int = (GlobalSize().minWeight+indexPath.row)
            cell.titleTextView.text = String(weight)
            cell.titleTextView.textAlignment = .center
            cell.titleTextView.frame = CGRect(x: 0, y: 0, width: GlobalSize().heightScreen*0.1, height: GlobalSize().heightScreen*0.1)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            if let messageText = messages?[indexPath.row] {
                let size = CGSize(width: 300, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)], context: nil)
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 50)
            }
            return CGSize(width: view.frame.width, height: 100)
        } else {
            return CGSize(width: GlobalSize().heightScreen*0.08, height: GlobalSize().heightScreen*0.08)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionVHeight {
            let height:Int = Int(GlobalSize().minHeight+indexPath.row)
            
            GlobalUser.height = height
            GlobalFunc().saveUserProfile(value: height, description: "height")
            
            ChatController.boolResponeWithoutButton = true
            archiveMessages?.insert("I'm \(height) cm tall", at: 0)
            archiveMessages?.insert("Wow, and what's your weight (kg) ?", at: 1)
            self.collectionVHeight.removeFromSuperview()
            self.weightResponse()
            self.activateResponse()
            
        } else if collectionView == self.collectionVWeight {
            let weight:Int = GlobalSize().minWeight+indexPath.row
            
            GlobalUser.weight = weight
            GlobalFunc().saveUserProfile(value: weight, description: "weight")
            
            archiveMessages?.insert("I'm \(weight) kg weight", at: 0)
            archiveMessages?.insert("Good job.\nWhat's your lifestyle ?", at: 1)
            archiveMessages?.insert("Sport;Active;Lazy", at: 2)
            self.activateResponse()
            self.collectionVWeight.removeFromSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.collectionView {
            return UIEdgeInsetsMake(8, 0, 0, 0)
        } else {
            return UIEdgeInsetsMake(0, 10, 0, 0)
        }
    }
    //COLLECTION VIEW END
    
    
    //ANIMATE FINAL
    func animationImage(i: String, n: String, color: CGColor) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        guard let url = Bundle.main.url(forResource: "bamboo", withExtension: "mp3") else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
        } catch let error { }
        
        let imgProfile = UIImageView()
        imgProfile.frame = CGRect(x: GlobalSize().widthScreen*0.375, y: GlobalSize().heightScreen*1.5, width: GlobalSize().widthScreen*0.25, height: GlobalSize().widthScreen*0.25)
        imgProfile.sd_setImage(with: URL(string: i), placeholderImage: nil)
        imgProfile.layer.cornerRadius = GlobalSize().widthScreen*0.125
        imgProfile.layer.borderWidth = 5
        imgProfile.layer.borderColor = GlobalColor().greenSea.cgColor
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.shadowColor = UIColor.black.cgColor
        imgProfile.layer.shadowOpacity = 0.6
        imgProfile.layer.shadowRadius = GlobalSize().widthScreen*0.1
        self.navigationController?.view.addSubview(imgProfile)
        
        let label = UILabel()
        label.text = "\(n)".uppercased()
        label.alpha = 0
        label.addTextSpacing()
        label.textColor = .white
        label.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.03)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.51, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.navigationController?.view.addSubview(label)
        
        let labelName = UILabel()
        labelName.text = "Welcome to Mhint"
        labelName.alpha = 0
        labelName.textColor = .white
        labelName.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.09)
        labelName.textAlignment = .center
        labelName.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.navigationController?.view.addSubview(labelName)
        
        let labelClick = UILabel()
        labelClick.text = "Tap to start exploring the app."
        labelClick.alpha = 0
        labelClick.textColor = .white
        labelClick.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        labelClick.textAlignment = .center
        labelClick.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.9, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.navigationController?.view.addSubview(labelClick)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            imgProfile.frame.origin.y = GlobalSize().heightScreen*0.38
        }, completion: nil)
        let when = DispatchTime.now() + 0.6
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.player?.play()
        }
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
            label.alpha = 1
            labelName.alpha = 1
            labelClick.alpha = 1
        })
    }
}




//----------------------------------------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------------------------------------




//BACKGROUND STATUS BAR
extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

//LETTER-SPACING
extension UILabel {
    func addTextSpacing() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSKernAttributeName, value: 1.15, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

//ADD CHARACTER IN STRING
extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.characters.prefix(ind)) + string + String(self.characters.suffix(self.characters.count-ind))
    }
}

//DATE ADD ZERO
extension Int {
    func addZero(string:Int) -> String {
        if string < 10 {
            return "0\(string)"
        }
        return "\(string)"
    }
}

extension NSDate {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        return  formatter.string(from: self as Date)
    }
}
