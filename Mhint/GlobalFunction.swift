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

class GlobalFunc: UIView{
    
    var globalSize = GlobalSize()
    var themeColor:Bool = true
    var viewChatController = UIViewController()
    
    //CAMBIARE COLORE TEMA
    func changeColor(s: UIViewController, collectionV: UICollectionView, backgroundImage: UIView) {
        if themeColor {
            //TEMA DIVENTA NERO
            let black = GlobalColor().colorBlack
            s.view.backgroundColor = black
            collectionV.backgroundColor = black
            backgroundImage.backgroundColor = black
            s.navigationController?.navigationBar.barTintColor = black
            s.navigationController?.navigationBar.backgroundColor = black
            themeColor = false
        } else{
            //TEMA DIVENTA BIANCO
            let white = GlobalColor().colorWhite
            s.view.backgroundColor = white
            collectionV.backgroundColor = white
            backgroundImage.backgroundColor = white
            s.navigationController?.navigationBar.barTintColor = white
            s.navigationController?.navigationBar.backgroundColor = white
            themeColor = true
        }
    }
    
    //NAVIGATION BAR TOP CHAT
    func navBar(nav: UINavigationItem, s: UIViewController, show: Bool) {
        
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
        
//        s.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirLTStd-Medium", size: 15)!]
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
    
    //navigationRight v.a.
    func navBarRightChat(nav: UINavigationItem, s: UIViewController) {
        let btnMenu = UIButton.init(type: .custom)
        btnMenu.setTitle("v.a.", for: .normal)
        btnMenu.setTitleColor(.black, for: .normal)
        btnMenu.titleLabel?.font = UIFont(name: "AvenirLTStd-Medium", size: 12)
        btnMenu.frame = CGRect(x: 0, y: 0, width: globalSize.sizeIconMenuBar, height: globalSize.sizeIconMenuBar)
        viewChatController = s
        btnMenu.addTarget(s, action: #selector(goToChat), for: .touchUpInside)
        nav.rightBarButtonItem = UIBarButtonItem(customView: btnMenu)
    }
    
    func goToChat(sender: UIButton) {
        print("cadibafad")
        let newViewController = ChatController(collectionViewLayout: layout)
        viewChatController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    //NAVIGATION BAR INSIDE VIEW
    func navBarSubView(nav: UINavigationItem, s: UIViewController, title: String) {
        navBarRightChat(nav: nav, s: s)
        
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
    
    //PRENDE I DATI PER IL TEACH
    func getTeach() -> (Array<String>, Array<String>) {
        let titleArray = ["Cantonese Rice", "Fragola", "Burro", "Birra", "Mango Sticky Rice"]
        let imageArray = ["http://www.rostianjin.it/images/menu/riso-cantonese.jpg", "http://www.thevaporstudio.net/uploads/4/8/2/8/48280647/s251326635458941086_p100_i1_w1024.jpeg", "https://media1.popsugar-assets.com/files/thumbor/II_C9ixzaGfnFoSUinArDuurbo4/fit-in/1024x1024/filters:format_auto-!!-:strip_icc-!!-/2017/01/26/994/n/1922195/e8b3cb2e588a7d72610472.15290441_edit_img_image_43060949_1485470765/i/What-Difference-Between-Salted-Unsalted-Butter.jpg", "https://agrime.it/wp-content/uploads/2016/09/11_40_31_803_image-1024x1024.jpg", "https://c1.staticflickr.com/6/5530/11139105454_a62724c244_b.jpg"]
        return (titleArray, imageArray)
    }
    
    
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
        if GlobalUser.birthday == nil {
            do {
                birth = try healthManager.dateOfBirthComponents()
            } catch {}
            if birth.isValidDate {
                let dateBirthday = String(describing: birth.year!) + "-" + String(describing: birth.month!) + "-" + String(describing: birth.day!)
                GlobalUser.birthday = birth
                self.saveUserProfile(value: dateBirthday, description: "birthday")
            }
        } else {
            GlobalUser.birthday = birth
        }
    }
    func getHeight(healthManager: HKHealthStore) {
        let sampleTypeHeight = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        let queryheight = HKSampleQuery(sampleType: sampleTypeHeight!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                GlobalUser.height = Float(result.quantity.doubleValue(for: HKUnit.meter()))
                self.saveUserProfile(value: Float(result.quantity.doubleValue(for: HKUnit.meter())), description: "height")
            }
        }
        healthManager.execute(queryheight)
    }
    func getWeight(healthManager: HKHealthStore) {
        let sampleTypeWeight = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let queryWeight = HKSampleQuery(sampleType: sampleTypeWeight!, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample {
                GlobalUser.weight = Float(result.quantity.doubleValue(for: HKUnit.gram()))/1000
                self.saveUserProfile(value: Float(result.quantity.doubleValue(for: HKUnit.gram())/1000), description: "weight")
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
        var mynumber:String? = nil
        
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
        
        let accuracy:Double = 10000000
        
        if Double(round(latitude*accuracy)/accuracy) != saveData.double(forKey: "latitudeHistory") || Double(round(longitude*accuracy)/accuracy) != saveData.double(forKey: "longitudeHistory") {
            
            let parameter = [
                "mail": saveData.string(forKey: "email")!//STRING
                , "lat": String(Double(round(latitude*accuracy)/accuracy))
                , "long": String(Double(round(longitude*accuracy)/accuracy))
                ] as [String : Any]
            
            Alamofire.request("https://api.mhint.eu/userpositions", method: .post, parameters: parameter, encoding: JSONEncoding.default).responseJSON {_ in }
            
            saveData.set(Double(round(latitude*accuracy)/accuracy), forKey: "latitudeHistory")
            saveData.set(Double(round(longitude*accuracy)/accuracy), forKey: "longitudeHistory")
            
            print("POSIZIONE CAMBIATA")
            print("Longitudine: ", Double(round(latitude*accuracy)/accuracy))
            print("Latitudine: ", Double(round(longitude*accuracy)/accuracy))
            print("Email: ", saveData.string(forKey: "email")!)
            
        }
        
    }
    
}
