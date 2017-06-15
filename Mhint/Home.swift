//
//  ChatBot.swift
//  Mhint
//
//  Created by Gianluca Cesari on 5/26/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit
import Alamofire
import Speech
import AudioToolbox

import SwiftyGif //GIF
import SwiftGifOrigin //GIF
import Gifu

import RevealingSplashView //SPLASH SCREEN

var firstOpenHome = false

class ChatBotController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate {
    
    var imgWave: UIImageView!
    let imgUrlLogo = UIImage(named: "wave")
    var keyboardOpen = false
    var button : UIButton!
    
    var responseNeedBtn:Bool = false
    var responseText:String = ""
    var responseImg:String = ""
    var responseTypeMeal:String = ""
    var responseIndexImage:Int = 0
    var dailyMealRecipesImage = [String]()
    var dailyMealRecipesTitle = [String]()
    
    let ball = UIView()
    
    var timerListening = Timer()
    
    var messagesChatBot: [String]?
    var messagesTypeChatBot: [Bool]?
    
    var inputText = UITextField()
    
    let cellId = "chatBot"
    
    var startTime:Double = 0
    var timeListening:Double = 0
    var stringListening = 0
    
    let lblTimer = UILabel()
    
    var imageView = GIFImageView()
    
    //    SPEECH RECOGNIZER
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-EN"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !firstOpenHome {
            
