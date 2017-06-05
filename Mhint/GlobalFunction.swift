//
//  GlobalFunction.swift
//  Mhint
//
//  Created by Andrea Merli on 19/04/17.
//  Copyright © 2017 Andrea Merli. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift //INTERNET
import HealthKit //SALUTE
import Contacts //CONTACTS
import Alamofire //REQUEST INTERNET
import SwiftyGif //LOAD GIF
import Gifu //LOAD GIF

class GlobalFunc: UIView, UIGestureRecognizerDelegate{
    
    var globalSize = GlobalSize()
    var viewChatController = UIViewController()
    
    //NAVIGATION BAR TOP CHAT
    func navBar(nav: UINavigationItem, s: UIViewController, show: Bool) {
        
        s.navigationController?.interactivePopGestureRecognizer?.delegate = self
        s.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.backgroundColor = .white
        s.view.addSubview(view)
        
        if show != false{
            let btnMenu = UIButton.init(type: .custom)
            let imgMenu = UIImage(named: "iconMenu")
            btnMenu.frame = CGRect(x: 0, y: 0, width: globalSize.sizeIconMenuBar, height: globalSize.sizeIconMenuBar)
            btnMenu.setImage(imgMenu, for: .normal)
            btnMenu.addTarget(s, action: #selector(s.presentLeftMenuViewController(_:)), for: .touchUpInside)
            nav.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
        }
        
        let title = "MHINT"
        let titleLabel = UILabel()
        let attributes: [NSString : AnyObject] = [NSFontAttributeName as NSString: UIFont(name: "AvenirLTStd-Heavy", size: 13)!, NSKernAttributeName as NSString : 1.15 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes as [String : Any]?)
        titleLabel.sizeToFit()
        s.navigationItem.titleView = titleLabel
        
        s.navigationController?.navigationBar.barTintColor = GlobalColor().colorWhite
        s.navigationController?.navigationBar.backgroundColor = GlobalColor().colorWhite
        s.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        s.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func navBarMenu(nav: UINavigationItem, s: UIViewController) {
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        view.backgroundColor = .white
        s.view.addSubview(view)
        
        let btnMenu = UIButton.init(type: .custom)
        let imgMenu = UIImage(named: "iconMenu")
        btnMenu.frame = CGRect(x: 0, y: 0, width: globalSize.sizeIconMenuBar, height: globalSize.sizeIconMenuBar)
        btnMenu.setImage(imgMenu, for: .normal)
        btnMenu.addTarget(s, action: #selector(s.presentLeftMenuViewController(_:)), for: .touchUpInside)
        nav.leftBarButtonItem = UIBarButtonItem(customView: btnMenu)
    }
    
    //ALERT, ERROR, WARNING
    func alert(stringAlertTitle: String, stringAlertDescription: String, s: UIViewController) {
        
        let alert = UIAlertController(title: stringAlertTitle, message: stringAlertDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default, handler: nil))
        s.present(alert, animated: true, completion: nil)
        
    }
    
    //CUSTOM ALERT
    func alertCustom(stringAlertTitle: String, stringAlertDescription: String, button: String, s: UIViewController) {
        let alert = UIAlertController(title: stringAlertTitle, message: stringAlertDescription, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: button, style: UIAlertActionStyle.default, handler: nil))
        s.present(alert, animated: true, completion: nil)
    }
    
    //navigationRight v.a.
    func navBarRightChat(nav: UINavigationItem, s: UIViewController) {
        let btnMenu = UIButton.init(type: .custom)
        btnMenu.setTitle("v.a.", for: .normal)
        btnMenu.setTitleColor(.black, for: .normal)
        btnMenu.titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 12)
        btnMenu.frame = CGRect(x: 0, y: 0, width: globalSize.sizeIconMenuBar, height: globalSize.sizeIconMenuBar)
        viewChatController = s
        //btnMenu.addTarget(s, action: #selector(goToChat(sender:)), for: .touchUpInside)
        //nav.rightBarButtonItem = UIBarButtonItem(customView: btnMenu)
    }
    
