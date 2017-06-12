//
//  indexBotSetting.swift
//  Mhint
//
//  Created by Andrea Merli on 07/05/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import Alamofire


class botController: UIViewController, UITextFieldDelegate, SKStoreProductViewControllerDelegate{
    
    var textInputTelegram: UITextField?
    var keyboardOpen = false
    
    override func viewDidLoad() {
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "Bots")
        self.view.backgroundColor = .white
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 0, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        builderInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        super.viewWillAppear(true)
        builderInterface()
    }
    
    func builderInterface () {
        
        
        //builder interface
        
        let imgTelegram = UIImageView(frame: CGRect(x: GlobalSize().widthScreen*0.07, y: GlobalSize().heightScreen*0.12, width: GlobalSize().heightScreen*0.1, height: GlobalSize().heightScreen*0.1))
        let img = UIImage(named: "telegram_bot_icon")
        imgTelegram.image = img
        
        let labelLinkTelegram = UILabel()
        labelLinkTelegram.addTextSpacing()
        labelLinkTelegram.textAlignment = .left
        labelLinkTelegram.text = "LINK YOUR TELEGRAM BOT"
        labelLinkTelegram.textColor = .black
        labelLinkTelegram.font = UIFont(name: "AvenirLTStd-Black", size: 13)
        labelLinkTelegram.frame = CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.17, width: GlobalSize().widthScreen*0.8, height: GlobalSize().heightScreen*0.1)
        
        let followLinkLabel = UILabel(frame: CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.27, width: GlobalSize().widthScreen*0.8, height: GlobalSize().heightScreen*0.1))
        followLinkLabel.textAlignment = .left
        followLinkLabel.text = "Follow this link and write /start:"
        followLinkLabel.textColor = .black
        followLinkLabel.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        
        let telegramButton = UIButton(frame: CGRect(x: GlobalSize().widthScreen*0.09, y: GlobalSize().heightScreen*0.33, width: GlobalSize().widthScreen*0.7, height: GlobalSize().heightScreen*0.1))
        telegramButton.setTitle("mhint.telegram.com", for: .normal)
        telegramButton.backgroundColor = .clear
        telegramButton.setTitleColor(UIColor(red: 61/255, green: 194/255, blue: 234/255, alpha: 1), for: .normal)
        telegramButton.titleLabel?.textAlignment = .left
        telegramButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 27)
        telegramButton.addTarget(self, action: #selector(goToTelegram), for: .touchUpInside)
        
        textInputTelegram = UITextField(frame: CGRect(x: GlobalSize().widthScreen*0.1, y: GlobalSize().heightScreen*0.55, width: GlobalSize().widthScreen*0.8, height: GlobalSize().heightScreen*0.12))
        textInputTelegram?.backgroundColor = GlobalColor().backgroundCollectionView
        textInputTelegram?.placeholder = "Insert your code here"
        textInputTelegram?.textColor = .black
        textInputTelegram?.layer.cornerRadius = 10
        textInputTelegram?.layer.masksToBounds = true
        textInputTelegram?.layer.sublayerTransform = CATransform3DMakeTranslation(20,0,0)
        textInputTelegram?.font = UIFont(name: "AvenirLTStd-Medium", size: 15)
        
        let btnVerifyCodeTelegram = UIButton(frame: CGRect(x: GlobalSize().widthScreen*0.5, y: GlobalSize().heightScreen*0.7, width: GlobalSize().widthScreen*0.4, height: GlobalSize().heightScreen*0.1))
        btnVerifyCodeTelegram.backgroundColor = GlobalColor().greenSea
        btnVerifyCodeTelegram.setTitle("Verify", for: .normal)
        btnVerifyCodeTelegram.setTitleColor(.white, for: .normal)
        btnVerifyCodeTelegram.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 15)
        btnVerifyCodeTelegram.layer.cornerRadius = 10
        btnVerifyCodeTelegram.layer.masksToBounds = true
        btnVerifyCodeTelegram.addTarget(self, action: #selector(verifyCode), for: .touchUpInside)
        
        
        self.view.addSubview(btnVerifyCodeTelegram)
        self.view.addSubview(imgTelegram)
        self.view.addSubview(labelLinkTelegram)
        self.view.addSubview(followLinkLabel)
        self.view.addSubview(telegramButton)
        self.view.addSubview(textInputTelegram!)
        
        textInputTelegram?.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        self.view.addGestureRecognizer(tap)
        
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
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: spostamentoVerticale*0.7)
                self.keyboardOpen = !self.keyboardOpen
            }, completion: nil)
        }
    }
    
    func verifyCode() {
    // /botverify
//        mail e chat_id
        let mail = saveData.string(forKey: "email")
        let chat_id = textInputTelegram?.text
        print(chat_id!)
        let parameter = [
            "mail": mail!,
            "chat_id" : chat_id!
            ] as [String : Any]
        
        Alamofire.request("https://api.mhint.eu/botverify", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
        }

    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func goToTelegram() {
        let botURL = URL.init(string: "tg://resolve?domain=Mhint_bot")
        
        if UIApplication.shared.canOpenURL(botURL!) {
            UIApplication.shared.open(botURL!)
        } else {
            // Telegram is not installed.
            let controller = UIAlertController(title: "Telegram is not installed", message: "This function requires telegram to be installed", preferredStyle: .alert)
            let getTelegram = UIAlertAction(title: "Get Telegram", style: .default) { (_) -> Void in
                if #available(iOS 10.0, *) {
                    self.openStoreProductWithiTunesItemIdentifier(identifier: "686449807");
                } else {
                    let url  = NSURL(string: "itms://itunes.apple.com/us/app/telegram-messenger/id686449807?mt=8")
                    if UIApplication.shared.canOpenURL(url! as URL) == true  {
                        UIApplication.shared.open(url! as URL)
                    }
                    
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
                controller.dismiss(animated: true, completion: nil)
            }
            controller.addAction(getTelegram)
            controller.addAction(cancel)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { [weak self] (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
                self?.present(storeViewController, animated: true, completion: nil)
            }
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
