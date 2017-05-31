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

class ChatBotController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate {
    
    var imgWave: UIImageView!
    let imgUrlLogo = UIImage(named: "wave")
    var keyboardOpen = false
    var button : UIButton!
    
    var messagesChatBot: [String]?
    var messagesTypeChatBot: [Bool]?
    
    var inputText = UITextField()
    
    let cellId = "chatBot"
    
//    SPEECH RECOGNIZER
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-EN"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechRecognizer?.delegate = self
        button?.isEnabled = false
        
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

        
        messagesChatBot = ["What's up ?"]
        messagesTypeChatBot = [true]
        
        sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
        GlobalFunc().navBar(nav: navigationItem, s: self, show: true)
        UIApplication.shared.statusBarView?.backgroundColor = .white//BACKGROUND STATUS BAR WHITE
        GlobalFunc().checkInternet(s: self)//INTERNET
        
//      INTERFACE
        self.view.backgroundColor = .white
        imgWave = UIImageView (image: imgUrlLogo)
        let marginTopImage = (view.frame.height*0.85 - (view.frame.width/4))
        imgWave.alpha = 0.2
        imgWave.frame = CGRect(x: 0, y: marginTopImage, width: view.frame.width, height: view.frame.width/2)
        
        inputText = UITextField(frame: CGRect(x: 0, y: view.frame.height*0.92, width: view.frame.width, height: view.frame.height*0.08))
        inputText.backgroundColor = UIColor.init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        inputText.placeholder = "Say something..."
        inputText.textColor = .black
        inputText.delegate = self
//        inputText.layer.cornerRadius = 25
//        inputText.layer.masksToBounds = true
        inputText.layer.sublayerTransform = CATransform3DMakeTranslation(12,0,0)
        inputText.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "google_mic"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20)
        button.frame = CGRect(x: CGFloat(inputText.frame.size.width - 30), y: CGFloat(5), width: CGFloat(35), height: CGFloat(35))
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.microphoneTapped(sender:)))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapping))
        button.addGestureRecognizer(longPressRecognizer)
        button.addGestureRecognizer(tapGestureRecognizer)
//        button.addTarget(self, action: #selector(singleTapping), for: .touchUpInside)
        inputText.rightView = button
        inputText.rightViewMode = .always
        inputText.addTarget(self, action: #selector(textFieldDidChange(inputText:)), for: UIControlEvents.editingChanged)
        
//        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapping(recognizer:)))
//        singleTap.numberOfTapsRequired = 1;
//        imgMic.addGestureRecognizer(singleTap)
        
        self.view.addSubview(imgWave)
        self.view.addSubview(inputText)
//        self.view.addSubview(imgMic)
        
//        LISTENER TASTIERA
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturnClose))
        self.view.addGestureRecognizer(tap)
        
        
        

        //CHAT
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.9)
        collectionView?.register(ChatControllerCell.self, forCellWithReuseIdentifier: cellId)
        self.view.addSubview((collectionView)!)
    }
    
    func microphoneTapped(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if (inputText.text! == "") {
                startRecording()
                button?.isEnabled = false
            }
        } else if sender.state == .ended {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            button?.isEnabled = false
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
            if messagesTypeText {
                //MHINT
                title = "Mhint"
                colorUser = UIColor.init(red: 80/255, green: 227/255, blue: 226/255, alpha: 1)
                cell.messageTextView.textAlignment = .left
                cell.titleTextView.textAlignment = .left
                cell.roundColor.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
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
            cell.titleTextView.frame = CGRect(x: 21, y: -6, width: 300 + 20, height: estimatedFrameTitle.height + 20)
            
            if let messageText = messagesChatBot?[indexPath.row] {
                let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)], context: nil)
                cell.messageTextView.frame = CGRect(x: 27, y: 10, width: 300 + 20, height: estimatedFrame.height + 25)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = messagesChatBot?[indexPath.row] {
            let size = CGSize(width: 300, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 50)
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
        let textTrimmed = (inputText.text!).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textTrimmed != "" {
            printOnCollectionView(text: textTrimmed, who: false)
            let parameter = [
                "message": textTrimmed//STRING
            ] as [String : Any]
            inputText.text = ""
            button.setImage(UIImage(named: "google_mic"), for: .normal)
            Alamofire.request("https://nodered.mhint.eu/chat", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
                self.printOnCollectionView(text: ((response.value! as AnyObject)["message"]! as! String), who: true)
            }
        }
//        } else {
//            startRecording()
//            button.isEnabled = false
//        }
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
            if error != nil || isFinal {
                print("finito")
                self.audioEngine.stop()
                self.view.endEditing(true)
                self.button.setImage(UIImage(named: "send_logo"), for: .normal)
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
        guard su != keyboardOpen else {
            return
        }
        let info = notification.userInfo
        let fineTastiera: CGRect = ((info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        let durataAnimazione: TimeInterval = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        if fineTastiera.size.height > 216 {
        
            UIView.animate(withDuration: durataAnimazione, delay: 0, options: .curveEaseInOut, animations: {
                let dimensioneTastiera = self.view.convert(fineTastiera, to: nil)
                let spostamentoVerticale = dimensioneTastiera.size.height * (su ? -1 : 1)
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: spostamentoVerticale)
                self.collectionView?.frame.origin.y = (su ? dimensioneTastiera.size.height : 0)
                self.collectionView?.frame.size.height = (su ? GlobalSize().heightScreen*0.9 - dimensioneTastiera.size.height : GlobalSize().heightScreen*0.9)
                self.keyboardOpen = !self.keyboardOpen
            }, completion: nil)
            
        }
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