    //NAVIGATION BAR INSIDE VIEW
    func navBarSubView(nav: UINavigationItem, s: UIViewController, title: String) {
        //navBarRightChat(nav: nav, s: s)
        
        let titleLabel = UILabel()
        let attributes: [NSString : AnyObject] = [NSFontAttributeName as NSString: UIFont(name: "AvenirLTStd-Heavy", size: 13)!, NSKernAttributeName as NSString : 1.15 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(), attributes: attributes as [String : Any]?)
        titleLabel.sizeToFit()
        s.navigationItem.titleView = titleLabel
            
        s.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirLTStd-Heavy", size: 13)!, NSKernAttributeName : 1.15]
        s.navigationController?.navigationBar.barTintColor = GlobalColor().colorWhite
        s.navigationController?.navigationBar.backgroundColor = GlobalColor().colorWhite
        s.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        s.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    //TITLEPAGE
    func titlePage(titlePage: String, s: UIViewController) {
        let title = UILabel()
        title.text = titlePage
        title.textColor = GlobalColor().colorBlack
        title.font = UIFont(name: "AvenirLTStd-Heavy", size: GlobalSize().widthScreen*0.065)
        title.frame = CGRect(x: GlobalSize().widthScreen*0.06, y: GlobalSize().heightScreen*0.1, width: GlobalSize().widthScreen, height: GlobalSize().widthScreen*0.1)
        s.view.addSubview(title)
    }
    
    
    
    //SALVA NELLA CACHE    
    func saveUserProfile(value: Any, description: String) {
        saveData.set(value, forKey: description)
    }
    //SALVA NELLA CACHE
    
    
    //PRENDI DATI SALUTE
    func getBodyData(hM: HKHealthStore) {
        self.getWeight(healthManager: hM)
        self.getHeight(healthManager: hM)
        self.getSex(healthManager: hM)
        self.getBirthday(healthManager: hM)
        self.getBlood(healthManager: hM)
    }
    func getBlood(healthManager: HKHealthStore) {
        var bloodType:Int = 0
        do {
            bloodType = try healthManager.bloodType().bloodType.rawValue
        } catch {}
        GlobalUser.blood = bloodType
        self.saveUserProfile(value: bloodType, description: "blood")
    }
    func getSex(healthManager: HKHealthStore) {
        var biologicalSex:Int = 0
        do {
            biologicalSex = try healthManager.biologicalSex().biologicalSex.rawValue
        } catch {}
        GlobalUser.sex = biologicalSex
        self.saveUserProfile(value: biologicalSex, description: "sex")
    }
    func getBirthday(healthManager: HKHealthStore) {
        var birth = DateComponents(calendar: Calendar.current)
        do {
            birth = try healthManager.dateOfBirthComponents()
        } catch {}
        if birth.isValidDate {
            let dateBirthday = String(describing: birth.day!) + "/" + String(describing: birth.month!) + "/" + String(describing: birth.year!)
            GlobalUser.birthday = dateBirthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
            self.saveUserProfile(value: dateBirthday.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: ""), description: "birthday")
        }
    }
    func getHeight(healthManager: HKHealthStore) {
        let sampleTypeHeight = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        let queryheight = HKSampleQuery(sampleType: sampleTypeHeight!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                GlobalUser.height = Int(result.quantity.doubleValue(for: HKUnit.meter())*100)
                self.saveUserProfile(value: Int(result.quantity.doubleValue(for: HKUnit.meter())*100), description: "height")
            }
        }
        healthManager.execute(queryheight)
    }
    func getWeight(healthManager: HKHealthStore) {
        let sampleTypeWeight = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let queryWeight = HKSampleQuery(sampleType: sampleTypeWeight!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                GlobalUser.weight = Int(result.quantity.doubleValue(for: HKUnit.gram()))/1000
                self.saveUserProfile(value: Int(result.quantity.doubleValue(for: HKUnit.gram())/1000), description: "weight")
            }
        }
        healthManager.execute(queryWeight)
    }
    //SALUTE
    
    
    
    
    //CONTROLLA INTERNET
    func checkInternet(s: UIViewController) {
        let reachability = Reachability()!
        if !reachability.isReachable {
            let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
            let retry = UIAlertAction(title: "Retry", style: .default) { (_) -> Void in
                if !reachability.isReachable {
                    self.checkInternet(s: s)
                }
            }
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let urlObj = NSURL.init(string:UIApplicationOpenSettingsURLString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlObj as! URL, options: [ : ], completionHandler: { Success in })
                } else {
                    _ = UIApplication.shared.openURL(urlObj as! URL)
                }
            }
            controller.addAction(settingsAction)
            controller.addAction(retry)
            s.present(controller, animated: true, completion: nil)
        }
    }
    
    
    //CONTACTS
    func getContacts() {
        var contactsNumbers = [String]()
        var mynumber:String? = ""
        
        let contactStore = CNContactStore()
        let request = CNContactFetchRequest(keysToFetch: [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactMiddleNameKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
            ])
        do {
            try contactStore.enumerateContacts(with: request) { contact, stop in
                for phone in contact.phoneNumbers {
                    
                    let phoneNumberDigits = String(phone.value.stringValue.characters.filter { String($0).rangeOfCharacter(from: CharacterSet.decimalDigits) != nil })
                    contactsNumbers.append(phoneNumberDigits)
                    
                    for email in contact.emailAddresses {
                        if mynumber! == "" {
                            let emailDigits = String(email.value)
                            if saveData.value(forKey: "emailFacebook") != nil {
                                if emailDigits == String(describing: saveData.value(forKey: "emailFacebook")!) {
                                    mynumber = phoneNumberDigits
                                }
                            }
                            else if saveData.value(forKey: "emailtwitter") != nil {
                                if emailDigits == String(describing: saveData.value(forKey: "emailtwitter")!) {
                                    mynumber = phoneNumberDigits
                                }
                            }
                            else if saveData.value(forKey: "emailGoogle") != nil {
                                if emailDigits == String(describing: saveData.value(forKey: "emailGoogle")!) {
                                    mynumber = phoneNumberDigits
                                }
                            }
                        }
                    }
                    
                }
            }
        } catch let enumerateError {
            print(enumerateError.localizedDescription)
        }
        
        if mynumber != nil {
            GlobalUser.phoneNumber = mynumber!
        }
        
        //self.sendContact(c: contactsNumbers) //INVIA DATI AL SERVER
        
    }
    
    func sendContact(c: Array<Any>) {
        let parameter = [
            "numbers": c//STRING
            ] as [String : Any]
        
        Alamofire.request("https://api.mhint.eu/user", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON { response in
            print(response)
        }
    }
    
    
    //POSIZIONE
    func getLocation(latitude: Double, longitude: Double) {
        
        let accuracy:Double = 10000
        //let accuracy:Double = 10
        
        let lat = Double(round(latitude*accuracy)/accuracy)
        let lon = Double(round(longitude*accuracy)/accuracy)
        
        if lat != saveData.double(forKey: "latitudeHistory") || lon != saveData.double(forKey: "longitudeHistory") {
            
            let parameter = [
                "mail": saveData.string(forKey: "email")!//STRING
                , "lat": String(lat)
                , "long": String(lon)
                ] as [String : Any]
            
            Alamofire.request("https://api.mhint.eu/userpositions", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON {_ in }
            
            saveData.set(lat, forKey: "latitudeHistory")
            saveData.set(lon, forKey: "longitudeHistory")
            
            print("POSIZIONE INVIATA")
            print("Longitudine: ", lon)
            print("Latitudine: ", lat)
            
        }
        
    }
    
    //LOADING CHAT
    func loadingChat(s: UIViewController, frame: CGRect, nameGif: String){
        let imageView = GIFImageView(frame: frame)
        imageView.animate(withGIFNamed: nameGif)
        imageView.tag = 9561
        s.view.addSubview(imageView)
    }
    
    func removeLoadingChat(s: UIViewController) {
        for locView in s.view.subviews {
            if locView.isKind(of: GIFImageView.self) {
                if locView.tag == 9561 {
                    locView.removeFromSuperview()
                }
            }
        }
    }
    
}
