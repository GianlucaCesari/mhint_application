//
//  addEmergency.swift
//  Mhint
//
//  Created by Gianluca Cesari on 6/7/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Alamofire

class addEmergency: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    let map = MKMapView()
    var keyboardOpen = false
    
    let titleEmergency = UITextField()
    let descriptionEmergency = UITextView()
    var tap = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveData.set(true, forKey: "earlyAddEmergency")
        
        self.view.backgroundColor = .white
        
        GlobalFunc().navBarSubView(nav: navigationItem, s: self, title: "ASK A NEED")
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "arrowLeft")
        btnMenu.frame = CGRect(x: 0, y: 20, width: GlobalSize().sizeIconMenuBar, height: GlobalSize().sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(self, action: #selector(self.back(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        map.showsBuildings = true
        let coordinates = CLLocationCoordinate2DMake(saveData.double(forKey: "latitudeHistory"),saveData.double(forKey: "longitudeHistory"))
        map.region = MKCoordinateRegionMakeWithDistance(coordinates, 0,0)
        
        map.mapType = MKMapType.standard
        
        // 3D Camera
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coordinates
        mapCamera.pitch = 45
        mapCamera.altitude = 100
        mapCamera.heading = 0
        
        // Set MKmapView camera property
        self.map.camera = mapCamera
        
        map.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: GlobalSize().heightScreen*0.12, width: GlobalSize().widthScreen*0.84, height: GlobalSize().heightScreen*0.3)
        map.layer.cornerRadius = 7
        map.layer.masksToBounds = true
        map.mapType = MKMapType.standard
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        self.map.addAnnotation(annotation)
        
        self.view.addSubview(map)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturnClose))
        self.view.addGestureRecognizer(tap)
        
        titleEmergencyFunc()
        descriptionEmergencyFunc()
        
        btnSendEmergency()
    }
    
    func titleEmergencyFunc() {
        titleEmergency.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: GlobalSize().heightScreen*0.4375, width: GlobalSize().widthScreen*0.84, height: GlobalSize().heightScreen*0.1)
        
        let attributesDictionary = [NSForegroundColorAttributeName: UIColor.lightGray]
        titleEmergency.attributedPlaceholder = NSAttributedString(string: "What do you need ?", attributes: attributesDictionary)
        
        titleEmergency.textColor = .black
        titleEmergency.layer.cornerRadius = 7
        titleEmergency.layer.masksToBounds = true
        titleEmergency.layer.sublayerTransform = CATransform3DMakeTranslation(20,0,0)
        titleEmergency.delegate = self
        titleEmergency.backgroundColor = GlobalColor().backgroundCollectionView
        titleEmergency.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        self.view.addSubview(titleEmergency)
    }
    
    func descriptionEmergencyFunc() {
        
        descriptionEmergency.frame = CGRect(x: GlobalSize().widthScreen*0.08, y: GlobalSize().heightScreen*0.555, width: GlobalSize().widthScreen*0.84, height: GlobalSize().heightScreen*0.3)
        
        descriptionEmergency.text = "Be more precise"
        descriptionEmergency.textColor = .lightGray
        descriptionEmergency.layer.cornerRadius = 7
        descriptionEmergency.layer.masksToBounds = true
        descriptionEmergency.layer.sublayerTransform = CATransform3DMakeTranslation(20,20,20)
        descriptionEmergency.delegate = self
        descriptionEmergency.backgroundColor = GlobalColor().backgroundCollectionView
        descriptionEmergency.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.04)
        self.view.addSubview(descriptionEmergency)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Be more precise"
            textView.textColor = .lightGray
        }
    }
    
    func btnSendEmergency() {
        let btn = UIButton()
        btn.setTitle("SEND", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.04)
        btn.backgroundColor = GlobalColor().greenSea
        btn.addTarget(self, action: #selector(sendEmergency), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.9, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(btn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        super.viewWillAppear(true)
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
    
    func sendEmergency() {
        let textTrimmed = (titleEmergency.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var textTrimmedDescription = (descriptionEmergency.text)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if textTrimmed != "" {
            if textTrimmedDescription! == "Be more precise" {
                textTrimmedDescription = ""
            }
            titleEmergency.text = ""
            descriptionEmergency.text = "Be more precise"
            descriptionEmergency.textColor = .lightGray
            
            let parameter = [
                "mail": GlobalUser.email
                , "name": textTrimmed!
                , "description": textTrimmedDescription!
                , "lat": saveData.string(forKey: "latitudeHistory")!
                , "long": saveData.string(forKey: "longitudeHistory")!
            ] as [String : Any]
            Alamofire.request("https://api.mhint.eu/need", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { JSON in
                var name = ""
                if let json = JSON.result.value as? [String: Any]{
                    if let value = json["value"] as? [String: Any] {
                        if let user = value["user_receiver"] as? [String: Any] {
                            name = user["name"]! as! String
                            self.animationImage(i: user["image_profile"] as! String, n: user["name"]! as! String)
                        }
                    }
                }
                //GlobalFunc().alertCustom(stringAlertTitle: "Emergency successfully sent", stringAlertDescription: "Sent to \(name)", button: "Yeee", s: self)
            }
        } else {
            GlobalFunc().alertCustom(stringAlertTitle: "Emergency not sent", stringAlertDescription: "Title must be filled", button: "Ok", s: self)
        }
    }
    
    func animationImage(i: String, n: String) {
        
        let viewOverlay = UIView()
        viewOverlay.backgroundColor = .black
        viewOverlay.alpha = 0
        viewOverlay.frame = CGRect(x: 0, y: 0, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen)
        self.view.addSubview(viewOverlay)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            viewOverlay.alpha = 0.6
        }, completion: nil)
        
        let imgProfile = UIImageView()
        imgProfile.frame = CGRect(x: GlobalSize().widthScreen*0.375, y: GlobalSize().heightScreen*1.5, width: GlobalSize().widthScreen*0.25, height: GlobalSize().widthScreen*0.25)
        imgProfile.sd_setImage(with: URL(string: i), placeholderImage: nil)
        imgProfile.layer.cornerRadius = GlobalSize().widthScreen*0.125
        imgProfile.layer.borderWidth = 5
        imgProfile.layer.borderColor = GlobalColor().greenSea.cgColor
        imgProfile.layer.masksToBounds = true
        self.view.addSubview(imgProfile)
        
        let label = UILabel()
        label.text = "Need sent to".uppercased()
        label.alpha = 0
        label.addTextSpacing()
        label.textColor = .white
        label.font = UIFont(name: "AvenirLTStd-Black", size: GlobalSize().widthScreen*0.025)
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.5, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(label)
        
        let labelName = UILabel()
        labelName.text = "\(n)"
        labelName.alpha = 0
        labelName.textColor = .white
        labelName.font = UIFont(name: "AvenirLTStd-Medium", size: GlobalSize().widthScreen*0.085)
        labelName.textAlignment = .center
        labelName.frame = CGRect(x: 0, y: GlobalSize().heightScreen*0.55, width: GlobalSize().widthScreen, height: GlobalSize().heightScreen*0.1)
        self.view.addSubview(labelName)
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
            imgProfile.frame.origin.y = GlobalSize().heightScreen*0.38
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveLinear, animations: {
            label.alpha = 1
            labelName.alpha = 1
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.2, delay: 1, options: .curveLinear, animations: {
                labelName.alpha = 0
                label.alpha = 0
                imgProfile.alpha = 0
                viewOverlay.alpha = 0
            })
        })
    }
    
    func textFieldShouldReturnClose(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func back(sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
}