            let window = UIApplication.shared.keyWindow
            let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "iconChatSplashScreen")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: .white)
            self.view.addSubview(revealingSplashView)
            window?.addSubview(revealingSplashView)
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.barTintColor = GlobalColor().colorWhite
            self.navigationController?.navigationBar.backgroundColor = GlobalColor().colorWhite
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
            revealingSplashView.startAnimation(){
                firstOpenHome = true
                self.openHome()
                self.view.addSubview(self.collectionView!)
            }
            
        } else {
            openHome()
            self.view.addSubview(collectionView!)
        }
        collectionVieShow()
    }
    
    func openHome() {
        self.speechRecognizer?.delegate = self
        self.button?.isEnabled = false
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.button.isEnabled = isButtonEnabled
            }
        }
        
        self.sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
        GlobalFunc().navBar(nav: self.navigationItem, s: self, show: true)
        UIApplication.shared.statusBarView?.backgroundColor = .white//BACKGROUND STATUS BAR WHITE
        GlobalFunc().checkInternet(s: self)//INTERNET
        
        self.view.backgroundColor = .white
        self.imgWave = UIImageView (image: self.imgUrlLogo)
        self.imgWave.alpha = 0.8
        self.imgWave.frame = CGRect(x: -self.view.frame.width*0.6, y: self.view.frame.height*0.55, width: self.view.frame.width*2, height: self.view.frame.width)
        self.view.addSubview(self.imgWave)
        
        self.inputText = UITextField(frame: CGRect(x: 0, y: self.view.frame.height*0.92, width: self.view.frame.width, height: self.view.frame.height*0.08))
        self.inputText.backgroundColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.inputText.placeholder = "Say something..."
        self.inputText.textColor = .black
        self.inputText.delegate = self
        self.inputText.layer.sublayerTransform = CATransform3DMakeTranslation(12,0,0)
        self.inputText.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        
        self.button = UIButton(type: .custom)
        self.button.setImage(UIImage(named: "google_mic"), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20)
        self.button.frame = CGRect(x: CGFloat(self.inputText.frame.size.width - 30), y: CGFloat(5), width: CGFloat(35), height: CGFloat(35))
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.microphoneTapped(sender:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping))
        self.button.addGestureRecognizer(longPressRecognizer)
        self.button.addGestureRecognizer(tapGestureRecognizer)
        self.inputText.rightView = self.button
        self.inputText.rightViewMode = .always
        self.inputText.addTarget(self, action: #selector(self.textFieldDidChange(inputText:)), for: UIControlEvents.editingChanged)
        
        self.imageView = GIFImageView(frame: CGRect(x: -self.view.frame.width*0.5, y: self.view.frame.height*0.55, width: self.view.frame.width*2, height: self.view.frame.width))
        self.imageView.animate(withGIFNamed: "load-voice")
        self.imageView.alpha = 0
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.inputText)
        
        //LISTENER TASTIERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.textFieldShouldReturnClose))
        self.view.addGestureRecognizer(tap)
        
        self.lblTimer.backgroundColor = .clear
        self.lblTimer.textColor = .black
        self.lblTimer.addTextSpacing()
        self.lblTimer.font = UIFont(name: "AvenirLTStd-Heavy", size: 14)
        self.lblTimer.frame = CGRect(x: GlobalSize().widthScreen*0.05, y: self.view.frame.height*0.85, width: GlobalSize().widthScreen*0.15, height: self.view.frame.height*0.08)
    }
    
    func collectionVieShow() {
        
        messagesChatBot = ["What's up ?"]
        messagesTypeChatBot = [true]
        
        //CHAT
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 100)
        
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.9)
        collectionView?.register(ChatControllerCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview((collectionView)!)
    }
    
    func listeningTime() {
        timeListening = Date.timeIntervalSinceReferenceDate - startTime
        let timeString = String(Int(timeListening))
        if timeListening < 10 {
            lblTimer.text = "00:0" + timeString
        } else if timeListening >= 100 {
            lblTimer.text = "0" + timeString.insert(string: ":", ind: 1)
        } else {
            lblTimer.text = "00:" + timeString
        }
        self.view.addSubview(lblTimer)
        
        if stringListening == 0 {
            self.inputText.placeholder = "I'm listening"
            stringListening = 1
        } else if stringListening == 1 {
            self.inputText.placeholder = "I'm listening."
            stringListening = 2
        } else if stringListening == 2 {
            self.inputText.placeholder = "I'm listening.."
            stringListening = 3
        } else if stringListening == 3 {
            self.inputText.placeholder = "I'm listening..."
            stringListening = 0
        }
    }
    
    func microphoneTapped(sender: UILongPressGestureRecognizer) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        if sender.state == .began {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            startRecording()
            startTime = Date().timeIntervalSinceReferenceDate
            button?.isEnabled = false
            self.inputText.placeholder = "I'm listening..."
            imageView.alpha = 1
            animateBall()
        } else if sender.state == .ended {
            audioEngine.stop()
            timerListening.invalidate()
            recognitionRequest?.endAudio()
            button?.isEnabled = false
            lblTimer.text = ""
            self.inputText.placeholder = "Say something..."
            imageView.alpha = 0
            ball.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: {
                self.ball.alpha = 0
                self.ball.frame = CGRect(x: GlobalSize().widthScreen*0.78, y: (GlobalSize().heightScreen-GlobalSize().widthScreen*0.18), width: GlobalSize().widthScreen*0.36, height: GlobalSize().widthScreen*0.36)
                self.ball.layer.cornerRadius = GlobalSize().widthScreen*0.18
            })
        }
    }
    
    //COLLECTIONVIEW
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messagesChatBot?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatControllerCell
        
        var title:String = ""
        let titleFont:CGFloat = 10
        var colorUser:UIColor = UIColor.init(red: 80/255, green: 227/255, blue: 226/255, alpha: 1)
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        cell.messageTextView.text = messagesChatBot?[indexPath.row]
        cell.btnLink.alpha = 0
        cell.imgNeed.alpha = 0
        
        cell.alpha = 0.1
        cell.messageTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 20 )
        if (((messagesChatBot?.count)!-1 - indexPath.row) < 3) {
            cell.alpha = 0.3
            cell.messageTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 22)
        }
        if ((messagesChatBot?.count)!-1 == indexPath.row){
            cell.alpha = 1
            cell.messageTextView.font = UIFont(name: "AvenirLTStd-Heavy", size: 24)
        }
        
        if let messagesTypeText = messagesTypeChatBot?[indexPath.row] {
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
            
            if let messageText = messagesChatBot?[indexPath.row] {
                let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)], context: nil)
                cell.messageTextView.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: 10, width: GlobalSize().widthScreen*0.84, height: estimatedFrame.height + 25)
                if messagesTypeText {
                    if ((messagesTypeChatBot?.count)!-1) == indexPath.row {
                        if responseNeedBtn {
                            let estimatedFrameText = NSString(string: responseText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
                            if responseText == "Show needs" {
                                cell.imgNeed.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: cell.messageTextView.frame.height+5, width: GlobalSize().heightScreen*0.08, height: GlobalSize().heightScreen*0.08)
                                cell.imgNeed.alpha = 1
                                cell.imgNeed.sd_setImage(with: URL(string: self.responseImg), placeholderImage: UIImage(named: "default"))
                                cell.imgNeed.layer.cornerRadius = GlobalSize().heightScreen*0.04
                                cell.btnLink.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: cell.messageTextView.frame.height+5, width: estimatedFrameText.width+120, height: GlobalSize().heightScreen*0.08)
                                cell.btnLink.layer.cornerRadius = GlobalSize().heightScreen*0.04
                            } else if responseText == "check_recipe" {
                                
                                cell.imgNeed.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: cell.messageTextView.frame.height+5, width: estimatedFrameText.width+100, height: GlobalSize().heightScreen*0.18)
                                cell.imgNeed.alpha = 1
                                
                                print(self.responseTypeMeal)
                                
                                var index = 0
                                if self.responseTypeMeal == "breakfast" {
                                    index = 1+(4*responseIndexImage)
                                } else if self.responseTypeMeal == "lunch" {
                                    index = 2+(4*responseIndexImage)
                                } else if self.responseTypeMeal == "dinner" {
                                    index = 3+(4*responseIndexImage)
                                } else {
                                    index = 3+(4*responseIndexImage)
                                }
                                print(index)
                                
                                cell.imgNeed.sd_setImage(with: URL(string: dailyMealRecipesImage[index]), placeholderImage: UIImage(named: "default"))
                                cell.imgNeed.layer.cornerRadius = 0
                                responseText = dailyMealRecipesTitle[index]
                                cell.btnLink.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: cell.messageTextView.frame.height+5+(GlobalSize().heightScreen*0.18), width: estimatedFrameText.width+100, height: GlobalSize().heightScreen*0.08)
                                
                                let rectShape = CAShapeLayer()
                                rectShape.bounds = cell.btnLink.frame
                                rectShape.position = cell.btnLink.center
                                rectShape.path = UIBezierPath(roundedRect: cell.btnLink.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
                                cell.btnLink.backgroundColor = GlobalColor().backgroundCollectionView
                                cell.btnLink.layer.mask = rectShape
                                
                                let rectShape1 = CAShapeLayer()
                                rectShape1.bounds = cell.imgNeed.frame
                                rectShape1.position = cell.imgNeed.center
                                rectShape1.path = UIBezierPath(roundedRect: cell.imgNeed.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
                                cell.imgNeed.layer.mask = rectShape1
                                
                            } else {
                                cell.btnLink.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: cell.messageTextView.frame.height+5, width: estimatedFrameText.width+50, height: GlobalSize().heightScreen*0.08)
                                cell.btnLink.layer.cornerRadius = GlobalSize().heightScreen*0.04
                            }
                            cell.btnLink.setTitle(responseText, for: .normal)
                            cell.btnLink.alpha = 1
                            
                            if responseText == "Show needs" {
                                saveData.set(true, forKey: "boolNeed")
                                cell.btnLink.addTarget(self, action: #selector(self.goToNeeds), for: .touchUpInside)
                            } else if responseText == "Your shopping list" {
                                cell.btnLink.addTarget(self, action: #selector(self.goToShoppingList), for: .touchUpInside)
                            }
                            
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func goToShoppingList() {
        let newViewController = HomeShoppingListController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func goToNeeds() {
        let newViewController = EmergencyController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = messagesChatBot?[indexPath.row] {
            let size = CGSize(width: 300, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)], context: nil)
            var heightChat = estimatedFrame.height + 50
            if ((messagesTypeChatBot?.count)!-1) == indexPath.row {
                if responseNeedBtn {
                    if responseText == "check_recipe" {
                        heightChat = estimatedFrame.height*2 + GlobalSize().heightScreen*0.25 + 40
                    }
                    else {
                        heightChat = estimatedFrame.height*2 + GlobalSize().heightScreen*0.08 + 40
                    }
                }
            }
            return CGSize(width: view.frame.width, height: heightChat)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    //COLLECTIONVIEW
    
    func textFieldDidChange(inputText: UITextField) {
        if inputText.text! != "" {
            button.setImage(UIImage(named: "send_logo"), for: .normal)
        } else {
            button.setImage(UIImage(named: "google_mic"), for: .normal)
        }
    }
    func singleTapping() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let textTrimmed = (inputText.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textTrimmed != "" {
            printOnCollectionView(text: textTrimmed, who: false)
            var parameter:[String : Any]
            if saveData.string(forKey: "shopping_list") != nil {
                parameter = [
                    "chat": textTrimmed,
                    "mail": saveData.string(forKey: "email")!,
                    "lat": saveData.double(forKey: "latitudeHistory"),
                    "long": saveData.double(forKey: "longitudeHistory"),
                    "list_id": saveData.string(forKey: "shopping_list")!
                    ] as [String : Any]
            } else {
                parameter = [
                    "chat": textTrimmed,
                    "mail": saveData.string(forKey: "email")!,
                    "lat": saveData.double(forKey: "latitudeHistory"),
                    "long": saveData.double(forKey: "longitudeHistory")
                    ] as [String : Any]
            }
            
            inputText.text = ""
            button.setImage(UIImage(named: "google_mic"), for: .normal)
            inputText.text = ""
            
            Alamofire.request("https://api.mhint.eu/chat", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                if response.response?.statusCode == 200 {
                    print((response.value! as AnyObject))
                    print("V: ", (response.value! as AnyObject)["obj"]! as! [String: Any])
                    self.responseNeedBtn = false
                    let type = (response.value! as AnyObject)["model"]! as! String
                    let obj = (response.value! as AnyObject)["obj"]! as! [String: Any]
                    if obj.count > 0 {
                        self.responseNeedBtn = true
                        if type == "need_action" {
                            self.responseText = "Show needs"
                            if let user = obj["user_receiver"] as? [String: Any] {
                                self.responseImg = user["image_profile"] as! String
                            }
                        } else if type == "shopping_list" || type == "add_item" || type == "remove_item" {
                            print(1)
                            self.responseText = "Your shopping list"
                        } else if type == "check_recipe" {
                            self.responseText = type
                            self.responseTypeMeal = obj["type"] as! String
                            self.responseIndexImage = 0
                            if let date = obj["date"] {
                                self.responseIndexImage = date as! Int
                            }
                            self.dailyMealRecipesImage = saveData.array(forKey: "recipesImage") as! [String]
                            self.dailyMealRecipesTitle = saveData.array(forKey: "recipesTitle") as! [String]
                        } else {
                            self.responseNeedBtn = false
                            self.responseText = ""
                            self.responseImg = ""
                        }
                    }
                    self.printOnCollectionView(text: ((response.value! as AnyObject)["text"]! as! String), who: true)
                } else {
                    self.printOnCollectionView(text: "There was an error procesing your request", who: true)
                }
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.inputText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            // print("IS FINAL: ",isFinal)
            
            if (error != nil || isFinal) {
                self.audioEngine.stop()
                self.view.endEditing(true)
                let textTrimmed = (self.inputText.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if textTrimmed != "" {
                    self.button.setImage(UIImage(named: "send_logo"), for: .normal)
                }
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.button.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        inputText.text = ""
    }
    
    func animateBall() {
        ball.frame = CGRect(x: GlobalSize().widthScreen*0.76, y: (GlobalSize().heightScreen-GlobalSize().widthScreen*0.24), width: GlobalSize().widthScreen*0.36, height: GlobalSize().widthScreen*0.36)
        ball.layer.cornerRadius = GlobalSize().widthScreen*0.18
        ball.layer.masksToBounds = true
        ball.backgroundColor = GlobalColor().greenSea
        ball.alpha = 0.7
        self.view.addSubview(ball)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.ball.frame = CGRect(x: GlobalSize().widthScreen*0.78, y: (GlobalSize().heightScreen-GlobalSize().widthScreen*0.22), width: GlobalSize().widthScreen*0.38, height: GlobalSize().widthScreen*0.38)
            self.ball.layer.cornerRadius = GlobalSize().widthScreen*0.19
        }, completion: nil)
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            button.isEnabled = true
        } else {
            button.isEnabled = false
        }
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        print("didFinishSuccessfully")
    }
    
    func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
        print("speechRecognitionTaskFinishedReadingAudio")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    func keyboardDown(notification: Notification) {
        tastieraInOut(su: false, notification: notification)
    }
    
    func keyboardWillChangeFrame(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tastieraInOut(su: true, notification: notification as Notification)
        }
    }
    
    func tastieraInOut(su: Bool, notification: Notification) {
        let info = notification.userInfo
        let fineTastiera: CGRect = ((info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        let durataAnimazione: TimeInterval = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: durataAnimazione, delay: 0, options: .curveEaseInOut, animations: {
            let dimensioneTastiera = self.view.convert(fineTastiera, to: nil)
            let spostamentoVerticale = dimensioneTastiera.size.height * (su ? -1 : 1)
            
            if su {
                self.view.frame.origin.y = spostamentoVerticale
                self.collectionView?.frame.origin.y = dimensioneTastiera.size.height
                self.collectionView?.frame.size.height = GlobalSize().heightScreen*0.9 - dimensioneTastiera.size.height
            } else {
                self.view.frame.origin.y = 0
                self.collectionView?.frame.origin.y = 0
                self.collectionView?.frame.size.height = GlobalSize().heightScreen*0.9
            }
            
            let itemA = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
            let lastItemIndex = NSIndexPath(item: itemA, section: 0)
            self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        singleTapping()
        return false
    }
    
    func textFieldShouldReturnClose(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //AGGIORNA LA COLLECTION VIEW E SCROLLA ALL'ULTIMO MESSAGGIO
    //TEXT: (LA STRINGA CHE DEVE ESSERE INSERITA), WHO: (CHI SCRIVE IL MESSAGGIO TRUE O FALSE)
    func printOnCollectionView(text: String, who: Bool) {
        messagesChatBot?.append(text)
        messagesTypeChatBot?.append(who)
        collectionView?.reloadData()
        
        let itemA = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(item: itemA, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
    }
    
    
}
