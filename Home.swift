//
//  ChatBot.swift
//  Mhint
//
//  Created by Gianluca Cesari on 5/26/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import UIKit

class ChatBotController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var imgWave: UIImageView!
    let imgUrlLogo = UIImage(named: "wave")
    var keyboardOpen = false
    var button : UIButton!
    
    var messagesChatBot: [String]?
    var messagesTypeChatBot: [Bool]?
    
    var inputText = UITextField()
    
    let cellId = "chatBot"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        imgWave.frame = CGRect(x: 0, y: marginTopImage, width: view.frame.width, height: view.frame.width/2)
        
        inputText = UITextField(frame: CGRect(x: view.frame.width*0.04, y: view.frame.height*0.9, width: view.frame.width*0.92, height: view.frame.height*0.08))
        inputText.backgroundColor = GlobalColor().backgroundCollectionView
        inputText.placeholder = "Say something..."
        inputText.textColor = .black
        inputText.layer.cornerRadius = 25
        inputText.layer.masksToBounds = true
        inputText.layer.sublayerTransform = CATransform3DMakeTranslation(20,0,0)
        inputText.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "google_mic"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 50)
        button.frame = CGRect(x: CGFloat(inputText.frame.size.width - 30), y: CGFloat(5), width: CGFloat(17.5), height: CGFloat(25))
        button.addTarget(self, action: #selector(singleTapping), for: .touchUpInside)
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        self.view.addGestureRecognizer(tap)

        //CHAT
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.sectionInset = UIEdgeInsetsMake(8, 0, 0, 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.7)
        
        collectionView?.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height*0.7)
        collectionView?.register(ChatControllerCell.self, forCellWithReuseIdentifier: cellId)
        
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
        print("image clicked")
        printOnCollectionView(text: (inputText.text!), who: false)
        inputText.text = ""
        button.setImage(UIImage(named: "google_mic"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardDown(notification: Notification) {
        tastieraInOut(su: false, notification: notification)
    }
    
    func keyboardUp(notification: Notification) {
        tastieraInOut(su: true, notification: notification)
    }
    
    func tastieraInOut(su: Bool, notification: Notification) {
        guard su != keyboardOpen else {
            return
        }
        let info = notification.userInfo
        let fineTastiera: CGRect = ((info?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        let durataAnimazione: TimeInterval = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: durataAnimazione, delay: 0, options: .curveEaseInOut, animations: {
            let dimensioneTastiera = self.view.convert(fineTastiera, to: nil)
            let spostamentoVerticale = dimensioneTastiera.size.height * (su ? -1 : 1)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: spostamentoVerticale)
            self.keyboardOpen = !self.keyboardOpen
        }, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
