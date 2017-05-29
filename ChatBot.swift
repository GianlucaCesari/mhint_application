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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        sideMenuViewController?.panGestureLeftEnabled = true //DA ATTIVARE ALLA FINE DELLA CHAT
        GlobalFunc().navBar(nav: navigationItem, s: self, show: true)
        UIApplication.shared.statusBarView?.backgroundColor = .white//BACKGROUND STATUS BAR WHITE
        GlobalFunc().checkInternet(s: self)//INTERNET
        
//        INTERFACE
        self.view.backgroundColor = .white
        imgWave = UIImageView (image: imgUrlLogo)
        let marginTopImage = (view.frame.height*0.85 - (view.frame.width/4))
        imgWave.frame = CGRect(x: 0, y: marginTopImage, width: view.frame.width, height: view.frame.width/2)
        
        let inputText = UITextField(frame: CGRect(x: view.frame.width*0.02, y: view.frame.height*0.91, width: view.frame.width*0.96, height: view.frame.height*0.08))
        inputText.backgroundColor = GlobalColor().backgroundCollectionView
        inputText.placeholder = "Say something..."
        inputText.textColor = .black
        inputText.layer.cornerRadius = 25
        inputText.layer.masksToBounds = true
        inputText.layer.sublayerTransform = CATransform3DMakeTranslation(35,0,0)
        inputText.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        
        button = UIButton(type: .custom)
        button.setImage(UIImage(named: "google_mic"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 50)
        button.frame = CGRect(x: CGFloat(inputText.frame.size.width - 25), y: CGFloat(5), width: CGFloat(17.5), height: CGFloat(25))
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
        
        collectionView?.backgroundColor = .white

    }
    
    func textFieldDidChange(inputText: UITextField) {
        if inputText.text! != "" {
            button.setImage(UIImage(named: "send_logo"), for: .normal)
        } else {
            button.setImage(UIImage(named: "google_mic"), for: .normal)
        }
    }
    func singleTapping() {
        print("image clicked")
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

}
